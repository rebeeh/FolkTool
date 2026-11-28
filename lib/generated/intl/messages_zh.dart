// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(serial) => "ADB Device Offline (${serial})";

  static String m1(version) => "Android ${version}";

  static String m2(version) => "FolkTool v${version}";

  static String m3(version, build) => "FolkTool v${version} (Build ${build})";

  static String m4(percent) => "Battery ${percent}%";

  static String m5(pkg) => "Package: ${pkg}";

  static String m6(version) => "Bundled ${version}";

  static String m7(path) => "Boot Image: ${path}";

  static String m8(version) => "Version: ${version}";

  static String m9(target) => "Patch Target: ${target}";

  static String m10(device) => "Target Device: ${device}";

  static String m11(count) => "Deleted ${count} saved log file(s)";

  static String m12(path) => "Diagnostics saved: ${path}";

  static String m13(name) => "Install ${name}?";

  static String m14(status) => "Driver installer launched (Signature: ${status}). Reconnect device or reboot Windows if needed.";

  static String m15(publisher) => "Publisher: ${publisher}";

  static String m16(modes) => "Supported Modes: ${modes}";

  static String m17(path) => "ADB executable does not exist: ${path}";

  static String m18(path) => "APK file does not exist: ${path}";

  static String m19(error) => "Backup exception: ${error}";

  static String m20(error) => "Failed to check installed apps: ${error}";

  static String m21(error) => "Driver check failed: ${error}";

  static String m22(path) => "Fastboot executable does not exist: ${path}";

  static String m23(error) => "Flash exception: ${error}";

  static String m24(error) => "Flash failed: ${error}";

  static String m25(error) => "Failed to get ADB devices: ${error}";

  static String m26(error) => "Failed to get Fastboot devices: ${error}";

  static String m27(path) => "Input file does not exist: ${path}";

  static String m28(error) => "APK installation exception: ${error}";

  static String m29(error) => "APK installation failed: ${error}";

  static String m30(path) => "Kpimg file does not exist: ${path}";

  static String m31(path) => "Kptools file does not exist: ${path}";

  static String m32(serial) => "Device ${serial} is in userspace fastbootd mode; reboot to Bootloader Fastboot before flashing boot.";

  static String m33(path) => "One of the selected KPM modules is missing or empty: ${path}";

  static String m34(tool) => "Bundled tool ${tool} was not found at expected path.";

  static String m35(serial) => "Device ${serial} is offline and unresponsive.";

  static String m36(serial) => "Device ${serial} has not authorized USB debugging.";

  static String m37(error) => "Patch exception: ${error}";

  static String m38(error) => "Patch failed: ${error}";

  static String m39(error) => "Reboot exception: ${error}";

  static String m40(error) => "Reboot failed: ${error}";

  static String m41(tool) => "Missing Required Tool (${tool})";

  static String m42(error) => "Unpack failed: ${error}";

  static String m43(stage) => "Stage: ${stage}";

  static String m44(reason) => "Why: ${reason}";

  static String m45(serial) => "Userspace Fastbootd Active (${serial})";

  static String m46(error) => "Failed to launch installer: ${error}";

  static String m47(msg) => "${msg} Reconnect your device or reboot Windows if needed.";

  static String m48(name) => "${name} installation failed";

  static String m49(name) => "${name} installed successfully";

  static String m50(path) => "Boot backup complete: ${path}";

  static String m51(path) => "Backup successful: ${path}";

  static String m52(error) => "Failed to clean temporary files: ${error}";

  static String m53(path) => "Copied to ${path}";

  static String m54(cmd) => "Executing: ${cmd}";

  static String m55(serial) => "Fastboot device detected: ${serial}";

  static String m56(path) => "File saved: ${path}";

  static String m57(path) => "Flashing: ${path}";

  static String m58(path) => "Input file: ${path}";

  static String m59(path) => "Installing APK: ${path}";

  static String m60(path) => "Kpimg path: ${path}";

  static String m61(module) => "KPM Module: ${module}";

  static String m62(path) => "Kptools path: ${path}";

  static String m63(error) => "Failed to list patch info: ${error}";

  static String m64(error) => "Operation error: ${error}";

  static String m65(path) => "Output file: ${path}";

  static String m66(path) => "Patch complete: ${path}";

  static String m67(error) => "Patch exception: ${error}";

  static String m68(error) => "Patch failed: ${error}";

  static String m69(error) => "Repack exception: ${error}";

  static String m70(path, size) => "Repacked: ${path} (${size} MB)";

  static String m71(error) => "Unpack exception: ${error}";

  static String m72(path) => "Unpacked kernel: ${path}";

  static String m73(timeout) => "Waiting for fastboot device (${timeout} seconds)";

  static String m74(dir) => "Working directory: ${dir}";

  static String m75(path) => "Logs saved: ${path}";

  static String m76(version) => "New version available: ${version}";

  static String m77(count) => "Selected (${count})";

  static String m78(serial) => "Serial: ${serial}";

  static String m79(appName, version) => "${appName} v${version} • Runs with explicit preflight checks, signed driver verification, and standard Windows security policies.";

  static String m80(error) => "Unable to open official Samsung page: ${error}";

  static String m81(error) => "Unable to open link: ${error}";

  static String m82(mode, serial) => "Unsupported USB Mode (${mode}): ${serial}";

  static String m83(serial) => "USB Debugging Unauthorized (${serial})";

  static String m84(version) => "Selected version (${version}) is an older release without built-in kptools unpack or newer GKI 6.x patches. Prefer 0.13.8+ unless targeting an older kernel.";

  static String m85(kernel, range) => "Kernel version ${kernel} may be outside the supported ${range} range for this KernelPatch release.";

  static String m86(percent, minPercent) => "Device battery is low (${percent}%). Charge above ${minPercent}% before flashing.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "aboutDescription": MessageLookupByLibrary.simpleMessage("Android Boot Patching & KernelPatch Auto Flash Utility"),
    "aboutDescription2": MessageLookupByLibrary.simpleMessage("Automatically patches boot.img with KernelPatch and flashes via Bootloader Fastboot"),
    "aboutTitle": MessageLookupByLibrary.simpleMessage("About"),
    "aboutTooltip": MessageLookupByLibrary.simpleMessage("About"),
    "adbConnected": MessageLookupByLibrary.simpleMessage("ADB Connected"),
    "adbOfflineDesc": MessageLookupByLibrary.simpleMessage("Reconnect the USB cable, try a direct USB port, or toggle USB Debugging off and back on."),
    "adbOfflineTitle": m0,
    "androidVersionLabel": m1,
    "apatchDesc": MessageLookupByLibrary.simpleMessage("Android kernel-level root solution"),
    "apatchSubtitle": MessageLookupByLibrary.simpleMessage("bmax121 Official Upstream"),
    "appFullName": MessageLookupByLibrary.simpleMessage("FolkTool - KernelPatch Auto Flash Tool"),
    "appName": MessageLookupByLibrary.simpleMessage("FolkTool"),
    "appVersion": m2,
    "appVersionWithBuild": m3,
    "backupWarning": MessageLookupByLibrary.simpleMessage("Please backup original boot partition before flashing"),
    "batteryLevelLabel": m4,
    "bootloaderLockedLabel": MessageLookupByLibrary.simpleMessage("Bootloader Locked"),
    "bootloaderUnlockedLabel": MessageLookupByLibrary.simpleMessage("Bootloader Unlocked"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelOperation": MessageLookupByLibrary.simpleMessage("Cancel Operation"),
    "catalogNotesApatch11142": MessageLookupByLibrary.simpleMessage("Legacy official APatch (11142) with KernelPatch 0.12.2 for older kernels (3.18 - 6.6)."),
    "catalogNotesApatch11224": MessageLookupByLibrary.simpleMessage("Official APatch (11224) with KernelPatch 0.13.3 baseline."),
    "catalogNotesApatch11282": MessageLookupByLibrary.simpleMessage("Latest official APatch (11282) with KernelPatch 0.13.9 and HyperOS/Pengpai 4.0 kernel adaptation."),
    "catalogNotesFolkpatch0138": MessageLookupByLibrary.simpleMessage("FolkPatch v5.0 (115032) with KernelPatch 0.13.8 compatibility for non-GKI & Android 16 kernels."),
    "catalogNotesFolkpatch115357": MessageLookupByLibrary.simpleMessage("FolkPatch manager (115357) with KernelPatch 0.13.9 and WebUI shell leak fix."),
    "catalogNotesFolkpatch115404": MessageLookupByLibrary.simpleMessage("Latest FolkPatch manager (115404) with updated KernelPatch 0.13.9 BTF, hotpatch fixes, MTE-safe ksyms scans, and boot image sizing updates."),
    "checkDeviceStateBadge": MessageLookupByLibrary.simpleMessage("Check Device State"),
    "checking": MessageLookupByLibrary.simpleMessage("Checking..."),
    "checkingDriver": MessageLookupByLibrary.simpleMessage("Checking Tools & Driver"),
    "checkingDriverDesc": MessageLookupByLibrary.simpleMessage("Checking ADB/Fastboot tools..."),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearAll": MessageLookupByLibrary.simpleMessage("Clear All"),
    "clearAllModules": MessageLookupByLibrary.simpleMessage("Clear All"),
    "clearList": MessageLookupByLibrary.simpleMessage("Clear List"),
    "clearLogs": MessageLookupByLibrary.simpleMessage("Clear Logs"),
    "clearLogsDialogBody": MessageLookupByLibrary.simpleMessage("This will clear the visible operation log entries for the current session."),
    "clearLogsDialogTitle": MessageLookupByLibrary.simpleMessage("Clear Logs?"),
    "clearRecentFilesDesc": MessageLookupByLibrary.simpleMessage("This removes entries from the Recent Files list. Your actual files on disk will not be deleted."),
    "clearRecentFilesTitle": MessageLookupByLibrary.simpleMessage("Clear Recent Files?"),
    "clearSessionLogsConfirmBody": MessageLookupByLibrary.simpleMessage("All current in-memory log entries will be cleared."),
    "clickToSelectFile": MessageLookupByLibrary.simpleMessage("Click to select file..."),
    "clientCheck": MessageLookupByLibrary.simpleMessage("Client Detection"),
    "clientPackageLabel": m5,
    "clientVersionBadge": m6,
    "confirmBootImage": m7,
    "confirmKpVersion": m8,
    "confirmPatchTarget": m9,
    "confirmQuickFlashBody": MessageLookupByLibrary.simpleMessage("This will patch the boot image, reboot to Bootloader Fastboot, and flash the boot partition. Ensure your bootloader is unlocked and do not disconnect USB during flashing."),
    "confirmQuickFlashTitle": MessageLookupByLibrary.simpleMessage("Confirm One-Click Flash"),
    "confirmTargetDevice": m10,
    "connectFastbootToRestore": MessageLookupByLibrary.simpleMessage("Connect device in Fastboot mode to restore stock boot."),
    "copyDetails": MessageLookupByLibrary.simpleMessage("Copy Details"),
    "copyLogs": MessageLookupByLibrary.simpleMessage("Copy Logs"),
    "currentVersion": MessageLookupByLibrary.simpleMessage("Current Version"),
    "customVersion": MessageLookupByLibrary.simpleMessage("Custom Version"),
    "customVersionSaved": MessageLookupByLibrary.simpleMessage("Custom version saved"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteDiskLogsConfirmBody": MessageLookupByLibrary.simpleMessage("All saved log files in FolkTool/logs will be permanently deleted. Your boot images and backups remain untouched."),
    "deleteDiskLogsConfirmTitle": MessageLookupByLibrary.simpleMessage("Delete Saved Log Files?"),
    "deleteLogsButton": MessageLookupByLibrary.simpleMessage("Delete Logs"),
    "deletedSavedLogsCount": m11,
    "deviceConnectionTips": MessageLookupByLibrary.simpleMessage("Device Connection Tips"),
    "deviceConnectionTipsDesc": MessageLookupByLibrary.simpleMessage("1. Android booted (ADB): Enable Developer Options & USB Debugging, then unlock the screen and allow the RSA USB debugging prompt.\n2. Flashing mode (Bootloader Fastboot): Power off, hold the bootloader combo (usually Volume Down + Power), or click Reboot to Fastboot. Note: Samsung Download Mode (Odin) is NOT Fastboot."),
    "deviceErrorTitle": MessageLookupByLibrary.simpleMessage("Device Detection Error"),
    "deviceInFastboot": MessageLookupByLibrary.simpleMessage("Device in Fastboot"),
    "deviceSafeBadge": MessageLookupByLibrary.simpleMessage("Device Safe"),
    "deviceStateAdb": MessageLookupByLibrary.simpleMessage("ADB"),
    "deviceStateDisconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "deviceStateError": MessageLookupByLibrary.simpleMessage("Detection Error"),
    "deviceStateFastboot": MessageLookupByLibrary.simpleMessage("Fastboot (Bootloader)"),
    "deviceStateFastbootd": MessageLookupByLibrary.simpleMessage("Fastbootd (Userspace)"),
    "deviceStateMultiple": MessageLookupByLibrary.simpleMessage("Multiple"),
    "deviceStateOffline": MessageLookupByLibrary.simpleMessage("Offline"),
    "deviceStateRecovery": MessageLookupByLibrary.simpleMessage("Recovery"),
    "deviceStateSideload": MessageLookupByLibrary.simpleMessage("Sideload"),
    "deviceStateUnauthorized": MessageLookupByLibrary.simpleMessage("Unauthorized"),
    "deviceStateUnsupported": MessageLookupByLibrary.simpleMessage("Unsupported Mode"),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("Device Status"),
    "diagnosticsSaved": m12,
    "dismiss": MessageLookupByLibrary.simpleMessage("Dismiss"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "downloadOfficialSamsungDriver": MessageLookupByLibrary.simpleMessage("Download Official Samsung USB Driver"),
    "driverHelpGuide": MessageLookupByLibrary.simpleMessage("• ADB Driver: Required when Android is booted with USB Debugging enabled.\n• Fastboot Driver: Required in Bootloader mode. If Device Manager shows an unknown \"Android\" device with a yellow triangle, open Windows Update -> Optional Updates -> Driver Updates and install \"Android Bootloader Interface\".\n• Administrator Permission: Driver installers require Windows UAC approval and Authenticode signature verification."),
    "driverInstall": MessageLookupByLibrary.simpleMessage("Driver Install"),
    "driverInstallConfirmTitle": m13,
    "driverInstallPage": MessageLookupByLibrary.simpleMessage("Driver Installation"),
    "driverInstallSubtitle": MessageLookupByLibrary.simpleMessage("Install the driver to resolve missing driver issues"),
    "driverLaunchedResult": m14,
    "driverPublisherLabel": m15,
    "driverSignatureNotice": MessageLookupByLibrary.simpleMessage("FolkTool will verify the installer Authenticode signature and then request Windows Administrator (UAC) permission to install the driver."),
    "driverSupportedModesLabel": m16,
    "errAdbNotAvailable": MessageLookupByLibrary.simpleMessage("ADB is not available"),
    "errAdbNotExist": m17,
    "errApkNotFound": m18,
    "errBackupException": m19,
    "errCatAdb": MessageLookupByLibrary.simpleMessage("ADB"),
    "errCatApplication": MessageLookupByLibrary.simpleMessage("Application"),
    "errCatCompatibility": MessageLookupByLibrary.simpleMessage("Compatibility"),
    "errCatDeviceConnection": MessageLookupByLibrary.simpleMessage("Device Connection"),
    "errCatDownload": MessageLookupByLibrary.simpleMessage("Download"),
    "errCatDriver": MessageLookupByLibrary.simpleMessage("Driver"),
    "errCatExtraction": MessageLookupByLibrary.simpleMessage("Extraction"),
    "errCatFastboot": MessageLookupByLibrary.simpleMessage("Fastboot"),
    "errCatFile": MessageLookupByLibrary.simpleMessage("File"),
    "errCatFlashing": MessageLookupByLibrary.simpleMessage("Flashing"),
    "errCatImageValidation": MessageLookupByLibrary.simpleMessage("Image Validation"),
    "errCatNetwork": MessageLookupByLibrary.simpleMessage("Network"),
    "errCatPermission": MessageLookupByLibrary.simpleMessage("Permission"),
    "errCatProcess": MessageLookupByLibrary.simpleMessage("Process"),
    "errCheckClientFailed": m20,
    "errDriverCheckFailed": m21,
    "errFastbootNotAvailable": MessageLookupByLibrary.simpleMessage("Fastboot is not available"),
    "errFastbootNotExist": m22,
    "errFlashBootFailed": MessageLookupByLibrary.simpleMessage("Failed to flash boot partition"),
    "errFlashException": m23,
    "errFlashFailed": m24,
    "errGetAdbFailed": m25,
    "errGetFastbootFailed": m26,
    "errInputNotExist": m27,
    "errInstallApkException": m28,
    "errInstallApkFailed": m29,
    "errKernelNotFound": MessageLookupByLibrary.simpleMessage("Kernel file not found"),
    "errKpimgNotExist": m30,
    "errKptoolsNotExist": m31,
    "errMsgAdbFailed": MessageLookupByLibrary.simpleMessage("An ADB command failed to complete."),
    "errMsgAdbPortConflict": MessageLookupByLibrary.simpleMessage("The ADB daemon could not start or bind to port 5037."),
    "errMsgAdbTimeout": MessageLookupByLibrary.simpleMessage("The device did not respond to the ADB command within the expected time."),
    "errMsgBootNotFound": MessageLookupByLibrary.simpleMessage("The selected boot image file no longer exists or was moved."),
    "errMsgBootloaderLocked": MessageLookupByLibrary.simpleMessage("Flashing a patched boot image requires an unlocked bootloader."),
    "errMsgCannotReadBoot": MessageLookupByLibrary.simpleMessage("FolkTool could not read the selected boot.img file. Check file permissions or close apps locking it."),
    "errMsgEmptyBoot": MessageLookupByLibrary.simpleMessage("The selected boot image file is 0 bytes."),
    "errMsgFastbootPermission": MessageLookupByLibrary.simpleMessage("Windows denied access to the Fastboot USB interface."),
    "errMsgFastbootTimeout": MessageLookupByLibrary.simpleMessage("Timed out waiting for the device to appear in Fastboot mode."),
    "errMsgFastbootTimeoutCmd": MessageLookupByLibrary.simpleMessage("Fastboot did not respond in time."),
    "errMsgFastbootdBlocked": m32,
    "errMsgInvalidKpm": m33,
    "errMsgMissingKpimg": MessageLookupByLibrary.simpleMessage("The selected KernelPatch version file was not found or is empty."),
    "errMsgMissingTool": m34,
    "errMsgMultipleDevices": MessageLookupByLibrary.simpleMessage("More than one device is connected to this PC."),
    "errMsgNoDevice": MessageLookupByLibrary.simpleMessage("No Android device was detected in ADB or Fastboot mode."),
    "errMsgOffline": m35,
    "errMsgPartitionNotFound": MessageLookupByLibrary.simpleMessage("Fastboot reported that the target partition does not exist on this device."),
    "errMsgUnauthorized": m36,
    "errNextAdbPortConflict": MessageLookupByLibrary.simpleMessage("Close conflicting Android tools (phone suites or emulators) and retry."),
    "errNextBootloaderLocked": MessageLookupByLibrary.simpleMessage("Unlock the bootloader first (note: unlocking wipes user data)."),
    "errNextCannotReadBoot": MessageLookupByLibrary.simpleMessage("Ensure read permissions on the image file or copy it to a local folder."),
    "errNextEmptyBoot": MessageLookupByLibrary.simpleMessage("Provide a valid, non-empty stock boot.img."),
    "errNextFastbootTimeout": MessageLookupByLibrary.simpleMessage("Check USB cable, install Fastboot/Bootloader drivers if needed, and verify the device is in Bootloader mode (not Samsung Download/Odin mode)."),
    "errNextInvalidKpm": MessageLookupByLibrary.simpleMessage("Remove the missing KPM module or re-select it."),
    "errNextMissingKpimg": MessageLookupByLibrary.simpleMessage("Select a valid built-in or custom kpimg file before patching."),
    "errNextMissingTool": MessageLookupByLibrary.simpleMessage("Reinstall or repair FolkTool, or restore the bin/ and kp_versions/ directories."),
    "errNextMultipleDevices": MessageLookupByLibrary.simpleMessage("Disconnect extra devices or choose one target device in Device Status."),
    "errNextNoDevice": MessageLookupByLibrary.simpleMessage("Connect your device via USB, enable USB debugging, or enter Bootloader Fastboot mode."),
    "errNextOffline": MessageLookupByLibrary.simpleMessage("Reconnect the USB cable or toggle USB debugging."),
    "errNextPatchFailed": MessageLookupByLibrary.simpleMessage("Your device has not been modified. Verify your boot.img and KernelPatch version."),
    "errNextPreflightFailed": MessageLookupByLibrary.simpleMessage("Resolve the reported issue and try again."),
    "errNextSelectBoot": MessageLookupByLibrary.simpleMessage("Select a valid boot.img file first."),
    "errNextUnauthorized": MessageLookupByLibrary.simpleMessage("Unlock the phone screen and accept the \"Allow USB debugging\" RSA prompt."),
    "errNextUnexpected": MessageLookupByLibrary.simpleMessage("Export diagnostics and inspect logs before retrying."),
    "errOutputKernelNotFound": MessageLookupByLibrary.simpleMessage("Output kernel not found"),
    "errPatchException": m37,
    "errPatchFailed": m38,
    "errRebootException": m39,
    "errRebootFailed": m40,
    "errRepackFailed": MessageLookupByLibrary.simpleMessage("Repack failed"),
    "errSelectBootFirst": MessageLookupByLibrary.simpleMessage("Please select boot.img file first"),
    "errTitleAdbFailed": MessageLookupByLibrary.simpleMessage("ADB Command Failed"),
    "errTitleAdbPortConflict": MessageLookupByLibrary.simpleMessage("ADB Server Port Conflict"),
    "errTitleAdbTimeout": MessageLookupByLibrary.simpleMessage("ADB Command Timed Out"),
    "errTitleBootNotFound": MessageLookupByLibrary.simpleMessage("Boot Image Not Found"),
    "errTitleBootloaderLocked": MessageLookupByLibrary.simpleMessage("Bootloader Locked"),
    "errTitleCannotReadBoot": MessageLookupByLibrary.simpleMessage("Cannot Read Boot Image"),
    "errTitleEmptyBoot": MessageLookupByLibrary.simpleMessage("Empty Boot Image"),
    "errTitleFastbootFailed": MessageLookupByLibrary.simpleMessage("Fastboot Command Failed"),
    "errTitleFastbootPermission": MessageLookupByLibrary.simpleMessage("Insufficient Permissions / Driver Access"),
    "errTitleFastbootTimeout": MessageLookupByLibrary.simpleMessage("Fastboot Device Not Detected"),
    "errTitleFastbootTimeoutCmd": MessageLookupByLibrary.simpleMessage("Fastboot Command Timed Out"),
    "errTitleFastbootdBlocked": MessageLookupByLibrary.simpleMessage("Userspace Fastbootd Active"),
    "errTitleInvalidKpm": MessageLookupByLibrary.simpleMessage("Invalid KPM Module"),
    "errTitleMissingKpimg": MessageLookupByLibrary.simpleMessage("Missing KernelPatch Image (kpimg)"),
    "errTitleMissingTool": m41,
    "errTitleMultipleDevices": MessageLookupByLibrary.simpleMessage("Multiple Devices Connected"),
    "errTitleNoBootSelected": MessageLookupByLibrary.simpleMessage("No Boot Image Selected"),
    "errTitleNoDevice": MessageLookupByLibrary.simpleMessage("No Device Connected"),
    "errTitleOffline": MessageLookupByLibrary.simpleMessage("Device Offline"),
    "errTitlePartitionNotFound": MessageLookupByLibrary.simpleMessage("Target Partition Not Found"),
    "errTitlePatchFailed": MessageLookupByLibrary.simpleMessage("Boot Image Patching Failed"),
    "errTitlePreflightFailed": MessageLookupByLibrary.simpleMessage("Preflight Check Failed"),
    "errTitleUnauthorized": MessageLookupByLibrary.simpleMessage("Device Unauthorized"),
    "errTitleUnexpected": MessageLookupByLibrary.simpleMessage("Unexpected Operation Error"),
    "errUnpackFailed": m42,
    "errorDetailsCopied": MessageLookupByLibrary.simpleMessage("Error details copied to clipboard"),
    "errorStage": m43,
    "errorWhy": m44,
    "exportDiagnostics": MessageLookupByLibrary.simpleMessage("Export Diagnostics"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export Logs"),
    "exportLogsTooltip": MessageLookupByLibrary.simpleMessage("Export Logs"),
    "fastbootConnected": MessageLookupByLibrary.simpleMessage("Fastboot Connected"),
    "fastbootdDetectedDesc": MessageLookupByLibrary.simpleMessage("Boot image flashing requires Bootloader Fastboot mode rather than userspace fastbootd. Reboot to Bootloader first."),
    "fastbootdDetectedTitle": m45,
    "fileMissingBadge": MessageLookupByLibrary.simpleMessage("Missing"),
    "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage("File saved successfully"),
    "filterAll": MessageLookupByLibrary.simpleMessage("All"),
    "filterErr": MessageLookupByLibrary.simpleMessage("Err"),
    "filterInfo": MessageLookupByLibrary.simpleMessage("Info"),
    "filterLogsHint": MessageLookupByLibrary.simpleMessage("Filter logs..."),
    "filterOk": MessageLookupByLibrary.simpleMessage("OK"),
    "filterWarn": MessageLookupByLibrary.simpleMessage("Warn"),
    "flashBoot": MessageLookupByLibrary.simpleMessage("Flash boot"),
    "flashComplete": MessageLookupByLibrary.simpleMessage("Flash Complete"),
    "flashCompleteDesc": MessageLookupByLibrary.simpleMessage("Reboot device now?"),
    "flashFile": MessageLookupByLibrary.simpleMessage("Flash File"),
    "flashSuccess": MessageLookupByLibrary.simpleMessage("Flash successful!"),
    "flashing": MessageLookupByLibrary.simpleMessage("Flashing..."),
    "folderBackupsButton": MessageLookupByLibrary.simpleMessage("Backups"),
    "folderLogsButton": MessageLookupByLibrary.simpleMessage("Logs"),
    "folkpatchDesc": MessageLookupByLibrary.simpleMessage("An excellent KernelPatch management client"),
    "folkpatchSubtitle": MessageLookupByLibrary.simpleMessage("LyraVoid Fork • Extended KP"),
    "github": MessageLookupByLibrary.simpleMessage("GitHub"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "install": MessageLookupByLibrary.simpleMessage("Install"),
    "installDriver": MessageLookupByLibrary.simpleMessage("Install Driver"),
    "installDriverFailed": m46,
    "installDriverSuccess": MessageLookupByLibrary.simpleMessage("Driver installer launched"),
    "installDriverSuccessReconnect": m47,
    "installFailed": m48,
    "installSuccess": m49,
    "installed": MessageLookupByLibrary.simpleMessage("Installed"),
    "installing": MessageLookupByLibrary.simpleMessage("Installing..."),
    "invalidVersionFile": MessageLookupByLibrary.simpleMessage("Invalid version file"),
    "kernelPatchVersion": MessageLookupByLibrary.simpleMessage("KernelPatch Version"),
    "kpmModules": MessageLookupByLibrary.simpleMessage("KPM Modules (Optional)"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "loadingVersions": MessageLookupByLibrary.simpleMessage("Loading versions..."),
    "logAutoRebootFailed": MessageLookupByLibrary.simpleMessage("Auto reboot to fastboot failed"),
    "logAutoRebootFailed2": MessageLookupByLibrary.simpleMessage("Auto reboot failed"),
    "logBackingUpBoot": MessageLookupByLibrary.simpleMessage("Backing up boot partition..."),
    "logBackingUpPartition": MessageLookupByLibrary.simpleMessage("Backing up partition..."),
    "logBackupComplete": m50,
    "logBackupFailed": MessageLookupByLibrary.simpleMessage("Boot backup failed"),
    "logBackupFailedTryAlt": MessageLookupByLibrary.simpleMessage("Backup failed, trying alternative method..."),
    "logBackupKernel": MessageLookupByLibrary.simpleMessage("Backing up kernel..."),
    "logBackupSuccess": m51,
    "logCancelling": MessageLookupByLibrary.simpleMessage("Cancelling operation..."),
    "logCheckAdb": MessageLookupByLibrary.simpleMessage("Checking ADB..."),
    "logCheckFastboot": MessageLookupByLibrary.simpleMessage("Checking Fastboot..."),
    "logCheckingClient": MessageLookupByLibrary.simpleMessage("Checking installed manager apps..."),
    "logCheckingFile": MessageLookupByLibrary.simpleMessage("Checking file..."),
    "logCleanWorkDir": MessageLookupByLibrary.simpleMessage("Cleaning temporary files..."),
    "logCleanWorkDirFailed": m52,
    "logConsole": MessageLookupByLibrary.simpleMessage("Log Console"),
    "logCopied": m53,
    "logCopyBoot": MessageLookupByLibrary.simpleMessage("Copying boot image..."),
    "logDeviceInFastboot": MessageLookupByLibrary.simpleMessage("Device is in fastboot mode"),
    "logDeviceNotFastboot": MessageLookupByLibrary.simpleMessage("Device not in fastboot mode"),
    "logDeviceRebooting": MessageLookupByLibrary.simpleMessage("Device is rebooting..."),
    "logDriverCheckPassed": MessageLookupByLibrary.simpleMessage("Driver check passed"),
    "logEntries": MessageLookupByLibrary.simpleMessage("entries"),
    "logExecuteCmd": m54,
    "logFastbootDetected": m55,
    "logFileSaved": m56,
    "logFlashBootSuccess": MessageLookupByLibrary.simpleMessage("Flash completed successfully"),
    "logFlashFailed": MessageLookupByLibrary.simpleMessage("Flash failed"),
    "logFlashSuccess": MessageLookupByLibrary.simpleMessage("Flash successful"),
    "logFlashingBoot": MessageLookupByLibrary.simpleMessage("Flashing boot image..."),
    "logFlashingBootPath": m57,
    "logInputFile": m58,
    "logInstallApkSuccess": MessageLookupByLibrary.simpleMessage("APK installed successfully"),
    "logInstallingApk": m59,
    "logKpimgPath": m60,
    "logKpmModule": m61,
    "logKptoolsPath": m62,
    "logListPatchInfoFailed": m63,
    "logNoAdbDevice": MessageLookupByLibrary.simpleMessage("No ADB device detected"),
    "logOneClickComplete": MessageLookupByLibrary.simpleMessage("One-click flash completed!"),
    "logOperationError": m64,
    "logOutput": MessageLookupByLibrary.simpleMessage("Log Output"),
    "logOutputFile": m65,
    "logPatchComplete": m66,
    "logPatchException": m67,
    "logPatchFailed": m68,
    "logPatchSuccess": MessageLookupByLibrary.simpleMessage("Kernel patched successfully"),
    "logPatchingBoot": MessageLookupByLibrary.simpleMessage("Patching boot image..."),
    "logPatchingKernel": MessageLookupByLibrary.simpleMessage("Patching kernel..."),
    "logRebootCmdSent": MessageLookupByLibrary.simpleMessage("Reboot command sent"),
    "logRebootSuccess": MessageLookupByLibrary.simpleMessage("Device rebooted successfully"),
    "logRebootingDevice": MessageLookupByLibrary.simpleMessage("Rebooting device..."),
    "logRebootingToFastboot": MessageLookupByLibrary.simpleMessage("Rebooting to fastboot mode..."),
    "logRepackException": m69,
    "logRepackSuccess": m70,
    "logRepacking": MessageLookupByLibrary.simpleMessage("Repacking boot image..."),
    "logSavingFile": MessageLookupByLibrary.simpleMessage("Saving patched file..."),
    "logStartPatching": MessageLookupByLibrary.simpleMessage("Starting patch operation..."),
    "logUnpackException": m71,
    "logUnpackSuccess": m72,
    "logUnpacking": MessageLookupByLibrary.simpleMessage("Unpacking boot image..."),
    "logWaitFastboot": m73,
    "logWaitFastbootTimeout": MessageLookupByLibrary.simpleMessage("Wait for fastboot timeout"),
    "logWorkDir": m74,
    "logsCopied": MessageLookupByLibrary.simpleMessage("Logs copied to clipboard"),
    "logsSaved": m75,
    "manuallyEnterFastboot": MessageLookupByLibrary.simpleMessage("Enter Bootloader Fastboot mode manually"),
    "manuallyEnterFastbootDesc": MessageLookupByLibrary.simpleMessage("1. Power off your Android device completely.\n2. Hold the bootloader key combo (usually Volume Down + Power) until Fastboot/Bootloader appears.\n3. Connect via USB (Samsung Download/Odin mode is incompatible with Fastboot)."),
    "matsuzakaYuki": MessageLookupByLibrary.simpleMessage("Matsuzaka Yuki"),
    "mediatekDriver": MessageLookupByLibrary.simpleMessage("MediaTek USB Driver"),
    "mediatekDriverDesc": MessageLookupByLibrary.simpleMessage("USB driver for MediaTek chipset devices"),
    "multipleDevicesDesc": MessageLookupByLibrary.simpleMessage("Select one target device or disconnect extra devices/emulators before flashing."),
    "multipleDevicesTitle": MessageLookupByLibrary.simpleMessage("Multiple Devices Detected"),
    "navDashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "navDriversShort": MessageLookupByLibrary.simpleMessage("Drivers"),
    "navLocalShort": MessageLookupByLibrary.simpleMessage("Local"),
    "navMore": MessageLookupByLibrary.simpleMessage("More"),
    "navQuickShort": MessageLookupByLibrary.simpleMessage("Quick"),
    "navSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "navStepShort": MessageLookupByLibrary.simpleMessage("Steps"),
    "newVersionAvailable": m76,
    "nextStep": MessageLookupByLibrary.simpleMessage("Next"),
    "noDeviceDetected": MessageLookupByLibrary.simpleMessage("No device detected"),
    "noDeviceDetectedDesc": MessageLookupByLibrary.simpleMessage("Please ensure device is connected and USB debugging is enabled"),
    "noFastbootDevice": MessageLookupByLibrary.simpleMessage("No Fastboot device detected"),
    "noKpmModules": MessageLookupByLibrary.simpleMessage("No modules selected"),
    "noLogs": MessageLookupByLibrary.simpleMessage("No logs"),
    "noSavedLogsToDelete": MessageLookupByLibrary.simpleMessage("No saved log files to delete"),
    "noVersionSelected": MessageLookupByLibrary.simpleMessage("No version selected"),
    "noVersionsAvailable": MessageLookupByLibrary.simpleMessage("No versions available"),
    "noneDetected": MessageLookupByLibrary.simpleMessage("None detected"),
    "oneClickFlash": MessageLookupByLibrary.simpleMessage("One-Click Flash"),
    "oneplusAdbDriver": MessageLookupByLibrary.simpleMessage("OnePlus Official ADB Driver"),
    "oneplusAdbDriverDesc": MessageLookupByLibrary.simpleMessage("Official OnePlus ADB driver for Windows 7 systems"),
    "openFileLocation": MessageLookupByLibrary.simpleMessage("Open File Location"),
    "operationFailed": MessageLookupByLibrary.simpleMessage("Operation Failed"),
    "operationInProgressNavBlocked": MessageLookupByLibrary.simpleMessage("An operation is currently running. Wait for completion or cancel before leaving this view."),
    "operationProgress": MessageLookupByLibrary.simpleMessage("Operation Progress"),
    "oppoAdbDriver": MessageLookupByLibrary.simpleMessage("OPPO Official ADB Driver"),
    "oppoAdbDriverDesc": MessageLookupByLibrary.simpleMessage("Official OPPO USB driver for Windows 10 and above"),
    "patchOnlyComplete": MessageLookupByLibrary.simpleMessage("Patch complete!"),
    "patchTarget": MessageLookupByLibrary.simpleMessage("Patch Target"),
    "patchTargetDesc": MessageLookupByLibrary.simpleMessage("Select patch target to use corresponding KernelPatch version"),
    "patchedFile": MessageLookupByLibrary.simpleMessage("Patched File"),
    "patching": MessageLookupByLibrary.simpleMessage("Patching..."),
    "pleaseSelectFile": MessageLookupByLibrary.simpleMessage("Please select boot.img file first"),
    "preflightActionRequired": MessageLookupByLibrary.simpleMessage("Preflight Action Required"),
    "preflightReady": MessageLookupByLibrary.simpleMessage("Preflight Ready"),
    "previousStep": MessageLookupByLibrary.simpleMessage("Previous"),
    "qualcommDriver32": MessageLookupByLibrary.simpleMessage("Qualcomm Fastboot Driver (32-bit)"),
    "qualcommDriver32Desc": MessageLookupByLibrary.simpleMessage("Qualcomm device driver for 32-bit Windows systems"),
    "qualcommDriver64": MessageLookupByLibrary.simpleMessage("Qualcomm Fastboot Driver (64-bit)"),
    "qualcommDriver64Desc": MessageLookupByLibrary.simpleMessage("Qualcomm device driver for 64-bit Windows systems"),
    "quickPatch": MessageLookupByLibrary.simpleMessage("One-Click Flash"),
    "quickPatchComplete": MessageLookupByLibrary.simpleMessage("One-click flash completed!"),
    "quickPatchSubtitle": MessageLookupByLibrary.simpleMessage("Automatically complete patch, reboot, and flash process"),
    "rebootLater": MessageLookupByLibrary.simpleMessage("Reboot Later"),
    "rebootNow": MessageLookupByLibrary.simpleMessage("Reboot Now"),
    "rebootToFastboot": MessageLookupByLibrary.simpleMessage("Reboot to Fastboot"),
    "recentFileMissingHint": MessageLookupByLibrary.simpleMessage("This file no longer exists on disk. You can remove it from the list."),
    "recentFiles": MessageLookupByLibrary.simpleMessage("Recent Files"),
    "recentFilesCleared": MessageLookupByLibrary.simpleMessage("Recent files history cleared"),
    "recheck": MessageLookupByLibrary.simpleMessage("Re-check"),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "removeFromList": MessageLookupByLibrary.simpleMessage("Remove from list"),
    "removeModule": MessageLookupByLibrary.simpleMessage("Remove"),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetAllSettingsConfirmBody": MessageLookupByLibrary.simpleMessage("Restore all safety, monitoring, and diagnostic preferences to default values?"),
    "resetAllSettingsConfirmTitle": MessageLookupByLibrary.simpleMessage("Reset All Settings?"),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "restoreStockBootButton": MessageLookupByLibrary.simpleMessage("Restore Stock Boot"),
    "restoreStockBootFailed": MessageLookupByLibrary.simpleMessage("Failed to restore stock boot image."),
    "restoreStockBootSuccess": MessageLookupByLibrary.simpleMessage("Stock boot image restored."),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "samsungDriverDesc": MessageLookupByLibrary.simpleMessage("Official Samsung USB Driver for Galaxy phones/tablets. Downloads directly from Samsung Developer Portal so you can verify the official Samsung digital signature before running with Administrator privileges."),
    "samsungDriverModes": MessageLookupByLibrary.simpleMessage("ADB / MTP / Samsung Download Mode"),
    "samsungDriverName": MessageLookupByLibrary.simpleMessage("Samsung Official Android USB Driver"),
    "saveAs": MessageLookupByLibrary.simpleMessage("Save As"),
    "savePatchedFile": MessageLookupByLibrary.simpleMessage("Save Patched File"),
    "saveToFile": MessageLookupByLibrary.simpleMessage("Save to File"),
    "scanning": MessageLookupByLibrary.simpleMessage("Scanning devices..."),
    "selectBootImage": MessageLookupByLibrary.simpleMessage("Select boot.img File"),
    "selectCustomVersion": MessageLookupByLibrary.simpleMessage("Select custom kpimg file"),
    "selectKpmModules": MessageLookupByLibrary.simpleMessage("Select KPM modules..."),
    "selectMode": MessageLookupByLibrary.simpleMessage("Select Operation Mode"),
    "selectSaveLocation": MessageLookupByLibrary.simpleMessage("Select save location"),
    "selectVersion": MessageLookupByLibrary.simpleMessage("Select Version"),
    "selectVersionDesc": MessageLookupByLibrary.simpleMessage("Select the KernelPatch version to use"),
    "selectedModules": m77,
    "serial": m78,
    "sessionLogsCleared": MessageLookupByLibrary.simpleMessage("Session logs cleared"),
    "settingsAdbVersionLabel": MessageLookupByLibrary.simpleMessage("ADB version"),
    "settingsAppearanceSection": MessageLookupByLibrary.simpleMessage("Appearance & Language"),
    "settingsAutoMonitorDesc": MessageLookupByLibrary.simpleMessage("Periodically detect ADB & Fastboot state changes in the background"),
    "settingsAutoMonitorTitle": MessageLookupByLibrary.simpleMessage("Auto-monitor connected devices"),
    "settingsCheckUpdatesDesc": MessageLookupByLibrary.simpleMessage("Check GitHub releases for newer FolkTool versions"),
    "settingsCheckUpdatesTitle": MessageLookupByLibrary.simpleMessage("Check for updates on launch"),
    "settingsClearDiskLogsDesc": MessageLookupByLibrary.simpleMessage("Deletes archived .txt and .log files inside FolkTool/logs (stock boot backups are untouched)"),
    "settingsClearDiskLogsTitle": MessageLookupByLibrary.simpleMessage("Clear saved log files on disk"),
    "settingsClearRecentDesc": MessageLookupByLibrary.simpleMessage("Removes entries from the Recent Files list (your files on disk are not deleted)"),
    "settingsClearRecentTitle": MessageLookupByLibrary.simpleMessage("Clear recent files history"),
    "settingsClearSessionLogsDesc": MessageLookupByLibrary.simpleMessage("Clears in-memory operation logs for the current session"),
    "settingsClearSessionLogsTitle": MessageLookupByLibrary.simpleMessage("Clear session logs"),
    "settingsConfirmFlashDesc": MessageLookupByLibrary.simpleMessage("Show target device, image, and safety summary before writing boot partition"),
    "settingsConfirmFlashTitle": MessageLookupByLibrary.simpleMessage("Confirm before flashing"),
    "settingsFastbootVersionLabel": MessageLookupByLibrary.simpleMessage("Fastboot version"),
    "settingsFooterSummary": m79,
    "settingsKptoolsVersionLabel": MessageLookupByLibrary.simpleMessage("KernelPatch Patcher (kptools)"),
    "settingsMonitoringSection": MessageLookupByLibrary.simpleMessage("Device Monitoring & Safety"),
    "settingsOpenFoldersDesc": MessageLookupByLibrary.simpleMessage("View exported logs, crash-safe session logs, and stock boot backups"),
    "settingsOpenFoldersTitle": MessageLookupByLibrary.simpleMessage("Open logs & backup folders"),
    "settingsPlatformToolsRevLabel": MessageLookupByLibrary.simpleMessage("Platform-Tools Revision"),
    "settingsPlatformToolsTitle": MessageLookupByLibrary.simpleMessage("Android Platform-Tools"),
    "settingsRedactDiagDesc": MessageLookupByLibrary.simpleMessage("Mask Windows usernames and full device serials when exporting diagnostic bundles"),
    "settingsRedactDiagTitle": MessageLookupByLibrary.simpleMessage("Redact personal info in diagnostics"),
    "settingsRefreshToolchain": MessageLookupByLibrary.simpleMessage("Re-verify Toolchain"),
    "settingsResetDefaultsDesc": MessageLookupByLibrary.simpleMessage("Restores safety toggles and monitoring preferences to defaults"),
    "settingsResetDefaultsTitle": MessageLookupByLibrary.simpleMessage("Reset settings to defaults"),
    "settingsRestoredNotice": MessageLookupByLibrary.simpleMessage("Settings restored to defaults"),
    "settingsShortcutTooltip": MessageLookupByLibrary.simpleMessage("Settings (Ctrl+,)"),
    "settingsStorageSection": MessageLookupByLibrary.simpleMessage("Storage & Maintenance"),
    "settingsThemeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "settingsThemeLabel": MessageLookupByLibrary.simpleMessage("Theme"),
    "settingsThemeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "settingsThemeSystem": MessageLookupByLibrary.simpleMessage("System"),
    "settingsToolchainMissing": MessageLookupByLibrary.simpleMessage("Missing / Attention Needed"),
    "settingsToolchainReady": MessageLookupByLibrary.simpleMessage("Verified & Ready"),
    "settingsToolchainSection": MessageLookupByLibrary.simpleMessage("Toolchain & Runtime Diagnostics"),
    "simplePatch": MessageLookupByLibrary.simpleMessage("Simple Patch"),
    "simplePatchSubtitle": MessageLookupByLibrary.simpleMessage("Patch boot.img only, save file manually"),
    "startFlash": MessageLookupByLibrary.simpleMessage("Start Flash"),
    "startFlashingButton": MessageLookupByLibrary.simpleMessage("Start Flashing"),
    "startPatch": MessageLookupByLibrary.simpleMessage("Start Patch"),
    "step1": MessageLookupByLibrary.simpleMessage("Step 1: Patch boot.img"),
    "step1Desc": MessageLookupByLibrary.simpleMessage("Select file and execute patch"),
    "step2": MessageLookupByLibrary.simpleMessage("Step 2: Save Patched File"),
    "step2Desc": MessageLookupByLibrary.simpleMessage("Confirm patched file is saved"),
    "step3": MessageLookupByLibrary.simpleMessage("Step 3: Enter Fastboot"),
    "step3Desc": MessageLookupByLibrary.simpleMessage("Reboot device to Fastboot mode"),
    "step4": MessageLookupByLibrary.simpleMessage("Step 4: Flash boot.img"),
    "step4Desc": MessageLookupByLibrary.simpleMessage("Flash patched file to device"),
    "stepBackupBoot": MessageLookupByLibrary.simpleMessage("Backup Boot"),
    "stepFlashDevice": MessageLookupByLibrary.simpleMessage("Flash to Device"),
    "stepOperation": MessageLookupByLibrary.simpleMessage("Step-by-Step"),
    "stepPatch": MessageLookupByLibrary.simpleMessage("Step-by-Step"),
    "stepPatchImage": MessageLookupByLibrary.simpleMessage("Patch Image"),
    "stepPatchSubtitle": MessageLookupByLibrary.simpleMessage("Manually execute each step, more flexible"),
    "stepRebootComplete": MessageLookupByLibrary.simpleMessage("Reboot Device"),
    "stepRebootToFastboot": MessageLookupByLibrary.simpleMessage("Reboot to Fastboot"),
    "stepSaveFile": MessageLookupByLibrary.simpleMessage("Save File"),
    "stepSelectBoot": MessageLookupByLibrary.simpleMessage("Select Boot File"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("Switch Theme"),
    "switchToChinese": MessageLookupByLibrary.simpleMessage("切换为中文"),
    "switchToEnglish": MessageLookupByLibrary.simpleMessage("Switch to English"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("Follow System"),
    "toggleNavigation": MessageLookupByLibrary.simpleMessage("Toggle Navigation"),
    "toolsAvailableTitle": MessageLookupByLibrary.simpleMessage("ADB & Fastboot Tools Available"),
    "toolsMissingTitle": MessageLookupByLibrary.simpleMessage("ADB / Fastboot Tools Not Detected"),
    "unableOpenSamsungPage": m80,
    "unableToOpenLink": m81,
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unsupportedModeDesc": MessageLookupByLibrary.simpleMessage("Boot patching/flashing requires Android ADB (system booted) or Bootloader Fastboot mode. Samsung Download/Odin mode is incompatible with Fastboot."),
    "unsupportedModeTitle": m82,
    "usbUnauthorizedDesc": MessageLookupByLibrary.simpleMessage("Unlock your phone screen and tap \"Allow USB debugging\" (check \"Always allow from this computer\")."),
    "usbUnauthorizedTitle": m83,
    "verifyAndInstall": MessageLookupByLibrary.simpleMessage("Verify & Install"),
    "versionChannelLegacy": MessageLookupByLibrary.simpleMessage("Legacy"),
    "versionChannelPrerelease": MessageLookupByLibrary.simpleMessage("Pre-release"),
    "versionChannelStable": MessageLookupByLibrary.simpleMessage("Stable"),
    "versionCompatLabel": MessageLookupByLibrary.simpleMessage("Compatibility"),
    "versionCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "versionKpLabel": MessageLookupByLibrary.simpleMessage("KernelPatch"),
    "versionKptoolsLabel": MessageLookupByLibrary.simpleMessage("Engine"),
    "versionManagerLabel": MessageLookupByLibrary.simpleMessage("Manager"),
    "versionRecommended": MessageLookupByLibrary.simpleMessage("Recommended"),
    "versionReleaseDateLabel": MessageLookupByLibrary.simpleMessage("Released"),
    "versionSupportUnpack": MessageLookupByLibrary.simpleMessage("Built-in Unpack"),
    "versionUnpackUnsupportedWarn": m84,
    "versionVerifiedBadge": MessageLookupByLibrary.simpleMessage("SHA-256 Verified"),
    "viewLogs": MessageLookupByLibrary.simpleMessage("View Logs"),
    "warnKernelOutOfRange": m85,
    "warnLowBattery": m86,
    "warnNonStandardBootMagic": MessageLookupByLibrary.simpleMessage("File header does not start with standard ANDROID! magic (some vendor/LZ4/vendor_boot images differ — verify before flashing)."),
  };
}