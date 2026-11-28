param(
  [Parameter(Mandatory = $true)]
  [string[]]$Targets,
  [switch]$RequireValidSignature,
  [string]$ExpectedSubjectLike = "",
  [string]$SigntoolPath = ""
)

$ErrorActionPreference = "Stop"

if ($RequireValidSignature -and [string]::IsNullOrWhiteSpace($SigntoolPath)) {
  $SigntoolPath = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\signtool.exe" -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
  if (-not $SigntoolPath) {
    throw "signtool.exe not found while -RequireValidSignature was requested."
  }
}

$now = Get-Date
foreach ($target in $Targets) {
  if (-not (Test-Path -LiteralPath $target)) {
    throw "Audit target not found: $target"
  }

  $sig = Get-AuthenticodeSignature -LiteralPath $target
  $cert = $sig.SignerCertificate
  $subject = if ($cert) { $cert.Subject } else { "<none>" }
  $issuer = if ($cert) { $cert.Issuer } else { "<none>" }
  $notAfter = if ($cert) { $cert.NotAfter.ToString("u") } else { "<n/a>" }
  $keyAlg = if ($cert) { $cert.PublicKey.Oid.FriendlyName } else { "<n/a>" }
  $sigAlg = if ($cert) { $cert.SignatureAlgorithm.FriendlyName } else { "<n/a>" }
  $tsIssuer = if ($sig.TimeStamperCertificate) { $sig.TimeStamperCertificate.Subject } else { "<none>" }

  Write-Host ("PE Trust Audit | {0} | Status={1} | Key={2} | SigAlg={3} | Subject={4} | Issuer={5} | Expires={6} | Timestamp={7}" -f `
    $target, $sig.Status, $keyAlg, $sigAlg, $subject, $issuer, $notAfter, $tsIssuer)

  if ($RequireValidSignature) {
    if ($sig.Status -ne "Valid") {
      throw "Signature status for $target is $($sig.Status), expected Valid."
    }
    if (-not $cert) {
      throw "Missing SignerCertificate on $target."
    }
    if (-not $sig.TimeStamperCertificate) {
      throw "Missing RFC 3161 timestamp certificate on $target."
    }
    if ($cert.NotBefore -gt $now -or $cert.NotAfter -le $now) {
      throw "Signing certificate on $target is outside current validity window ($($cert.NotBefore.ToString('u')) .. $notAfter)."
    }
    # Smart App Control only accepts RSA certificates (ECC/ECDSA certs are unsupported).
    if ($cert.PublicKey.Oid.Value -ne "1.2.840.113549.1.1.1" -and $keyAlg -ne "RSA") {
      throw "Unsupported public key algorithm '$keyAlg' on $target; RSA is required for Windows Smart App Control compatibility."
    }
    if ($sigAlg -notmatch "sha(256|384|512)") {
      throw "Unsupported/weak signature digest '$sigAlg' on $target; SHA-256+ is required."
    }
    if (-not [string]::IsNullOrWhiteSpace($ExpectedSubjectLike) -and ($subject -notlike $ExpectedSubjectLike)) {
      throw "Certificate subject '$subject' on $target does not match expected pattern '$ExpectedSubjectLike'."
    }
    & $SigntoolPath verify /pa /v $target | Out-Host
    if ($LASTEXITCODE -ne 0) {
      throw "signtool verify /pa failed for $target with exit code $LASTEXITCODE."
    }
  }
}
