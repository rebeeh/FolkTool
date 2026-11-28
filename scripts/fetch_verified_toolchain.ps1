param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [string]$ManifestPath = "",
    [string]$CacheDir = ""
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem

if ([string]::IsNullOrWhiteSpace($ManifestPath)) {
    $ManifestPath = Join-Path $RepoRoot "assets\manifests\toolchain_manifest.json"
}
if ([string]::IsNullOrWhiteSpace($CacheDir)) {
    $CacheDir = Join-Path $RepoRoot ".toolchain_cache"
}
New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding utf8 | ConvertFrom-Json
$binDir = Join-Path $RepoRoot "bin"
$sevenZip = Join-Path $binDir "7za.exe"
if (-not (Test-Path -LiteralPath $sevenZip)) {
    throw "Required archive extractor not found: $sevenZip"
}

function Get-Sha256Lower([string]$FilePath) {
    return (Get-FileHash -LiteralPath $FilePath -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Ensure-VerifiedDownload([string]$Url, [string]$DestPath, [string]$ExpectedSha256) {
    $expected = $ExpectedSha256.ToLowerInvariant()
    if ((Test-Path -LiteralPath $DestPath) -and ((Get-Sha256Lower $DestPath) -eq $expected)) {
        Write-Host "Cache hit (verified): $(Split-Path -Leaf $DestPath)"
        return
    }
    Write-Host "Downloading verified artifact: $Url"
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $DestPath -UseBasicParsing -TimeoutSec 120
            break
        } catch {
            if ($attempt -eq 3) { throw }
            Write-Warning "Download attempt $attempt failed ($($_.Exception.Message)); retrying..."
            Start-Sleep -Seconds (2 * $attempt)
        }
    }
    $actual = Get-Sha256Lower $DestPath
    if ($actual -ne $expected) {
        Remove-Item -LiteralPath $DestPath -Force -ErrorAction SilentlyContinue
        throw "SHA-256 verification failed for $Url! Expected $expected, got $actual"
    }
    Write-Host "Verified SHA-256 ($expected): $(Split-Path -Leaf $DestPath)"
}

Write-Host "=== 1. Updating official Google Android Platform-Tools ($($manifest.platformTools.version)) ==="
$ptZipPath = Join-Path $CacheDir "platform-tools-$($manifest.platformTools.version).zip"
Ensure-VerifiedDownload -Url $manifest.platformTools.sourceUrl -DestPath $ptZipPath -ExpectedSha256 $manifest.platformTools.zipSha256

$ptTemp = Join-Path $CacheDir "pt_extract"
if (Test-Path -LiteralPath $ptTemp) { Remove-Item -LiteralPath $ptTemp -Recurse -Force }
[System.IO.Compression.ZipFile]::ExtractToDirectory($ptZipPath, $ptTemp)
$ptExtractedDir = Join-Path $ptTemp "platform-tools"
if (-not (Test-Path -LiteralPath $ptExtractedDir)) {
    throw "Extracted platform-tools directory missing inside $ptZipPath"
}

# Verify expected binary hashes & Authenticode signature before installing into bin/
foreach ($prop in $manifest.platformTools.files.PSObject.Properties) {
    $fileName = $prop.Name
    $meta = $prop.Value
    $extractedFile = Join-Path $ptExtractedDir $fileName
    if (-not (Test-Path -LiteralPath $extractedFile)) {
        throw "Expected Platform-Tools file missing: $fileName"
    }
    $actualHash = Get-Sha256Lower $extractedFile
    if ($actualHash -ne $meta.sha256.ToLowerInvariant()) {
        throw "Platform-Tools member hash mismatch ($fileName): expected $($meta.sha256), got $actualHash"
    }
    if ($fileName -in @("adb.exe", "fastboot.exe")) {
        $sig = Get-AuthenticodeSignature -LiteralPath $extractedFile
        if ($sig.Status -ne "Valid" -or ($sig.SignerCertificate.Subject -notlike "*$($manifest.platformTools.expectedSigner)*")) {
            throw "Official Google signature verification failed on ${fileName}: status=$($sig.Status), subject=$($sig.SignerCertificate.Subject)"
        }
        Write-Host "  Verified Google signature on $fileName ($($sig.SignerCertificate.Subject))"
    }
}

New-Item -ItemType Directory -Force -Path $binDir | Out-Null
Get-ChildItem -LiteralPath $ptExtractedDir -File | ForEach-Object {
    $targetName = if ($_.Name -eq "source.properties") { "platform-tools.source.properties" } else { $_.Name }
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $binDir $targetName) -Force
}

Write-Host "=== 2. Updating verified FolkPatch & APatch managers, kpimg catalogue, and kptools.exe ==="
$kpVersionsDir = Join-Path $RepoRoot "kp_versions"
$sharedWinDir = Join-Path $kpVersionsDir "windows"
New-Item -ItemType Directory -Force -Path $sharedWinDir | Out-Null

foreach ($targetProp in $manifest.targets.PSObject.Properties) {
    $targetKey = $targetProp.Name
    $target = $targetProp.Value
    Write-Host "Processing target: $($target.product) ($targetKey)"

    # 2a. Extract verified kptools.exe + MSYS2 runtime for this target
    $kpArchiveName = "$targetKey-kptools-$($target.kptools.version).7z"
    $kpArchivePath = Join-Path $CacheDir $kpArchiveName
    Ensure-VerifiedDownload -Url $target.kptools.archiveUrl -DestPath $kpArchivePath -ExpectedSha256 $target.kptools.archiveSha256

    $kpExtractDir = Join-Path $CacheDir "${targetKey}_kptools"
    if (Test-Path -LiteralPath $kpExtractDir) { Remove-Item -LiteralPath $kpExtractDir -Recurse -Force }
    & $sevenZip x -y "-o$kpExtractDir" $kpArchivePath | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "7za extraction failed for $kpArchivePath" }

    $extractedKptools = Get-ChildItem -Path $kpExtractDir -Filter "kptools.exe" -Recurse | Select-Object -First 1
    if (-not $extractedKptools) { throw "kptools.exe not found inside $kpArchivePath" }
    $kptoolsHash = Get-Sha256Lower $extractedKptools.FullName
    if ($kptoolsHash -ne $target.kptools.kptoolsExeSha256.ToLowerInvariant()) {
        throw "kptools.exe SHA-256 mismatch for ${targetKey}: expected $($target.kptools.kptoolsExeSha256), got $kptoolsHash"
    }

    $targetWinDir = Join-Path $RepoRoot ($target.kptools.installDir.Replace('/', '\'))
    New-Item -ItemType Directory -Force -Path $targetWinDir | Out-Null
    Get-ChildItem -LiteralPath $extractedKptools.DirectoryName -File | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $targetWinDir $_.Name) -Force
    }

    # Keep shared FolkTool kptools fallback updated with FolkPatch engine
    if ($targetKey -eq "folkpatch") {
        Get-ChildItem -LiteralPath $extractedKptools.DirectoryName -File | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $sharedWinDir $_.Name) -Force
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $binDir $_.Name) -Force
        }
    }

    # 2b. Verify & stage APKs and kpimg binaries per release
    foreach ($rel in $target.releases) {
        $apkCachePath = Join-Path $CacheDir $rel.apkAssetName
        Ensure-VerifiedDownload -Url $rel.apkUrl -DestPath $apkCachePath -ExpectedSha256 $rel.apkSha256

        $kpimgDestPath = Join-Path $kpVersionsDir ($rel.kpimgRelPath.Replace('/', '\'))
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $kpimgDestPath) | Out-Null

        $zip = [System.IO.Compression.ZipFile]::OpenRead($apkCachePath)
        try {
            $entry = $zip.GetEntry("assets/kpimg")
            if (-not $entry) { throw "assets/kpimg missing in $($rel.apkAssetName)" }
            $inStream = $entry.Open()
            $outStream = [System.IO.File]::Create($kpimgDestPath)
            try {
                $inStream.CopyTo($outStream)
            } finally {
                $outStream.Dispose()
                $inStream.Dispose()
            }
        } finally {
            $zip.Dispose()
        }

        $actualKpimgHash = Get-Sha256Lower $kpimgDestPath
        if ($actualKpimgHash -ne $rel.kpimgSha256.ToLowerInvariant()) {
            throw "Extracted kpimg SHA-256 mismatch for $($rel.id): expected $($rel.kpimgSha256), got $actualKpimgHash"
        }

        if ($rel.recommended) {
            $defaultApkPath = Join-Path $RepoRoot ($target.defaultApkDest.Replace('/', '\'))
            $defaultKpimgPath = Join-Path $RepoRoot ($target.defaultKpimgDest.Replace('/', '\'))
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $defaultApkPath) | Out-Null
            Copy-Item -LiteralPath $apkCachePath -Destination $defaultApkPath -Force
            Copy-Item -LiteralPath $kpimgDestPath -Destination $defaultKpimgPath -Force
            if ($targetKey -eq "folkpatch") {
                Copy-Item -LiteralPath $kpimgDestPath -Destination (Join-Path $RepoRoot "assets\kpimg") -Force
            }
            Write-Host "  Set recommended default $($target.product): $($rel.managerVersion) (KP $($rel.kernelPatchVersion))"
        }
    }
}

Write-Host "=== 3. Runtime version verification (adb / fastboot) ==="
& (Join-Path $binDir "adb.exe") version
& (Join-Path $binDir "fastboot.exe") --version

Write-Host "SUCCESS: Verified toolchain materialized into bin/, apk/, and kp_versions/."
