// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: FolkTool ARB Synchronization Script
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S? get maybeCurrent => _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appName => Intl.message('FolkTool', name: 'appName', desc: '', args: []);
  String get appFullName => Intl.message('FolkTool - KernelPatch Auto Flash Tool', name: 'appFullName', desc: '', args: []);
  String appVersion(Object version) => Intl.message('FolkTool v$version', name: 'appVersion', desc: '', args: [version]);
  String get home => Intl.message('Home', name: 'home', desc: '', args: []);
  String get about => Intl.message('About', name: 'about', desc: '', args: []);
  String get aboutTooltip => Intl.message('About', name: 'aboutTooltip', desc: '', args: []);
  String get aboutTitle => Intl.message('About', name: 'aboutTitle', desc: '', args: []);
  String get aboutDescription => Intl.message('Android Boot Patching & KernelPatch Auto Flash Utility', name: 'aboutDescription', desc: '', args: []);
  String get aboutDescription2 => Intl.message('Automatically patches boot.img with KernelPatch and flashes via Bootloader Fastboot', name: 'aboutDescription2', desc: '', args: []);
  String get backupWarning => Intl.message('Please backup original boot partition before flashing', name: 'backupWarning', desc: '', args: []);
  String get selectMode => Intl.message('Select Operation Mode', name: 'selectMode', desc: '', args: []);
  String get quickPatch => Intl.message('One-Click Flash', name: 'quickPatch', desc: '', args: []);
  String get quickPatchSubtitle => Intl.message('Automatically complete patch, reboot, and flash process', name: 'quickPatchSubtitle', desc: '', args: []);
  String get stepPatch => Intl.message('Step-by-Step', name: 'stepPatch', desc: '', args: []);
  String get stepPatchSubtitle => Intl.message('Manually execute each step, more flexible', name: 'stepPatchSubtitle', desc: '', args: []);
  String get recentFiles => Intl.message('Recent Files', name: 'recentFiles', desc: '', args: []);
  String get selectBootImage => Intl.message('Select boot.img File', name: 'selectBootImage', desc: '', args: []);
  String get clickToSelectFile => Intl.message('Click to select file...', name: 'clickToSelectFile', desc: '', args: []);
  String get deviceStatus => Intl.message('Device Status', name: 'deviceStatus', desc: '', args: []);
  String get refresh => Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  String get checking => Intl.message('Checking...', name: 'checking', desc: '', args: []);
  String get checkingDriver => Intl.message('Checking Tools & Driver', name: 'checkingDriver', desc: '', args: []);
  String get checkingDriverDesc => Intl.message('Checking ADB/Fastboot tools...', name: 'checkingDriverDesc', desc: '', args: []);
  String get noDeviceDetected => Intl.message('No device detected', name: 'noDeviceDetected', desc: '', args: []);
  String get noDeviceDetectedDesc => Intl.message('Please ensure device is connected and USB debugging is enabled', name: 'noDeviceDetectedDesc', desc: '', args: []);
  String get deviceConnectionTips => Intl.message('Device Connection Tips', name: 'deviceConnectionTips', desc: '', args: []);
  String get deviceConnectionTipsDesc => Intl.message('1. Android booted (ADB): Enable Developer Options & USB Debugging, then unlock the screen and allow the RSA USB debugging prompt.\n2. Flashing mode (Bootloader Fastboot): Power off, hold the bootloader combo (usually Volume Down + Power), or click Reboot to Fastboot. Note: Samsung Download Mode (Odin) is NOT Fastboot.', name: 'deviceConnectionTipsDesc', desc: '', args: []);
  String get adbConnected => Intl.message('ADB Connected', name: 'adbConnected', desc: '', args: []);
  String serial(Object serial) => Intl.message('Serial: $serial', name: 'serial', desc: '', args: [serial]);
  String get fastbootConnected => Intl.message('Fastboot Connected', name: 'fastbootConnected', desc: '', args: []);
  String get scanning => Intl.message('Scanning devices...', name: 'scanning', desc: '', args: []);
  String get kpmModules => Intl.message('KPM Modules (Optional)', name: 'kpmModules', desc: '', args: []);
  String get selectKpmModules => Intl.message('Select KPM modules...', name: 'selectKpmModules', desc: '', args: []);
  String get noKpmModules => Intl.message('No modules selected', name: 'noKpmModules', desc: '', args: []);
  String selectedModules(Object count) => Intl.message('Selected ($count)', name: 'selectedModules', desc: '', args: [count]);
  String get clearAllModules => Intl.message('Clear All', name: 'clearAllModules', desc: '', args: []);
  String get removeModule => Intl.message('Remove', name: 'removeModule', desc: '', args: []);
  String logKpmModule(Object module) => Intl.message('KPM Module: $module', name: 'logKpmModule', desc: '', args: [module]);
  String get oneClickFlash => Intl.message('One-Click Flash', name: 'oneClickFlash', desc: '', args: []);
  String get exportLogs => Intl.message('Export Logs', name: 'exportLogs', desc: '', args: []);
  String get exportLogsTooltip => Intl.message('Export Logs', name: 'exportLogsTooltip', desc: '', args: []);
  String get startFlash => Intl.message('Start Flash', name: 'startFlash', desc: '', args: []);
  String get flashing => Intl.message('Flashing...', name: 'flashing', desc: '', args: []);
  String get cancelOperation => Intl.message('Cancel Operation', name: 'cancelOperation', desc: '', args: []);
  String get quickPatchComplete => Intl.message('One-click flash completed!', name: 'quickPatchComplete', desc: '', args: []);
  String get restart => Intl.message('Restart', name: 'restart', desc: '', args: []);
  String get retry => Intl.message('Retry', name: 'retry', desc: '', args: []);
  String get operationFailed => Intl.message('Operation Failed', name: 'operationFailed', desc: '', args: []);
  String logsSaved(Object path) => Intl.message('Logs saved: $path', name: 'logsSaved', desc: '', args: [path]);
  String unableToOpenLink(Object error) => Intl.message('Unable to open link: $error', name: 'unableToOpenLink', desc: '', args: [error]);
  String get pleaseSelectFile => Intl.message('Please select boot.img file first', name: 'pleaseSelectFile', desc: '', args: []);
  String get stepOperation => Intl.message('Step-by-Step', name: 'stepOperation', desc: '', args: []);
  String get reset => Intl.message('Reset', name: 'reset', desc: '', args: []);
  String get step1 => Intl.message('Step 1: Patch boot.img', name: 'step1', desc: '', args: []);
  String get step1Desc => Intl.message('Select file and execute patch', name: 'step1Desc', desc: '', args: []);
  String get step2 => Intl.message('Step 2: Save Patched File', name: 'step2', desc: '', args: []);
  String get step2Desc => Intl.message('Confirm patched file is saved', name: 'step2Desc', desc: '', args: []);
  String get step3 => Intl.message('Step 3: Enter Fastboot', name: 'step3', desc: '', args: []);
  String get step3Desc => Intl.message('Reboot device to Fastboot mode', name: 'step3Desc', desc: '', args: []);
  String get step4 => Intl.message('Step 4: Flash boot.img', name: 'step4', desc: '', args: []);
  String get step4Desc => Intl.message('Flash patched file to device', name: 'step4Desc', desc: '', args: []);
  String get startPatch => Intl.message('Start Patch', name: 'startPatch', desc: '', args: []);
  String get patching => Intl.message('Patching...', name: 'patching', desc: '', args: []);
  String get patchedFile => Intl.message('Patched File', name: 'patchedFile', desc: '', args: []);
  String get unknown => Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  String get previousStep => Intl.message('Previous', name: 'previousStep', desc: '', args: []);
  String get nextStep => Intl.message('Next', name: 'nextStep', desc: '', args: []);
  String get rebootToFastboot => Intl.message('Reboot to Fastboot', name: 'rebootToFastboot', desc: '', args: []);
  String get manuallyEnterFastboot => Intl.message('Enter Bootloader Fastboot mode manually', name: 'manuallyEnterFastboot', desc: '', args: []);
  String get manuallyEnterFastbootDesc => Intl.message('1. Power off your Android device completely.\n2. Hold the bootloader key combo (usually Volume Down + Power) until Fastboot/Bootloader appears.\n3. Connect via USB (Samsung Download/Odin mode is incompatible with Fastboot).', name: 'manuallyEnterFastbootDesc', desc: '', args: []);
  String get deviceInFastboot => Intl.message('Device in Fastboot', name: 'deviceInFastboot', desc: '', args: []);
  String get flashFile => Intl.message('Flash File', name: 'flashFile', desc: '', args: []);
  String get flashBoot => Intl.message('Flash boot', name: 'flashBoot', desc: '', args: []);
  String get noFastbootDevice => Intl.message('No Fastboot device detected', name: 'noFastbootDevice', desc: '', args: []);
  String get flashSuccess => Intl.message('Flash successful!', name: 'flashSuccess', desc: '', args: []);
  String get flashComplete => Intl.message('Flash Complete', name: 'flashComplete', desc: '', args: []);
  String get flashCompleteDesc => Intl.message('Reboot device now?', name: 'flashCompleteDesc', desc: '', args: []);
  String get rebootLater => Intl.message('Reboot Later', name: 'rebootLater', desc: '', args: []);
  String get rebootNow => Intl.message('Reboot Now', name: 'rebootNow', desc: '', args: []);
  String get github => Intl.message('GitHub', name: 'github', desc: '', args: []);
  String get matsuzakaYuki => Intl.message('Matsuzaka Yuki', name: 'matsuzakaYuki', desc: '', args: []);
  String get switchToEnglish => Intl.message('Switch to English', name: 'switchToEnglish', desc: '', args: []);
  String get switchToChinese => Intl.message('切换为中文', name: 'switchToChinese', desc: '', args: []);
  String get language => Intl.message('Language', name: 'language', desc: '', args: []);
  String get logConsole => Intl.message('Log Console', name: 'logConsole', desc: '', args: []);
  String get logOutput => Intl.message('Log Output', name: 'logOutput', desc: '', args: []);
  String get logEntries => Intl.message('entries', name: 'logEntries', desc: '', args: []);
  String get noLogs => Intl.message('No logs', name: 'noLogs', desc: '', args: []);
  String get clearLogs => Intl.message('Clear Logs', name: 'clearLogs', desc: '', args: []);
  String get copyLogs => Intl.message('Copy Logs', name: 'copyLogs', desc: '', args: []);
  String get operationProgress => Intl.message('Operation Progress', name: 'operationProgress', desc: '', args: []);
  String get logCheckingFile => Intl.message('Checking file...', name: 'logCheckingFile', desc: '', args: []);
  String logInputFile(Object path) => Intl.message('Input file: $path', name: 'logInputFile', desc: '', args: [path]);
  String logOutputFile(Object path) => Intl.message('Output file: $path', name: 'logOutputFile', desc: '', args: [path]);
  String logKpimgPath(Object path) => Intl.message('Kpimg path: $path', name: 'logKpimgPath', desc: '', args: [path]);
  String logKptoolsPath(Object path) => Intl.message('Kptools path: $path', name: 'logKptoolsPath', desc: '', args: [path]);
  String logWorkDir(Object dir) => Intl.message('Working directory: $dir', name: 'logWorkDir', desc: '', args: [dir]);
  String get logCopyBoot => Intl.message('Copying boot image...', name: 'logCopyBoot', desc: '', args: []);
  String logCopied(Object path) => Intl.message('Copied to $path', name: 'logCopied', desc: '', args: [path]);
  String get logUnpacking => Intl.message('Unpacking boot image...', name: 'logUnpacking', desc: '', args: []);
  String logUnpackSuccess(Object path) => Intl.message('Unpacked kernel: $path', name: 'logUnpackSuccess', desc: '', args: [path]);
  String get logBackupKernel => Intl.message('Backing up kernel...', name: 'logBackupKernel', desc: '', args: []);
  String get logPatchingKernel => Intl.message('Patching kernel...', name: 'logPatchingKernel', desc: '', args: []);
  String get logPatchSuccess => Intl.message('Kernel patched successfully', name: 'logPatchSuccess', desc: '', args: []);
  String get logRepacking => Intl.message('Repacking boot image...', name: 'logRepacking', desc: '', args: []);
  String logRepackSuccess(Object path, Object size) => Intl.message('Repacked: $path ($size MB)', name: 'logRepackSuccess', desc: '', args: [path, size]);
  String get logCleanWorkDir => Intl.message('Cleaning temporary files...', name: 'logCleanWorkDir', desc: '', args: []);
  String logCleanWorkDirFailed(Object error) => Intl.message('Failed to clean temporary files: $error', name: 'logCleanWorkDirFailed', desc: '', args: [error]);
  String logUnpackException(Object error) => Intl.message('Unpack exception: $error', name: 'logUnpackException', desc: '', args: [error]);
  String logRepackException(Object error) => Intl.message('Repack exception: $error', name: 'logRepackException', desc: '', args: [error]);
  String logListPatchInfoFailed(Object error) => Intl.message('Failed to list patch info: $error', name: 'logListPatchInfoFailed', desc: '', args: [error]);
  String logExecuteCmd(Object cmd) => Intl.message('Executing: $cmd', name: 'logExecuteCmd', desc: '', args: [cmd]);
  String get logBackingUpBoot => Intl.message('Backing up boot partition...', name: 'logBackingUpBoot', desc: '', args: []);
  String logBackupComplete(Object path) => Intl.message('Boot backup complete: $path', name: 'logBackupComplete', desc: '', args: [path]);
  String get logBackupFailed => Intl.message('Boot backup failed', name: 'logBackupFailed', desc: '', args: []);
  String get logDeviceNotFastboot => Intl.message('Device not in fastboot mode', name: 'logDeviceNotFastboot', desc: '', args: []);
  String get logPatchingBoot => Intl.message('Patching boot image...', name: 'logPatchingBoot', desc: '', args: []);
  String get logSavingFile => Intl.message('Saving patched file...', name: 'logSavingFile', desc: '', args: []);
  String logFileSaved(Object path) => Intl.message('File saved: $path', name: 'logFileSaved', desc: '', args: [path]);
  String get logNoAdbDevice => Intl.message('No ADB device detected', name: 'logNoAdbDevice', desc: '', args: []);
  String get logRebootingToFastboot => Intl.message('Rebooting to fastboot mode...', name: 'logRebootingToFastboot', desc: '', args: []);
  String get logAutoRebootFailed => Intl.message('Auto reboot to fastboot failed', name: 'logAutoRebootFailed', desc: '', args: []);
  String get logWaitFastbootTimeout => Intl.message('Wait for fastboot timeout', name: 'logWaitFastbootTimeout', desc: '', args: []);
  String get logDeviceInFastboot => Intl.message('Device is in fastboot mode', name: 'logDeviceInFastboot', desc: '', args: []);
  String get logFlashingBoot => Intl.message('Flashing boot image...', name: 'logFlashingBoot', desc: '', args: []);
  String get logFlashFailed => Intl.message('Flash failed', name: 'logFlashFailed', desc: '', args: []);
  String get logFlashSuccess => Intl.message('Flash successful', name: 'logFlashSuccess', desc: '', args: []);
  String get logRebootingDevice => Intl.message('Rebooting device...', name: 'logRebootingDevice', desc: '', args: []);
  String get logRebootSuccess => Intl.message('Device rebooted successfully', name: 'logRebootSuccess', desc: '', args: []);
  String get logAutoRebootFailed2 => Intl.message('Auto reboot failed', name: 'logAutoRebootFailed2', desc: '', args: []);
  String get logOneClickComplete => Intl.message('One-click flash completed!', name: 'logOneClickComplete', desc: '', args: []);
  String logOperationError(Object error) => Intl.message('Operation error: $error', name: 'logOperationError', desc: '', args: [error]);
  String get logStartPatching => Intl.message('Starting patch operation...', name: 'logStartPatching', desc: '', args: []);
  String logPatchComplete(Object path) => Intl.message('Patch complete: $path', name: 'logPatchComplete', desc: '', args: [path]);
  String logPatchFailed(Object error) => Intl.message('Patch failed: $error', name: 'logPatchFailed', desc: '', args: [error]);
  String logPatchException(Object error) => Intl.message('Patch exception: $error', name: 'logPatchException', desc: '', args: [error]);
  String get logCancelling => Intl.message('Cancelling operation...', name: 'logCancelling', desc: '', args: []);
  String get logBackingUpPartition => Intl.message('Backing up partition...', name: 'logBackingUpPartition', desc: '', args: []);
  String logBackupSuccess(Object path) => Intl.message('Backup successful: $path', name: 'logBackupSuccess', desc: '', args: [path]);
  String get logBackupFailedTryAlt => Intl.message('Backup failed, trying alternative method...', name: 'logBackupFailedTryAlt', desc: '', args: []);
  String get logRebootCmdSent => Intl.message('Reboot command sent', name: 'logRebootCmdSent', desc: '', args: []);
  String logFastbootDetected(Object serial) => Intl.message('Fastboot device detected: $serial', name: 'logFastbootDetected', desc: '', args: [serial]);
  String logFlashingBootPath(Object path) => Intl.message('Flashing: $path', name: 'logFlashingBootPath', desc: '', args: [path]);
  String get logFlashBootSuccess => Intl.message('Flash completed successfully', name: 'logFlashBootSuccess', desc: '', args: []);
  String logWaitFastboot(Object timeout) => Intl.message('Waiting for fastboot device ($timeout seconds)', name: 'logWaitFastboot', desc: '', args: [timeout]);
  String get logDeviceRebooting => Intl.message('Device is rebooting...', name: 'logDeviceRebooting', desc: '', args: []);
  String get logCheckAdb => Intl.message('Checking ADB...', name: 'logCheckAdb', desc: '', args: []);
  String get logCheckFastboot => Intl.message('Checking Fastboot...', name: 'logCheckFastboot', desc: '', args: []);
  String get logDriverCheckPassed => Intl.message('Driver check passed', name: 'logDriverCheckPassed', desc: '', args: []);
  String get errSelectBootFirst => Intl.message('Please select boot.img file first', name: 'errSelectBootFirst', desc: '', args: []);
  String errInputNotExist(Object path) => Intl.message('Input file does not exist: $path', name: 'errInputNotExist', desc: '', args: [path]);
  String errKpimgNotExist(Object path) => Intl.message('Kpimg file does not exist: $path', name: 'errKpimgNotExist', desc: '', args: [path]);
  String errKptoolsNotExist(Object path) => Intl.message('Kptools file does not exist: $path', name: 'errKptoolsNotExist', desc: '', args: [path]);
  String errUnpackFailed(Object error) => Intl.message('Unpack failed: $error', name: 'errUnpackFailed', desc: '', args: [error]);
  String get errKernelNotFound => Intl.message('Kernel file not found', name: 'errKernelNotFound', desc: '', args: []);
  String errPatchFailed(Object error) => Intl.message('Patch failed: $error', name: 'errPatchFailed', desc: '', args: [error]);
  String get errOutputKernelNotFound => Intl.message('Output kernel not found', name: 'errOutputKernelNotFound', desc: '', args: []);
  String get errRepackFailed => Intl.message('Repack failed', name: 'errRepackFailed', desc: '', args: []);
  String errPatchException(Object error) => Intl.message('Patch exception: $error', name: 'errPatchException', desc: '', args: [error]);
  String get errFlashBootFailed => Intl.message('Failed to flash boot partition', name: 'errFlashBootFailed', desc: '', args: []);
  String errFlashFailed(Object error) => Intl.message('Flash failed: $error', name: 'errFlashFailed', desc: '', args: [error]);
  String errAdbNotExist(Object path) => Intl.message('ADB executable does not exist: $path', name: 'errAdbNotExist', desc: '', args: [path]);
  String errGetAdbFailed(Object error) => Intl.message('Failed to get ADB devices: $error', name: 'errGetAdbFailed', desc: '', args: [error]);
  String errFastbootNotExist(Object path) => Intl.message('Fastboot executable does not exist: $path', name: 'errFastbootNotExist', desc: '', args: [path]);
  String errGetFastbootFailed(Object error) => Intl.message('Failed to get Fastboot devices: $error', name: 'errGetFastbootFailed', desc: '', args: [error]);
  String errRebootFailed(Object error) => Intl.message('Reboot failed: $error', name: 'errRebootFailed', desc: '', args: [error]);
  String errRebootException(Object error) => Intl.message('Reboot exception: $error', name: 'errRebootException', desc: '', args: [error]);
  String errFlashException(Object error) => Intl.message('Flash exception: $error', name: 'errFlashException', desc: '', args: [error]);
  String errBackupException(Object error) => Intl.message('Backup exception: $error', name: 'errBackupException', desc: '', args: [error]);
  String get errAdbNotAvailable => Intl.message('ADB is not available', name: 'errAdbNotAvailable', desc: '', args: []);
  String get errFastbootNotAvailable => Intl.message('Fastboot is not available', name: 'errFastbootNotAvailable', desc: '', args: []);
  String errDriverCheckFailed(Object error) => Intl.message('Driver check failed: $error', name: 'errDriverCheckFailed', desc: '', args: [error]);
  String get stepSelectBoot => Intl.message('Select Boot File', name: 'stepSelectBoot', desc: '', args: []);
  String get stepBackupBoot => Intl.message('Backup Boot', name: 'stepBackupBoot', desc: '', args: []);
  String get stepPatchImage => Intl.message('Patch Image', name: 'stepPatchImage', desc: '', args: []);
  String get stepSaveFile => Intl.message('Save File', name: 'stepSaveFile', desc: '', args: []);
  String get stepRebootToFastboot => Intl.message('Reboot to Fastboot', name: 'stepRebootToFastboot', desc: '', args: []);
  String get stepFlashDevice => Intl.message('Flash to Device', name: 'stepFlashDevice', desc: '', args: []);
  String get stepRebootComplete => Intl.message('Reboot Device', name: 'stepRebootComplete', desc: '', args: []);
  String get clientCheck => Intl.message('Client Detection', name: 'clientCheck', desc: '', args: []);
  String get apatchDesc => Intl.message('Android kernel-level root solution', name: 'apatchDesc', desc: '', args: []);
  String get folkpatchDesc => Intl.message('An excellent KernelPatch management client', name: 'folkpatchDesc', desc: '', args: []);
  String get installed => Intl.message('Installed', name: 'installed', desc: '', args: []);
  String get install => Intl.message('Install', name: 'install', desc: '', args: []);
  String get installing => Intl.message('Installing...', name: 'installing', desc: '', args: []);
  String installSuccess(Object name) => Intl.message('$name installed successfully', name: 'installSuccess', desc: '', args: [name]);
  String installFailed(Object name) => Intl.message('$name installation failed', name: 'installFailed', desc: '', args: [name]);
  String get simplePatch => Intl.message('Simple Patch', name: 'simplePatch', desc: '', args: []);
  String get simplePatchSubtitle => Intl.message('Patch boot.img only, save file manually', name: 'simplePatchSubtitle', desc: '', args: []);
  String get saveToFile => Intl.message('Save to File', name: 'saveToFile', desc: '', args: []);
  String get saveAs => Intl.message('Save As', name: 'saveAs', desc: '', args: []);
  String get selectSaveLocation => Intl.message('Select save location', name: 'selectSaveLocation', desc: '', args: []);
  String get fileSavedSuccessfully => Intl.message('File saved successfully', name: 'fileSavedSuccessfully', desc: '', args: []);
  String get patchOnlyComplete => Intl.message('Patch complete!', name: 'patchOnlyComplete', desc: '', args: []);
  String get savePatchedFile => Intl.message('Save Patched File', name: 'savePatchedFile', desc: '', args: []);
  String get driverInstall => Intl.message('Driver Install', name: 'driverInstall', desc: '', args: []);
  String get driverInstallSubtitle => Intl.message('Install the driver to resolve missing driver issues', name: 'driverInstallSubtitle', desc: '', args: []);
  String get driverInstallPage => Intl.message('Driver Installation', name: 'driverInstallPage', desc: '', args: []);
  String get qualcommDriver64 => Intl.message('Qualcomm Fastboot Driver (64-bit)', name: 'qualcommDriver64', desc: '', args: []);
  String get qualcommDriver64Desc => Intl.message('Qualcomm device driver for 64-bit Windows systems', name: 'qualcommDriver64Desc', desc: '', args: []);
  String get qualcommDriver32 => Intl.message('Qualcomm Fastboot Driver (32-bit)', name: 'qualcommDriver32', desc: '', args: []);
  String get qualcommDriver32Desc => Intl.message('Qualcomm device driver for 32-bit Windows systems', name: 'qualcommDriver32Desc', desc: '', args: []);
  String get mediatekDriver => Intl.message('MediaTek USB Driver', name: 'mediatekDriver', desc: '', args: []);
  String get mediatekDriverDesc => Intl.message('USB driver for MediaTek chipset devices', name: 'mediatekDriverDesc', desc: '', args: []);
  String get oneplusAdbDriver => Intl.message('OnePlus Official ADB Driver', name: 'oneplusAdbDriver', desc: '', args: []);
  String get oneplusAdbDriverDesc => Intl.message('Official OnePlus ADB driver for Windows 7 systems', name: 'oneplusAdbDriverDesc', desc: '', args: []);
  String get oppoAdbDriver => Intl.message('OPPO Official ADB Driver', name: 'oppoAdbDriver', desc: '', args: []);
  String get oppoAdbDriverDesc => Intl.message('Official OPPO USB driver for Windows 10 and above', name: 'oppoAdbDriverDesc', desc: '', args: []);
  String get installDriver => Intl.message('Install Driver', name: 'installDriver', desc: '', args: []);
  String get installDriverSuccess => Intl.message('Driver installer launched', name: 'installDriverSuccess', desc: '', args: []);
  String installDriverFailed(Object error) => Intl.message('Failed to launch installer: $error', name: 'installDriverFailed', desc: '', args: [error]);
  String get kernelPatchVersion => Intl.message('KernelPatch Version', name: 'kernelPatchVersion', desc: '', args: []);
  String get selectVersion => Intl.message('Select Version', name: 'selectVersion', desc: '', args: []);
  String get selectVersionDesc => Intl.message('Select the KernelPatch version to use', name: 'selectVersionDesc', desc: '', args: []);
  String get customVersion => Intl.message('Custom Version', name: 'customVersion', desc: '', args: []);
  String get selectCustomVersion => Intl.message('Select custom kpimg file', name: 'selectCustomVersion', desc: '', args: []);
  String get currentVersion => Intl.message('Current Version', name: 'currentVersion', desc: '', args: []);
  String get noVersionSelected => Intl.message('No version selected', name: 'noVersionSelected', desc: '', args: []);
  String get versionRecommended => Intl.message('Recommended', name: 'versionRecommended', desc: '', args: []);
  String get versionSupportUnpack => Intl.message('Built-in Unpack', name: 'versionSupportUnpack', desc: '', args: []);
  String get versionCustom => Intl.message('Custom', name: 'versionCustom', desc: '', args: []);
  String get invalidVersionFile => Intl.message('Invalid version file', name: 'invalidVersionFile', desc: '', args: []);
  String get customVersionSaved => Intl.message('Custom version saved', name: 'customVersionSaved', desc: '', args: []);
  String get loadingVersions => Intl.message('Loading versions...', name: 'loadingVersions', desc: '', args: []);
  String get noVersionsAvailable => Intl.message('No versions available', name: 'noVersionsAvailable', desc: '', args: []);
  String get patchTarget => Intl.message('Patch Target', name: 'patchTarget', desc: '', args: []);
  String get patchTargetDesc => Intl.message('Select patch target to use corresponding KernelPatch version', name: 'patchTargetDesc', desc: '', args: []);
  String get switchTheme => Intl.message('Switch Theme', name: 'switchTheme', desc: '', args: []);
  String get themeSystem => Intl.message('Follow System', name: 'themeSystem', desc: '', args: []);
  String get themeLight => Intl.message('Light Mode', name: 'themeLight', desc: '', args: []);
  String get themeDark => Intl.message('Dark Mode', name: 'themeDark', desc: '', args: []);
  String get logsCopied => Intl.message('Logs copied to clipboard', name: 'logsCopied', desc: '', args: []);
  String get navDashboard => Intl.message('Dashboard', name: 'navDashboard', desc: '', args: []);
  String get navQuickShort => Intl.message('Quick', name: 'navQuickShort', desc: '', args: []);
  String get navStepShort => Intl.message('Steps', name: 'navStepShort', desc: '', args: []);
  String get navLocalShort => Intl.message('Local', name: 'navLocalShort', desc: '', args: []);
  String get navDriversShort => Intl.message('Drivers', name: 'navDriversShort', desc: '', args: []);
  String get navMore => Intl.message('More', name: 'navMore', desc: '', args: []);
  String get navSettings => Intl.message('Settings', name: 'navSettings', desc: '', args: []);
  String get toggleNavigation => Intl.message('Toggle Navigation', name: 'toggleNavigation', desc: '', args: []);
  String get settingsShortcutTooltip => Intl.message('Settings (Ctrl+,)', name: 'settingsShortcutTooltip', desc: '', args: []);
  String get operationInProgressNavBlocked => Intl.message('An operation is currently running. Wait for completion or cancel before leaving this view.', name: 'operationInProgressNavBlocked', desc: '', args: []);
  String newVersionAvailable(Object version) => Intl.message('New version available: $version', name: 'newVersionAvailable', desc: '', args: [version]);
  String get download => Intl.message('Download', name: 'download', desc: '', args: []);
  String get dismiss => Intl.message('Dismiss', name: 'dismiss', desc: '', args: []);
  String get clearRecentFilesTitle => Intl.message('Clear Recent Files?', name: 'clearRecentFilesTitle', desc: '', args: []);
  String get clearRecentFilesDesc => Intl.message('This removes entries from the Recent Files list. Your actual files on disk will not be deleted.', name: 'clearRecentFilesDesc', desc: '', args: []);
  String get clearAll => Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  String get cancel => Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  String get fileMissingBadge => Intl.message('Missing', name: 'fileMissingBadge', desc: '', args: []);
  String get openFileLocation => Intl.message('Open File Location', name: 'openFileLocation', desc: '', args: []);
  String get removeFromList => Intl.message('Remove from list', name: 'removeFromList', desc: '', args: []);
  String get recentFileMissingHint => Intl.message('This file no longer exists on disk. You can remove it from the list.', name: 'recentFileMissingHint', desc: '', args: []);
  String appVersionWithBuild(Object version, Object build) => Intl.message('FolkTool v$version (Build $build)', name: 'appVersionWithBuild', desc: '', args: [version, build]);
  String get deviceStateDisconnected => Intl.message('Disconnected', name: 'deviceStateDisconnected', desc: '', args: []);
  String get deviceStateAdb => Intl.message('ADB', name: 'deviceStateAdb', desc: '', args: []);
  String get deviceStateFastboot => Intl.message('Fastboot (Bootloader)', name: 'deviceStateFastboot', desc: '', args: []);
  String get deviceStateFastbootd => Intl.message('Fastbootd (Userspace)', name: 'deviceStateFastbootd', desc: '', args: []);
  String get deviceStateUnauthorized => Intl.message('Unauthorized', name: 'deviceStateUnauthorized', desc: '', args: []);
  String get deviceStateOffline => Intl.message('Offline', name: 'deviceStateOffline', desc: '', args: []);
  String get deviceStateRecovery => Intl.message('Recovery', name: 'deviceStateRecovery', desc: '', args: []);
  String get deviceStateSideload => Intl.message('Sideload', name: 'deviceStateSideload', desc: '', args: []);
  String get deviceStateMultiple => Intl.message('Multiple', name: 'deviceStateMultiple', desc: '', args: []);
  String get deviceStateUnsupported => Intl.message('Unsupported Mode', name: 'deviceStateUnsupported', desc: '', args: []);
  String get deviceStateError => Intl.message('Detection Error', name: 'deviceStateError', desc: '', args: []);
  String usbUnauthorizedTitle(Object serial) => Intl.message('USB Debugging Unauthorized ($serial)', name: 'usbUnauthorizedTitle', desc: '', args: [serial]);
  String get usbUnauthorizedDesc => Intl.message('Unlock your phone screen and tap "Allow USB debugging" (check "Always allow from this computer").', name: 'usbUnauthorizedDesc', desc: '', args: []);
  String adbOfflineTitle(Object serial) => Intl.message('ADB Device Offline ($serial)', name: 'adbOfflineTitle', desc: '', args: [serial]);
  String get adbOfflineDesc => Intl.message('Reconnect the USB cable, try a direct USB port, or toggle USB Debugging off and back on.', name: 'adbOfflineDesc', desc: '', args: []);
  String fastbootdDetectedTitle(Object serial) => Intl.message('Userspace Fastbootd Active ($serial)', name: 'fastbootdDetectedTitle', desc: '', args: [serial]);
  String get fastbootdDetectedDesc => Intl.message('Boot image flashing requires Bootloader Fastboot mode rather than userspace fastbootd. Reboot to Bootloader first.', name: 'fastbootdDetectedDesc', desc: '', args: []);
  String unsupportedModeTitle(Object mode, Object serial) => Intl.message('Unsupported USB Mode ($mode): $serial', name: 'unsupportedModeTitle', desc: '', args: [mode, serial]);
  String get unsupportedModeDesc => Intl.message('Boot patching/flashing requires Android ADB (system booted) or Bootloader Fastboot mode. Samsung Download/Odin mode is incompatible with Fastboot.', name: 'unsupportedModeDesc', desc: '', args: []);
  String get multipleDevicesTitle => Intl.message('Multiple Devices Detected', name: 'multipleDevicesTitle', desc: '', args: []);
  String get multipleDevicesDesc => Intl.message('Select one target device or disconnect extra devices/emulators before flashing.', name: 'multipleDevicesDesc', desc: '', args: []);
  String get deviceErrorTitle => Intl.message('Device Detection Error', name: 'deviceErrorTitle', desc: '', args: []);
  String androidVersionLabel(Object version) => Intl.message('Android $version', name: 'androidVersionLabel', desc: '', args: [version]);
  String batteryLevelLabel(Object percent) => Intl.message('Battery $percent%', name: 'batteryLevelLabel', desc: '', args: [percent]);
  String get bootloaderUnlockedLabel => Intl.message('Bootloader Unlocked', name: 'bootloaderUnlockedLabel', desc: '', args: []);
  String get bootloaderLockedLabel => Intl.message('Bootloader Locked', name: 'bootloaderLockedLabel', desc: '', args: []);
  String clientPackageLabel(Object pkg) => Intl.message('Package: $pkg', name: 'clientPackageLabel', desc: '', args: [pkg]);
  String clientVersionBadge(Object version) => Intl.message('Bundled $version', name: 'clientVersionBadge', desc: '', args: [version]);
  String get logCheckingClient => Intl.message('Checking installed manager apps...', name: 'logCheckingClient', desc: '', args: []);
  String errCheckClientFailed(Object error) => Intl.message('Failed to check installed apps: $error', name: 'errCheckClientFailed', desc: '', args: [error]);
  String errApkNotFound(Object path) => Intl.message('APK file does not exist: $path', name: 'errApkNotFound', desc: '', args: [path]);
  String logInstallingApk(Object path) => Intl.message('Installing APK: $path', name: 'logInstallingApk', desc: '', args: [path]);
  String get logInstallApkSuccess => Intl.message('APK installed successfully', name: 'logInstallApkSuccess', desc: '', args: []);
  String errInstallApkFailed(Object error) => Intl.message('APK installation failed: $error', name: 'errInstallApkFailed', desc: '', args: [error]);
  String errInstallApkException(Object error) => Intl.message('APK installation exception: $error', name: 'errInstallApkException', desc: '', args: [error]);
  String get deviceSafeBadge => Intl.message('Device Safe', name: 'deviceSafeBadge', desc: '', args: []);
  String get checkDeviceStateBadge => Intl.message('Check Device State', name: 'checkDeviceStateBadge', desc: '', args: []);
  String errorWhy(Object reason) => Intl.message('Why: $reason', name: 'errorWhy', desc: '', args: [reason]);
  String errorStage(Object stage) => Intl.message('Stage: $stage', name: 'errorStage', desc: '', args: [stage]);
  String get copyDetails => Intl.message('Copy Details', name: 'copyDetails', desc: '', args: []);
  String get errorDetailsCopied => Intl.message('Error details copied to clipboard', name: 'errorDetailsCopied', desc: '', args: []);
  String get viewLogs => Intl.message('View Logs', name: 'viewLogs', desc: '', args: []);
  String get clearLogsDialogTitle => Intl.message('Clear Logs?', name: 'clearLogsDialogTitle', desc: '', args: []);
  String get clearLogsDialogBody => Intl.message('This will clear the visible operation log entries for the current session.', name: 'clearLogsDialogBody', desc: '', args: []);
  String get clear => Intl.message('Clear', name: 'clear', desc: '', args: []);
  String get filterLogsHint => Intl.message('Filter logs...', name: 'filterLogsHint', desc: '', args: []);
  String get filterAll => Intl.message('All', name: 'filterAll', desc: '', args: []);
  String get filterInfo => Intl.message('Info', name: 'filterInfo', desc: '', args: []);
  String get filterOk => Intl.message('OK', name: 'filterOk', desc: '', args: []);
  String get filterWarn => Intl.message('Warn', name: 'filterWarn', desc: '', args: []);
  String get filterErr => Intl.message('Err', name: 'filterErr', desc: '', args: []);
  String get errCatDeviceConnection => Intl.message('Device Connection', name: 'errCatDeviceConnection', desc: '', args: []);
  String get errCatAdb => Intl.message('ADB', name: 'errCatAdb', desc: '', args: []);
  String get errCatFastboot => Intl.message('Fastboot', name: 'errCatFastboot', desc: '', args: []);
  String get errCatDriver => Intl.message('Driver', name: 'errCatDriver', desc: '', args: []);
  String get errCatFile => Intl.message('File', name: 'errCatFile', desc: '', args: []);
  String get errCatImageValidation => Intl.message('Image Validation', name: 'errCatImageValidation', desc: '', args: []);
  String get errCatCompatibility => Intl.message('Compatibility', name: 'errCatCompatibility', desc: '', args: []);
  String get errCatPermission => Intl.message('Permission', name: 'errCatPermission', desc: '', args: []);
  String get errCatNetwork => Intl.message('Network', name: 'errCatNetwork', desc: '', args: []);
  String get errCatDownload => Intl.message('Download', name: 'errCatDownload', desc: '', args: []);
  String get errCatExtraction => Intl.message('Extraction', name: 'errCatExtraction', desc: '', args: []);
  String get errCatProcess => Intl.message('Process', name: 'errCatProcess', desc: '', args: []);
  String get errCatFlashing => Intl.message('Flashing', name: 'errCatFlashing', desc: '', args: []);
  String get errCatApplication => Intl.message('Application', name: 'errCatApplication', desc: '', args: []);
  String get settingsAppearanceSection => Intl.message('Appearance & Language', name: 'settingsAppearanceSection', desc: '', args: []);
  String get settingsThemeLabel => Intl.message('Theme', name: 'settingsThemeLabel', desc: '', args: []);
  String get settingsThemeSystem => Intl.message('System', name: 'settingsThemeSystem', desc: '', args: []);
  String get settingsThemeLight => Intl.message('Light', name: 'settingsThemeLight', desc: '', args: []);
  String get settingsThemeDark => Intl.message('Dark', name: 'settingsThemeDark', desc: '', args: []);
  String get settingsMonitoringSection => Intl.message('Device Monitoring & Safety', name: 'settingsMonitoringSection', desc: '', args: []);
  String get settingsAutoMonitorTitle => Intl.message('Auto-monitor connected devices', name: 'settingsAutoMonitorTitle', desc: '', args: []);
  String get settingsAutoMonitorDesc => Intl.message('Periodically detect ADB & Fastboot state changes in the background', name: 'settingsAutoMonitorDesc', desc: '', args: []);
  String get settingsConfirmFlashTitle => Intl.message('Confirm before flashing', name: 'settingsConfirmFlashTitle', desc: '', args: []);
  String get settingsConfirmFlashDesc => Intl.message('Show target device, image, and safety summary before writing boot partition', name: 'settingsConfirmFlashDesc', desc: '', args: []);
  String get settingsRedactDiagTitle => Intl.message('Redact personal info in diagnostics', name: 'settingsRedactDiagTitle', desc: '', args: []);
  String get settingsRedactDiagDesc => Intl.message('Mask Windows usernames and full device serials when exporting diagnostic bundles', name: 'settingsRedactDiagDesc', desc: '', args: []);
  String get settingsCheckUpdatesTitle => Intl.message('Check for updates on launch', name: 'settingsCheckUpdatesTitle', desc: '', args: []);
  String get settingsCheckUpdatesDesc => Intl.message('Check GitHub releases for newer FolkTool versions', name: 'settingsCheckUpdatesDesc', desc: '', args: []);
  String get settingsToolchainSection => Intl.message('Toolchain & Runtime Diagnostics', name: 'settingsToolchainSection', desc: '', args: []);
  String get settingsPlatformToolsTitle => Intl.message('Android Platform-Tools', name: 'settingsPlatformToolsTitle', desc: '', args: []);
  String get settingsPlatformToolsRevLabel => Intl.message('Platform-Tools Revision', name: 'settingsPlatformToolsRevLabel', desc: '', args: []);
  String get settingsAdbVersionLabel => Intl.message('ADB version', name: 'settingsAdbVersionLabel', desc: '', args: []);
  String get settingsFastbootVersionLabel => Intl.message('Fastboot version', name: 'settingsFastbootVersionLabel', desc: '', args: []);
  String get settingsKptoolsVersionLabel => Intl.message('KernelPatch Patcher (kptools)', name: 'settingsKptoolsVersionLabel', desc: '', args: []);
  String get settingsRefreshToolchain => Intl.message('Re-verify Toolchain', name: 'settingsRefreshToolchain', desc: '', args: []);
  String get settingsToolchainReady => Intl.message('Verified & Ready', name: 'settingsToolchainReady', desc: '', args: []);
  String get settingsToolchainMissing => Intl.message('Missing / Attention Needed', name: 'settingsToolchainMissing', desc: '', args: []);
  String get settingsStorageSection => Intl.message('Storage & Maintenance', name: 'settingsStorageSection', desc: '', args: []);
  String get settingsClearRecentTitle => Intl.message('Clear recent files history', name: 'settingsClearRecentTitle', desc: '', args: []);
  String get settingsClearRecentDesc => Intl.message('Removes entries from the Recent Files list (your files on disk are not deleted)', name: 'settingsClearRecentDesc', desc: '', args: []);
  String get clearList => Intl.message('Clear List', name: 'clearList', desc: '', args: []);
  String get recentFilesCleared => Intl.message('Recent files history cleared', name: 'recentFilesCleared', desc: '', args: []);
  String get settingsClearSessionLogsTitle => Intl.message('Clear session logs', name: 'settingsClearSessionLogsTitle', desc: '', args: []);
  String get settingsClearSessionLogsDesc => Intl.message('Clears in-memory operation logs for the current session', name: 'settingsClearSessionLogsDesc', desc: '', args: []);
  String get clearSessionLogsConfirmBody => Intl.message('All current in-memory log entries will be cleared.', name: 'clearSessionLogsConfirmBody', desc: '', args: []);
  String get sessionLogsCleared => Intl.message('Session logs cleared', name: 'sessionLogsCleared', desc: '', args: []);
  String get settingsOpenFoldersTitle => Intl.message('Open logs & backup folders', name: 'settingsOpenFoldersTitle', desc: '', args: []);
  String get settingsOpenFoldersDesc => Intl.message('View exported logs, crash-safe session logs, and stock boot backups', name: 'settingsOpenFoldersDesc', desc: '', args: []);
  String get folderLogsButton => Intl.message('Logs', name: 'folderLogsButton', desc: '', args: []);
  String get folderBackupsButton => Intl.message('Backups', name: 'folderBackupsButton', desc: '', args: []);
  String get settingsClearDiskLogsTitle => Intl.message('Clear saved log files on disk', name: 'settingsClearDiskLogsTitle', desc: '', args: []);
  String get settingsClearDiskLogsDesc => Intl.message('Deletes archived .txt and .log files inside FolkTool/logs (stock boot backups are untouched)', name: 'settingsClearDiskLogsDesc', desc: '', args: []);
  String get deleteDiskLogsConfirmTitle => Intl.message('Delete Saved Log Files?', name: 'deleteDiskLogsConfirmTitle', desc: '', args: []);
  String get deleteDiskLogsConfirmBody => Intl.message('All saved log files in FolkTool/logs will be permanently deleted. Your boot images and backups remain untouched.', name: 'deleteDiskLogsConfirmBody', desc: '', args: []);
  String get deleteLogsButton => Intl.message('Delete Logs', name: 'deleteLogsButton', desc: '', args: []);
  String get delete => Intl.message('Delete', name: 'delete', desc: '', args: []);
  String get noSavedLogsToDelete => Intl.message('No saved log files to delete', name: 'noSavedLogsToDelete', desc: '', args: []);
  String deletedSavedLogsCount(Object count) => Intl.message('Deleted $count saved log file(s)', name: 'deletedSavedLogsCount', desc: '', args: [count]);
  String get settingsResetDefaultsTitle => Intl.message('Reset settings to defaults', name: 'settingsResetDefaultsTitle', desc: '', args: []);
  String get settingsResetDefaultsDesc => Intl.message('Restores safety toggles and monitoring preferences to defaults', name: 'settingsResetDefaultsDesc', desc: '', args: []);
  String get resetAllSettingsConfirmTitle => Intl.message('Reset All Settings?', name: 'resetAllSettingsConfirmTitle', desc: '', args: []);
  String get resetAllSettingsConfirmBody => Intl.message('Restore all safety, monitoring, and diagnostic preferences to default values?', name: 'resetAllSettingsConfirmBody', desc: '', args: []);
  String get settingsRestoredNotice => Intl.message('Settings restored to defaults', name: 'settingsRestoredNotice', desc: '', args: []);
  String settingsFooterSummary(Object appName, Object version) => Intl.message('$appName v$version • Runs with explicit preflight checks, signed driver verification, and standard Windows security policies.', name: 'settingsFooterSummary', desc: '', args: [appName, version]);
  String driverInstallConfirmTitle(Object name) => Intl.message('Install $name?', name: 'driverInstallConfirmTitle', desc: '', args: [name]);
  String driverPublisherLabel(Object publisher) => Intl.message('Publisher: $publisher', name: 'driverPublisherLabel', desc: '', args: [publisher]);
  String driverSupportedModesLabel(Object modes) => Intl.message('Supported Modes: $modes', name: 'driverSupportedModesLabel', desc: '', args: [modes]);
  String get driverSignatureNotice => Intl.message('FolkTool will verify the installer Authenticode signature and then request Windows Administrator (UAC) permission to install the driver.', name: 'driverSignatureNotice', desc: '', args: []);
  String get verifyAndInstall => Intl.message('Verify & Install', name: 'verifyAndInstall', desc: '', args: []);
  String installDriverSuccessReconnect(Object msg) => Intl.message('$msg Reconnect your device or reboot Windows if needed.', name: 'installDriverSuccessReconnect', desc: '', args: [msg]);
  String unableOpenSamsungPage(Object error) => Intl.message('Unable to open official Samsung page: $error', name: 'unableOpenSamsungPage', desc: '', args: [error]);
  String get toolsAvailableTitle => Intl.message('ADB & Fastboot Tools Available', name: 'toolsAvailableTitle', desc: '', args: []);
  String get toolsMissingTitle => Intl.message('ADB / Fastboot Tools Not Detected', name: 'toolsMissingTitle', desc: '', args: []);
  String get recheck => Intl.message('Re-check', name: 'recheck', desc: '', args: []);
  String get driverHelpGuide => Intl.message('• ADB Driver: Required when Android is booted with USB Debugging enabled.\n• Fastboot Driver: Required in Bootloader mode. If Device Manager shows an unknown "Android" device with a yellow triangle, open Windows Update -> Optional Updates -> Driver Updates and install "Android Bootloader Interface".\n• Administrator Permission: Driver installers require Windows UAC approval and Authenticode signature verification.', name: 'driverHelpGuide', desc: '', args: []);
  String driverLaunchedResult(Object status) => Intl.message('Driver installer launched (Signature: $status). Reconnect device or reboot Windows if needed.', name: 'driverLaunchedResult', desc: '', args: [status]);
  String get samsungDriverName => Intl.message('Samsung Official Android USB Driver', name: 'samsungDriverName', desc: '', args: []);
  String get samsungDriverModes => Intl.message('ADB / MTP / Samsung Download Mode', name: 'samsungDriverModes', desc: '', args: []);
  String get samsungDriverDesc => Intl.message('Official Samsung USB Driver for Galaxy phones/tablets. Downloads directly from Samsung Developer Portal so you can verify the official Samsung digital signature before running with Administrator privileges.', name: 'samsungDriverDesc', desc: '', args: []);
  String get downloadOfficialSamsungDriver => Intl.message('Download Official Samsung USB Driver', name: 'downloadOfficialSamsungDriver', desc: '', args: []);
  String get confirmQuickFlashTitle => Intl.message('Confirm One-Click Flash', name: 'confirmQuickFlashTitle', desc: '', args: []);
  String confirmTargetDevice(Object device) => Intl.message('Target Device: $device', name: 'confirmTargetDevice', desc: '', args: [device]);
  String get noneDetected => Intl.message('None detected', name: 'noneDetected', desc: '', args: []);
  String confirmBootImage(Object path) => Intl.message('Boot Image: $path', name: 'confirmBootImage', desc: '', args: [path]);
  String confirmPatchTarget(Object target) => Intl.message('Patch Target: $target', name: 'confirmPatchTarget', desc: '', args: [target]);
  String confirmKpVersion(Object version) => Intl.message('Version: $version', name: 'confirmKpVersion', desc: '', args: [version]);
  String get confirmQuickFlashBody => Intl.message('This will patch the boot image, reboot to Bootloader Fastboot, and flash the boot partition. Ensure your bootloader is unlocked and do not disconnect USB during flashing.', name: 'confirmQuickFlashBody', desc: '', args: []);
  String get startFlashingButton => Intl.message('Start Flashing', name: 'startFlashingButton', desc: '', args: []);
  String diagnosticsSaved(Object path) => Intl.message('Diagnostics saved: $path', name: 'diagnosticsSaved', desc: '', args: [path]);
  String get exportDiagnostics => Intl.message('Export Diagnostics', name: 'exportDiagnostics', desc: '', args: []);
  String get connectFastbootToRestore => Intl.message('Connect device in Fastboot mode to restore stock boot.', name: 'connectFastbootToRestore', desc: '', args: []);
  String get restoreStockBootSuccess => Intl.message('Stock boot image restored.', name: 'restoreStockBootSuccess', desc: '', args: []);
  String get restoreStockBootFailed => Intl.message('Failed to restore stock boot image.', name: 'restoreStockBootFailed', desc: '', args: []);
  String get restoreStockBootButton => Intl.message('Restore Stock Boot', name: 'restoreStockBootButton', desc: '', args: []);
  String get preflightReady => Intl.message('Preflight Ready', name: 'preflightReady', desc: '', args: []);
  String get preflightActionRequired => Intl.message('Preflight Action Required', name: 'preflightActionRequired', desc: '', args: []);
  String get folkpatchSubtitle => Intl.message('LyraVoid Fork • Extended KP', name: 'folkpatchSubtitle', desc: '', args: []);
  String get apatchSubtitle => Intl.message('bmax121 Official Upstream', name: 'apatchSubtitle', desc: '', args: []);
  String get versionChannelStable => Intl.message('Stable', name: 'versionChannelStable', desc: '', args: []);
  String get versionChannelPrerelease => Intl.message('Pre-release', name: 'versionChannelPrerelease', desc: '', args: []);
  String get versionChannelLegacy => Intl.message('Legacy', name: 'versionChannelLegacy', desc: '', args: []);
  String get versionManagerLabel => Intl.message('Manager', name: 'versionManagerLabel', desc: '', args: []);
  String get versionKpLabel => Intl.message('KernelPatch', name: 'versionKpLabel', desc: '', args: []);
  String get versionReleaseDateLabel => Intl.message('Released', name: 'versionReleaseDateLabel', desc: '', args: []);
  String get versionCompatLabel => Intl.message('Compatibility', name: 'versionCompatLabel', desc: '', args: []);
  String get versionKptoolsLabel => Intl.message('Engine', name: 'versionKptoolsLabel', desc: '', args: []);
  String get versionVerifiedBadge => Intl.message('SHA-256 Verified', name: 'versionVerifiedBadge', desc: '', args: []);
  String versionUnpackUnsupportedWarn(Object version) => Intl.message('Selected version ($version) is an older release without built-in kptools unpack or newer GKI 6.x patches. Prefer 0.13.8+ unless targeting an older kernel.', name: 'versionUnpackUnsupportedWarn', desc: '', args: [version]);
  String get catalogNotesFolkpatch115404 => Intl.message('Latest FolkPatch manager (115404) with updated KernelPatch 0.13.9 BTF, hotpatch fixes, MTE-safe ksyms scans, and boot image sizing updates.', name: 'catalogNotesFolkpatch115404', desc: '', args: []);
  String get catalogNotesFolkpatch115357 => Intl.message('FolkPatch manager (115357) with KernelPatch 0.13.9 and WebUI shell leak fix.', name: 'catalogNotesFolkpatch115357', desc: '', args: []);
  String get catalogNotesFolkpatch0138 => Intl.message('FolkPatch v5.0 (115032) with KernelPatch 0.13.8 compatibility for non-GKI & Android 16 kernels.', name: 'catalogNotesFolkpatch0138', desc: '', args: []);
  String get catalogNotesApatch11282 => Intl.message('Latest official APatch (11282) with KernelPatch 0.13.9 and HyperOS/Pengpai 4.0 kernel adaptation.', name: 'catalogNotesApatch11282', desc: '', args: []);
  String get catalogNotesApatch11224 => Intl.message('Official APatch (11224) with KernelPatch 0.13.3 baseline.', name: 'catalogNotesApatch11224', desc: '', args: []);
  String get catalogNotesApatch11142 => Intl.message('Legacy official APatch (11142) with KernelPatch 0.12.2 for older kernels (3.18 - 6.6).', name: 'catalogNotesApatch11142', desc: '', args: []);
  String get errTitleNoBootSelected => Intl.message('No Boot Image Selected', name: 'errTitleNoBootSelected', desc: '', args: []);
  String get errNextSelectBoot => Intl.message('Select a valid boot.img file first.', name: 'errNextSelectBoot', desc: '', args: []);
  String get errTitleBootNotFound => Intl.message('Boot Image Not Found', name: 'errTitleBootNotFound', desc: '', args: []);
  String get errMsgBootNotFound => Intl.message('The selected boot image file no longer exists or was moved.', name: 'errMsgBootNotFound', desc: '', args: []);
  String get errTitleEmptyBoot => Intl.message('Empty Boot Image', name: 'errTitleEmptyBoot', desc: '', args: []);
  String get errMsgEmptyBoot => Intl.message('The selected boot image file is 0 bytes.', name: 'errMsgEmptyBoot', desc: '', args: []);
  String get errNextEmptyBoot => Intl.message('Provide a valid, non-empty stock boot.img.', name: 'errNextEmptyBoot', desc: '', args: []);
  String get errTitleCannotReadBoot => Intl.message('Cannot Read Boot Image', name: 'errTitleCannotReadBoot', desc: '', args: []);
  String get errMsgCannotReadBoot => Intl.message('FolkTool could not read the selected boot.img file. Check file permissions or close apps locking it.', name: 'errMsgCannotReadBoot', desc: '', args: []);
  String get errNextCannotReadBoot => Intl.message('Ensure read permissions on the image file or copy it to a local folder.', name: 'errNextCannotReadBoot', desc: '', args: []);
  String get warnNonStandardBootMagic => Intl.message('File header does not start with standard ANDROID! magic (some vendor/LZ4/vendor_boot images differ — verify before flashing).', name: 'warnNonStandardBootMagic', desc: '', args: []);
  String get errTitleMissingKpimg => Intl.message('Missing KernelPatch Image (kpimg)', name: 'errTitleMissingKpimg', desc: '', args: []);
  String get errMsgMissingKpimg => Intl.message('The selected KernelPatch version file was not found or is empty.', name: 'errMsgMissingKpimg', desc: '', args: []);
  String get errNextMissingKpimg => Intl.message('Select a valid built-in or custom kpimg file before patching.', name: 'errNextMissingKpimg', desc: '', args: []);
  String get errTitleInvalidKpm => Intl.message('Invalid KPM Module', name: 'errTitleInvalidKpm', desc: '', args: []);
  String errMsgInvalidKpm(Object path) => Intl.message('One of the selected KPM modules is missing or empty: $path', name: 'errMsgInvalidKpm', desc: '', args: [path]);
  String get errNextInvalidKpm => Intl.message('Remove the missing KPM module or re-select it.', name: 'errNextInvalidKpm', desc: '', args: []);
  String errTitleMissingTool(Object tool) => Intl.message('Missing Required Tool ($tool)', name: 'errTitleMissingTool', desc: '', args: [tool]);
  String errMsgMissingTool(Object tool) => Intl.message('Bundled tool $tool was not found at expected path.', name: 'errMsgMissingTool', desc: '', args: [tool]);
  String get errNextMissingTool => Intl.message('Reinstall or repair FolkTool, or restore the bin/ and kp_versions/ directories.', name: 'errNextMissingTool', desc: '', args: []);
  String get errTitleMultipleDevices => Intl.message('Multiple Devices Connected', name: 'errTitleMultipleDevices', desc: '', args: []);
  String get errMsgMultipleDevices => Intl.message('More than one device is connected to this PC.', name: 'errMsgMultipleDevices', desc: '', args: []);
  String get errNextMultipleDevices => Intl.message('Disconnect extra devices or choose one target device in Device Status.', name: 'errNextMultipleDevices', desc: '', args: []);
  String get errTitleNoDevice => Intl.message('No Device Connected', name: 'errTitleNoDevice', desc: '', args: []);
  String get errMsgNoDevice => Intl.message('No Android device was detected in ADB or Fastboot mode.', name: 'errMsgNoDevice', desc: '', args: []);
  String get errNextNoDevice => Intl.message('Connect your device via USB, enable USB debugging, or enter Bootloader Fastboot mode.', name: 'errNextNoDevice', desc: '', args: []);
  String get errTitleUnauthorized => Intl.message('Device Unauthorized', name: 'errTitleUnauthorized', desc: '', args: []);
  String errMsgUnauthorized(Object serial) => Intl.message('Device $serial has not authorized USB debugging.', name: 'errMsgUnauthorized', desc: '', args: [serial]);
  String get errNextUnauthorized => Intl.message('Unlock the phone screen and accept the "Allow USB debugging" RSA prompt.', name: 'errNextUnauthorized', desc: '', args: []);
  String get errTitleOffline => Intl.message('Device Offline', name: 'errTitleOffline', desc: '', args: []);
  String errMsgOffline(Object serial) => Intl.message('Device $serial is offline and unresponsive.', name: 'errMsgOffline', desc: '', args: [serial]);
  String get errNextOffline => Intl.message('Reconnect the USB cable or toggle USB debugging.', name: 'errNextOffline', desc: '', args: []);
  String get errTitleBootloaderLocked => Intl.message('Bootloader Locked', name: 'errTitleBootloaderLocked', desc: '', args: []);
  String get errMsgBootloaderLocked => Intl.message('Flashing a patched boot image requires an unlocked bootloader.', name: 'errMsgBootloaderLocked', desc: '', args: []);
  String get errNextBootloaderLocked => Intl.message('Unlock the bootloader first (note: unlocking wipes user data).', name: 'errNextBootloaderLocked', desc: '', args: []);
  String get errTitleFastbootdBlocked => Intl.message('Userspace Fastbootd Active', name: 'errTitleFastbootdBlocked', desc: '', args: []);
  String errMsgFastbootdBlocked(Object serial) => Intl.message('Device $serial is in userspace fastbootd mode; reboot to Bootloader Fastboot before flashing boot.', name: 'errMsgFastbootdBlocked', desc: '', args: [serial]);
  String warnKernelOutOfRange(Object kernel, Object range) => Intl.message('Kernel version $kernel may be outside the supported $range range for this KernelPatch release.', name: 'warnKernelOutOfRange', desc: '', args: [kernel, range]);
  String warnLowBattery(Object percent, Object minPercent) => Intl.message('Device battery is low ($percent%). Charge above $minPercent% before flashing.', name: 'warnLowBattery', desc: '', args: [percent, minPercent]);
  String get errTitlePreflightFailed => Intl.message('Preflight Check Failed', name: 'errTitlePreflightFailed', desc: '', args: []);
  String get errNextPreflightFailed => Intl.message('Resolve the reported issue and try again.', name: 'errNextPreflightFailed', desc: '', args: []);
  String get errTitlePatchFailed => Intl.message('Boot Image Patching Failed', name: 'errTitlePatchFailed', desc: '', args: []);
  String get errNextPatchFailed => Intl.message('Your device has not been modified. Verify your boot.img and KernelPatch version.', name: 'errNextPatchFailed', desc: '', args: []);
  String get errTitleFastbootTimeout => Intl.message('Fastboot Device Not Detected', name: 'errTitleFastbootTimeout', desc: '', args: []);
  String get errMsgFastbootTimeout => Intl.message('Timed out waiting for the device to appear in Fastboot mode.', name: 'errMsgFastbootTimeout', desc: '', args: []);
  String get errNextFastbootTimeout => Intl.message('Check USB cable, install Fastboot/Bootloader drivers if needed, and verify the device is in Bootloader mode (not Samsung Download/Odin mode).', name: 'errNextFastbootTimeout', desc: '', args: []);
  String get errTitleUnexpected => Intl.message('Unexpected Operation Error', name: 'errTitleUnexpected', desc: '', args: []);
  String get errNextUnexpected => Intl.message('Export diagnostics and inspect logs before retrying.', name: 'errNextUnexpected', desc: '', args: []);
  String get errTitleAdbPortConflict => Intl.message('ADB Server Port Conflict', name: 'errTitleAdbPortConflict', desc: '', args: []);
  String get errMsgAdbPortConflict => Intl.message('The ADB daemon could not start or bind to port 5037.', name: 'errMsgAdbPortConflict', desc: '', args: []);
  String get errNextAdbPortConflict => Intl.message('Close conflicting Android tools (phone suites or emulators) and retry.', name: 'errNextAdbPortConflict', desc: '', args: []);
  String get errTitleAdbTimeout => Intl.message('ADB Command Timed Out', name: 'errTitleAdbTimeout', desc: '', args: []);
  String get errMsgAdbTimeout => Intl.message('The device did not respond to the ADB command within the expected time.', name: 'errMsgAdbTimeout', desc: '', args: []);
  String get errTitleAdbFailed => Intl.message('ADB Command Failed', name: 'errTitleAdbFailed', desc: '', args: []);
  String get errMsgAdbFailed => Intl.message('An ADB command failed to complete.', name: 'errMsgAdbFailed', desc: '', args: []);
  String get errTitlePartitionNotFound => Intl.message('Target Partition Not Found', name: 'errTitlePartitionNotFound', desc: '', args: []);
  String get errMsgPartitionNotFound => Intl.message('Fastboot reported that the target partition does not exist on this device.', name: 'errMsgPartitionNotFound', desc: '', args: []);
  String get errTitleFastbootPermission => Intl.message('Insufficient Permissions / Driver Access', name: 'errTitleFastbootPermission', desc: '', args: []);
  String get errMsgFastbootPermission => Intl.message('Windows denied access to the Fastboot USB interface.', name: 'errMsgFastbootPermission', desc: '', args: []);
  String get errTitleFastbootTimeoutCmd => Intl.message('Fastboot Command Timed Out', name: 'errTitleFastbootTimeoutCmd', desc: '', args: []);
  String get errMsgFastbootTimeoutCmd => Intl.message('Fastboot did not respond in time.', name: 'errMsgFastbootTimeoutCmd', desc: '', args: []);
  String get errTitleFastbootFailed => Intl.message('Fastboot Command Failed', name: 'errTitleFastbootFailed', desc: '', args: []);

}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'zh')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}