param(
    [Parameter(Mandatory = $true)]
    [string]$BinaryPath,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedVersion,
    [string]$ExpectedProductName = "FolkTool",
    [switch]$CheckStringVersion
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $BinaryPath)) {
    throw "Binary not found for PE version check: $BinaryPath"
}

$expectedParsed = [version]$ExpectedVersion
$info = (Get-Item -LiteralPath $BinaryPath).VersionInfo

Write-Host "PE Version Audit: $BinaryPath"
Write-Host "  ProductName     : $($info.ProductName)"
Write-Host "  CompanyName     : $($info.CompanyName)"
Write-Host "  FileDescription : $($info.FileDescription)"
Write-Host "  LegalCopyright  : $($info.LegalCopyright)"
Write-Host "  FileVersion     : $($info.FileVersion) (Raw: $($info.FileVersionRaw))"
Write-Host "  ProductVersion  : $($info.ProductVersion) (Raw: $($info.ProductVersionRaw))"

$zeroVersion = [version]"0.0.0.0"
if ($info.FileVersionRaw -eq $zeroVersion) {
    throw "FileVersionRaw is 0.0.0.0 on $BinaryPath"
}
if ($info.ProductVersionRaw -eq $zeroVersion) {
    throw "ProductVersionRaw is 0.0.0.0 on $BinaryPath"
}

if ($info.FileVersionRaw -ne $expectedParsed) {
    throw "FileVersionRaw mismatch on ${BinaryPath}: expected $expectedParsed, got $($info.FileVersionRaw)"
}
if ($info.ProductVersionRaw -ne $expectedParsed) {
    throw "ProductVersionRaw mismatch on ${BinaryPath}: expected $expectedParsed, got $($info.ProductVersionRaw)"
}

if ([string]::IsNullOrWhiteSpace($info.ProductName) -or $info.ProductName.Trim() -ne $ExpectedProductName) {
    throw "Unexpected ProductName on ${BinaryPath}: '$($info.ProductName)'"
}
if ([string]::IsNullOrWhiteSpace($info.CompanyName)) {
    throw "Missing CompanyName on $BinaryPath"
}
if ([string]::IsNullOrWhiteSpace($info.FileDescription)) {
    throw "Missing FileDescription on $BinaryPath"
}
if ([string]::IsNullOrWhiteSpace($info.LegalCopyright)) {
    throw "Missing LegalCopyright on $BinaryPath"
}

if ($CheckStringVersion) {
    $verPrefix = "$($expectedParsed.Major).$($expectedParsed.Minor).$($expectedParsed.Build)"
    if ($info.FileVersion -notlike "$verPrefix*") {
        throw "FileVersion string mismatch on ${BinaryPath}: expected prefix '$verPrefix', got '$($info.FileVersion)'"
    }
    if ($info.ProductVersion -notlike "$verPrefix*") {
        throw "ProductVersion string mismatch on ${BinaryPath}: expected prefix '$verPrefix', got '$($info.ProductVersion)'"
    }
}

Write-Host "PASSED: PE version and metadata verified for $BinaryPath ($expectedParsed)."
