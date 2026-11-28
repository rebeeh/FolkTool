# FolkTool — Windows Installation, Code Signing & Trust Guide

## 1. How FolkTool Is Built & Packaged

FolkTool targets **Windows 10 / 11 x64** (`flutter build windows --release --build-name=<version> --build-number=<build> --dart-define=APP_VERSION=<version> --dart-define=APP_BUILD_NUMBER=<build>`).

1. **Application binary (`FolkTool.exe`)**:
   - Compiled by MSVC via `windows/CMakeLists.txt`, [`windows/runner/CMakeLists.txt`](../windows/runner/CMakeLists.txt), and [`windows/runner/Runner.rc`](../windows/runner/Runner.rc).
   - Declares `/MANIFESTUAC:level='asInvoker' uiAccess='false'` alongside [`windows/runner/runner.exe.manifest`](../windows/runner/runner.exe.manifest) (`PerMonitorV2` DPI awareness) so normal app usage runs under standard user privileges without triggering full-app UAC elevation.
   - Creates a session-scoped named mutex (`Local\FolkToolRunningMutex`) in [`windows/runner/main.cpp`](../windows/runner/main.cpp) so upgrades, clean installs, and uninstallers reliably detect running instances.
   - Embeds `assets/icons/icon.ico` (multi-resolution `16x16`, `24x24`, `32x32`, `48x48`, `64x64`, `128x128`, `256x256`) via `IDI_APP_ICON`.
   - Embeds consistent PE `VS_VERSION_INFO` derived from [`pubspec.yaml`](../pubspec.yaml) (`FileVersion` / `ProductVersion`, `ProductName`, `CompanyName`, `FileDescription`, `LegalCopyright`), verified by [`scripts/verify_pe_version.ps1`](../scripts/verify_pe_version.ps1) and [`scripts/verify_pe_icon.ps1`](../scripts/verify_pe_icon.ps1).
2. **Installer (`FolkTool-Setup.exe`) & Uninstaller (`unins000.exe`)**:
   - Compiled from the single authoritative script [`installer.iss`](../installer.iss) using Inno Setup 6 (`ISCC.exe`).
   - Bundles `FolkTool.exe`, `flutter_windows.dll`, `url_launcher_windows_plugin.dll`, `data\`, `bin\` (excluding build-only `7za.exe`), `apk\`, `assets\`, and `kp_versions\`.
   - Embeds `assets/icons/icon.ico` into `FolkTool-Setup.exe`, `unins000.exe` (`SetupIconFile`), Start Menu/Desktop shortcuts, and Windows Installed Apps (`UninstallDisplayIcon={app}\FolkTool.exe,0`).
   - When signing is enabled (`-DEnableSigning=1`), Inno Setup signs `unins000.exe` (`SignedUninstaller=yes`), temporary installer stubs, and `FolkTool-Setup.exe` inline via [`scripts/sign_pe.ps1`](../scripts/sign_pe.ps1) before finalizing the package so no signed binary is altered post-signing.

---

## 2. Authenticode Code Signing & Publisher Identity

### Root Causes of `Publisher: Unknown` and Smart App Control Blocks

| Prompt / Block | Root Cause | Technical Fix |
|---|---|---|
| **UAC `Publisher: Unknown`** | No valid Authenticode digital signature (or an expired/untrusted self-signed certificate) is embedded in `FolkTool-Setup.exe` / `unins000.exe`. Icons or PE version resources alone cannot populate UAC publisher identity. | SHA-256 Authenticode signing with an RFC 3161 trusted timestamp via [`scripts/sign_pe.ps1`](../scripts/sign_pe.ps1) on `FolkTool.exe`, runtime/plugin DLLs, `unins000.exe` (`SignedUninstaller=yes`), temporary setup stubs, and `FolkTool-Setup.exe`. |
| **Windows 11 Smart App Control (SAC)** | In Enforcement mode, SAC requires **both** a valid **RSA** Authenticode signature chaining to a **Microsoft Trusted Root Program CA** (ECC/ECDSA certs are unsupported by SAC) **for every executable and DLL loaded at runtime** (or Microsoft ISG cloud reputation). | Sign all first-party EXEs, DLLs, uninstaller, and installer using an **RSA** trusted certificate (Microsoft Artifact Signing or Commercial OV CA), keep credentials out of Git, audit every bundled third-party binary, and verify post-sign via [`scripts/audit_pe_trust.ps1`](../scripts/audit_pe_trust.ps1). |

### Supported Trusted Signing Providers

[`.github/workflows/windows-ci.yml`](../.github/workflows/windows-ci.yml) keeps all signing material outside Git, blocks secret exposure on pull requests, fails hard on release tags (`v*`) or `require_signing=true` if trusted credentials are absent or verification fails, and supports:

1. **Microsoft Artifact Signing (Recommended when region/account eligible)**
   - Uses passwordless GitHub OIDC (`azure/login@v2`) plus `Microsoft.Azure.ArtifactSigningClientTools` (`Azure.CodeSigning.Dlib.dll`) invoked through `signtool.exe` (`/fd SHA256 /tr http://timestamp.acs.microsoft.com /td SHA256`) and [`scripts/sign_pe.ps1`](../scripts/sign_pe.ps1).
   - Note: Availability is subject to Microsoft's regional and organization/individual identity-verification eligibility rules at provisioning time.
2. **Commercial Organization Validation (OV) Code-Signing Certificate (`WINDOWS_CERT_PFX_BASE64` / Cloud HSM)**
   - RSA OV Authenticode certificate issued by a Microsoft Trusted Root CA (e.g., DigiCert, Sectigo, GlobalSign), timestamped with SHA-256 RFC 3161 (`http://timestamp.digicert.com` or `$env:SIGN_TSA_URL`). Available globally (including regions outside Artifact Signing preview/eligibility).
   - `WINDOWS_CERT_PFX_BASE64` and `WINDOWS_CERT_PASSWORD` stay inside GitHub Actions secrets and are read by `scripts/sign_pe.ps1` via environment variables rather than appearing on Inno Setup command lines or logs.
3. **SignPath Foundation (Open-Source Program)**
   - FolkTool (`GPL-3.0`, public GitHub Actions builds) meets open-source program eligibility criteria (`https://signpath.org/`). Because SignPath Foundation signs uploaded workflow artifacts asynchronously rather than inline during `ISCC.exe` execution, enabling SignPath requires wiring an artifact submission job around built binaries alongside `FolkTool-Setup.exe` (or keeping Artifact Signing / OV HSM for inline `SignedUninstaller=yes` signing).

> **Self-signed certificates** are **never** generated or used in release builds. Pull-request and unconfigured branch builds are strictly unsigned CI verification builds and cannot publish a GitHub Release.

---

## 3. Executable Chain & Bundled Third-Party Dependencies Audit

FolkTool never re-signs third-party binaries with FolkTool's identity unless upstream provenance, ownership, licensing, and policy explicitly permit it:

| Component | Source / Purpose | Verified Signature State | Smart App Control & Runtime Impact |
|---|---|---|---|
| `FolkTool.exe`, `flutter_windows.dll`, `url_launcher_windows_plugin.dll`, `FolkTool-Setup.exe`, `unins000.exe` | First-party app, Flutter Windows engine/plugin, Inno installer & uninstaller | **Signed in release CI** when signing credentials are configured (RSA + SHA-256 + RFC 3161) | Passes UAC publisher verification and SAC first-party trust once signed by a Microsoft Trusted Root CA / Artifact Signing |
| `bin/adb.exe`, `bin/fastboot.exe`, `bin/AdbWinApi.dll`, `bin/AdbWinUsbApi.dll`, `bin/sqlite3.exe`, `bin/mke2fs.exe`, `bin/make_f2fs*.exe` | Official Google Android SDK Platform-Tools (`toolchain_manifest.json`) | **Signed by Google LLC** (DigiCert Trusted Root G4, RSA 4096, SHA-256) — original signature preserved & checked in CI | Trusted cryptographic publisher |
| `drive/Oppo+USB+Driver+Setup+V4.0.1.6.exe` | OPPO official USB driver installer (invoked only on explicit user click) | **Signed by Guangdong OPPO Mobile Telecommunications Corp., Ltd.** (GlobalSign R45, RSA 4096, SHA-256, timestamped through 2034) | Verified via `Get-AuthenticodeSignature` + explicit user UAC (`-Verb RunAs`) |
| `drive/fastboot_driver_64.exe`, `drive/fastboot_driver_32.exe` | Legacy third-party fastboot driver wrappers (invoked only on user click) | **Legacy SHA-1 VeriSign/Symantec signature by Beijing Kingsoft Security software Co.,Ltd** | Checked at runtime via `Get-AuthenticodeSignature`; deprecated SHA-1 / expired Symantec chains may fail validation on Windows 11. Prefer Microsoft Windows Update Optional Updates or official OEM installers |
| `drive/adb_driver.exe`, `drive/MTK_USB_All_v1.0.8.exe` | Legacy bundled USB driver installers | **Unsigned** | **Blocked at runtime** by `DriverService.installDriverDetailed()` (cannot be launched automatically without a valid signature) |
| `kp_versions/*/windows/kptools.exe`, `msys-2.0.dll`, `msys-z.dll` (+ `bin/kptools.exe`) | Upstream KernelPatch MSYS2 utilities (`bmax121/KernelPatch`, `LyraVoid/KernelPatch`) pinned by SHA-256 in `toolchain_manifest.json` | **Unsigned upstream binaries** (no signed upstream release published by KernelPatch) | **Limitation**: In Windows 11 Smart App Control **Enforcement** mode, image-patching operations that spawn unsigned `kptools.exe` / load `msys-2.0.dll` may still be blocked by OS policy unless Microsoft cloud reputation recognizes them or signed upstream builds are published |
| `bin/7za.exe` | Build-host archive tool used only by `fetch_verified_toolchain.ps1` | **Unsigned** | **Excluded from `FolkTool-Setup.exe` and `FolkTool-Windows-Portable.zip`** |

---

## 4. SmartScreen Reputation Limitations

Code signing with a trusted CA (Artifact Signing, SignPath, or Commercial OV certificate) provides cryptographic **publisher identity**, **tamper detection**, and **Smart App Control trust**, **not instant Microsoft Defender SmartScreen reputation**:

- Newly released binaries and fresh version bumps can still show a SmartScreen warning (`Windows protected your PC`) until Microsoft's cloud telemetry accumulates clean install/execution volume.
- Purchasing an EV certificate does **not** guarantee instant SmartScreen bypass under current Microsoft reputation rules.
- Maintaining the same publisher subject across every release, timestamping all signatures, and publishing exclusively through official GitHub Releases with `SHA256SUMS.txt` allows reputation to accumulate consistently.

---

## 5. How to Verify an Official FolkTool Release

Before running `FolkTool-Setup.exe` or extracting `FolkTool-Windows-Portable.zip`:

1. **Download only from the official GitHub Releases page** together with `SHA256SUMS.txt`.
2. **Verify the SHA-256 checksum**:
   ```pwsh
   Get-FileHash .\FolkTool-Setup.exe -Algorithm SHA256
   ```
   Confirm the hash matches `SHA256SUMS.txt`.
3. **Verify the Authenticode signature, RSA key, chain, and RFC 3161 timestamp**:
   ```pwsh
   Get-AuthenticodeSignature .\FolkTool-Setup.exe | Format-List Status, SignerCertificate, TimeStamperCertificate
   signtool verify /pa /v .\FolkTool-Setup.exe
   ```
   Confirm `Status` is `Valid`, `TimeStamperCertificate` is present, and the certificate belongs to the documented official FolkTool publisher.

---

## 6. Privileges, Drivers & Installation Lifecycle

### Least-Privilege Execution & On-Demand UAC
- `FolkTool.exe` runs `asInvoker` (standard user), never forcing full-app admin elevation.
- **`installer.iss`** sets `PrivilegesRequired=lowest` + `PrivilegesRequiredOverridesAllowed=dialog` + `UsePreviousPrivileges=yes`, allowing per-user install (`%LOCALAPPDATA%\Programs\FolkTool`) without elevation or all-users install (`%ProgramFiles%\FolkTool`) with explicit UAC consent.
- Bundled driver installers run **only when explicitly triggered** in the Driver Install screen, after:
  1. Checking Authenticode signature (`Get-AuthenticodeSignature`), blocking unsigned binaries.
  2. Showing explicit publisher/mode confirmation in the UI.
  3. Requesting on-demand UAC (`Start-Process -Verb RunAs -Wait -PassThru`) and inspecting the real installer exit code (`0` success, `3010` reboot required, `1223` user cancelled UAC, non-zero failure reported accurately).

### Installation, Upgrade, Repair, Clean Install & Uninstall

- **First-Time Installation**: Creates Start Menu app + uninstall shortcuts, optional Desktop shortcut (`{autodesktop}`), Uninstall registry registration under `AppId={{A1B2C3D4-E5F6-4789-A0B1-C2D3E4F5A6B7}`, post-install file integrity checks, and keeps post-install app launch opt-in (`unchecked`).
- **Normal Upgrade & Repair**: Detects both GUID (`{A1B2C3D4-...}_is1`) and legacy `FolkTool_is1` installations across `HKLM64`/`HKCU`, preserves install path and user preferences/data, stops app-scoped processes (`{app}\bin\adb.exe kill-server` and `{app}\*` EXEs only), repairs corrupted `unins000.exe`/`unins000.dat` mismatches, removes duplicate/legacy Uninstall keys, restores missing/replaced files, and runs `VerifyPostInstallIntegrity` before reporting success.
- **Clean Installation**: Available in wizard UI or via `/CLEANINSTALL`. Stops app-scoped processes safely, cleans old install directory binaries (`unins000.*` too when relocating directories) and app subdirectories (`data`, `bin`, `apk`, `assets`, `kp_versions`, `redist`) before extracting fresh files. Resetting AppData requires explicit checkbox confirmation (or `/PURGEAPPDATA`) and backs up `shared_preferences.json` to `Documents\FolkTool\backup\settings_backup_<timestamp>.json` first.
- **Uninstallation**: Accessible from **Windows Settings → Apps → Installed apps**, **Control Panel → Programs and Features**, and **Start Menu → Uninstall FolkTool**:
  1. Interactive confirmation runs **before** stopping running FolkTool processes (`CurUninstallStepChanged(usAppMutexCheck)`).
  2. Safely shuts down `{app}`-scoped processes and bundled `adb.exe` server.
  3. Cleans orphaned `%TEMP%\folkpatch_*` working folders and deletes only app-owned files, shortcuts, and Uninstall registry entries.
  4. **Preserves user data by default**: `%APPDATA%\FolkTool`, logs, `Documents\FolkTool\patched\`, `Documents\FolkTool\backup\`, user `.img`/`.kpm` files, and shared system USB/ADB drivers are kept unless optional app-data purge (or `/PURGEAPPDATA`) is chosen—and `patched/`, `backup/`, and system drivers are **never** deleted even during purge.
  5. Audits critical app binaries during `usPostUninstall` and warns explicitly if locked files require a Windows reboot.

---

## 7. Remaining Limitations & Manual Pre-Release Verification

1. **Signing credentials are not yet provisioned in repository secrets**: Until either Microsoft Artifact Signing (if region/entity-eligible) or a Commercial OV certificate (`WINDOWS_CERT_PFX_BASE64`) is configured in GitHub repository settings/secrets, CI produces unsigned verification builds (`IS_SIGNED=false`) and tag releases (`v*`) are blocked by policy.
2. **Unsigned upstream `kptools.exe` / MSYS2 binaries**: Patching depends on upstream KernelPatch Windows builds (`bmax121/KernelPatch`, `LyraVoid/KernelPatch`) that currently distribute unsigned MSYS2 binaries; strict Smart App Control enforcement may block them until signed upstream builds are published or cloud reputation is established.
3. **Interactive Windows 11 Smart App Control & SmartScreen evaluation**: GitHub Actions `windows-latest` runners verify compilation, metadata, PE audit, and silent installer/uninstaller lifecycles (`C:\Temp\...`, upgrades, locks, ACLs, `/CLEANINSTALL`, `/PURGEAPPDATA`), **not** live Smart App Control Enforcement or Defender SmartScreen dialogs. Interactive validation on a clean physical/VM Windows 11 system with SAC and SmartScreen enabled should follow signing credential provisioning prior to public release.
