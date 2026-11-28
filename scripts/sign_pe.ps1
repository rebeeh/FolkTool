param(
  [Parameter(Mandatory = $true)]
  [string]$Target,
  [switch]$PreserveMicrosoftSignature
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Target)) {
  throw "Signing target does not exist: $Target"
}

$mode = $env:SIGN_MODE
if ([string]::IsNullOrWhiteSpace($mode) -or $mode -eq "none") {
  throw "SIGN_MODE is not configured for Authenticode signing."
}

$signtool = $env:SIGNTOOL_PATH
if ([string]::IsNullOrWhiteSpace($signtool) -or -not (Test-Path -LiteralPath $signtool)) {
  $signtool = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\signtool.exe" -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if ([string]::IsNullOrWhiteSpace($signtool) -or -not (Test-Path -LiteralPath $signtool)) {
  throw "signtool.exe not found on build host."
}

if ($PreserveMicrosoftSignature) {
  $existingSig = Get-AuthenticodeSignature -LiteralPath $Target
  if ($existingSig.Status -eq "Valid" -and $existingSig.SignerCertificate -and
      $existingSig.SignerCertificate.Subject -like "*Microsoft*") {
    Write-Host "Preserving existing Microsoft signature on $Target"
    exit 0
  }
}

$maxAttempts = 3
$lastExit = 1

for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
  if ($mode -eq "azure") {
    $dlib = $env:AZURE_DLIB_PATH
    $meta = $env:AZURE_META_PATH
    if ([string]::IsNullOrWhiteSpace($dlib) -or -not (Test-Path -LiteralPath $dlib)) {
      throw "AZURE_DLIB_PATH missing or invalid: $dlib"
    }
    if ([string]::IsNullOrWhiteSpace($meta) -or -not (Test-Path -LiteralPath $meta)) {
      throw "AZURE_META_PATH missing or invalid: $meta"
    }
    & $signtool sign /v /fd SHA256 /tr "http://timestamp.acs.microsoft.com" /td SHA256 `
      /dlib $dlib /dmdf $meta $Target
    $lastExit = $LASTEXITCODE
  } elseif ($mode -eq "pfx") {
    $pfxPath = $env:SIGN_PFX_PATH
    $pfxPass = $env:SIGN_PFX_PASS
    $tsaUrl = if ([string]::IsNullOrWhiteSpace($env:SIGN_TSA_URL)) {
      "http://timestamp.digicert.com"
    } else {
      $env:SIGN_TSA_URL
    }
    if ([string]::IsNullOrWhiteSpace($pfxPath) -or -not (Test-Path -LiteralPath $pfxPath)) {
      throw "SIGN_PFX_PATH missing or invalid: $pfxPath"
    }
    $signArgs = @("sign", "/f", $pfxPath)
    if (-not [string]::IsNullOrEmpty($pfxPass)) {
      $signArgs += @("/p", $pfxPass)
    }
    $signArgs += @("/fd", "SHA256", "/tr", $tsaUrl, "/td", "SHA256", $Target)
    & $signtool @signArgs
    $lastExit = $LASTEXITCODE
  } else {
    throw "Unsupported SIGN_MODE '$mode'."
  }

  if ($lastExit -eq 0) {
    break
  }

  Write-Warning "Signing attempt $attempt/$maxAttempts failed for $Target (exit $lastExit)."
  if ($attempt -lt $maxAttempts) {
    Start-Sleep -Seconds (2 * $attempt)
  }
}

if ($lastExit -ne 0) {
  throw "Authenticode signing failed for $Target after $maxAttempts attempts (exit $lastExit)."
}

$verified = Get-AuthenticodeSignature -LiteralPath $Target
if ($verified.Status -ne "Valid") {
  throw "Post-sign validation failed for ${Target}: Status=$($verified.Status)"
}
if (-not $verified.TimeStamperCertificate) {
  throw "Post-sign validation failed for ${Target}: missing RFC 3161 timestamp."
}

Write-Host "Signed and timestamped: $Target (Subject=$($verified.SignerCertificate.Subject))"
