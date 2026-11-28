// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(serial) => "ADB 设备离线 (${serial})";

  static String m1(version) => "Android ${version}";

  static String m2(version) => "FolkTool v${version}";

  static String m3(version, build) => "FolkTool v${version} (构建 ${build})";

  static String m4(percent) => "电量 ${percent}%";

  static String m5(pkg) => "包名: ${pkg}";

  static String m6(version) => "内置 ${version}";

  static String m7(path) => "Boot 镜像: ${path}";

  static String m8(version) => "KernelPatch 版本: ${version}";

  static String m9(target) => "修补目标: ${target}";

  static String m10(device) => "目标设备: ${device}";

  static String m11(count) => "已删除 ${count} 个磁盘日志文件";

  static String m12(path) => "诊断报告已保存: ${path}";

  static String m13(name) => "确认安装 ${name}？";

  static String m14(status) => "驱动安装程序已启动（签名状态: ${status}）。如有需要请重新插拔设备或重启电脑。";

  static String m15(publisher) => "发布者: ${publisher}";

  static String m16(modes) => "适用模式: ${modes}";

  static String m17(path) => "ADB 可执行文件不存在: ${path}";

  static String m18(path) => "APK 文件不存在: ${path}";

  static String m19(error) => "备份异常: ${error}";

  static String m20(error) => "检查应用安装状态失败: ${error}";

  static String m21(error) => "驱动检查失败: ${error}";

  static String m22(path) => "Fastboot 可执行文件不存在: ${path}";

  static String m23(error) => "刷入异常: ${error}";

  static String m24(error) => "刷入失败: ${error}";

  static String m25(error) => "获取 ADB 设备失败: ${error}";

  static String m26(error) => "获取 Fastboot 设备失败: ${error}";

  static String m27(path) => "输入文件不存在: ${path}";

  static String m28(error) => "管理器安装异常: ${error}";

  static String m29(error) => "管理器安装失败: ${error}";

  static String m30(path) => "Kpimg 文件不存在: ${path}";

  static String m31(path) => "Kptools 文件不存在: ${path}";

  static String m32(serial) => "设备 ${serial} 当前处于用户态 fastbootd，请重启进入 Bootloader Fastboot 后再刷写。";

  static String m33(path) => "所选 KPM 模块不存在或为空: ${path}";

  static String m34(tool) => "在预期目录中未找到内置工具 ${tool}。";

  static String m35(serial) => "设备 ${serial} 处于离线无响应状态。";

  static String m36(serial) => "设备 ${serial} 尚未授权本机的 USB 调试请求。";

  static String m37(error) => "修补异常: ${error}";

  static String m38(error) => "修补失败: ${error}";

  static String m39(error) => "重启异常: ${error}";

  static String m40(error) => "重启失败: ${error}";

  static String m41(tool) => "缺少内置依赖工具 (${tool})";

  static String m42(error) => "解包失败: ${error}";

  static String m43(stage) => "阶段: ${stage}";

  static String m44(reason) => "原因: ${reason}";

  static String m45(serial) => "处于用户态 Fastbootd (${serial})";

  static String m46(error) => "启动安装程序失败: ${error}";

  static String m47(msg) => "${msg} 如有需要请重新插拔设备或重启电脑。";

  static String m48(name) => "${name} 安装失败";

  static String m49(name) => "${name} 安装成功";

  static String m50(path) => "Boot 备份完成: ${path}";

  static String m51(path) => "备份成功: ${path}";

  static String m52(error) => "清理临时文件失败: ${error}";

  static String m53(path) => "已复制到 ${path}";

  static String m54(cmd) => "执行命令: ${cmd}";

  static String m55(serial) => "检测到 Fastboot 设备: ${serial}";

  static String m56(path) => "文件已保存: ${path}";

  static String m57(path) => "正在刷入: ${path}";

  static String m58(path) => "输入文件: ${path}";

  static String m59(path) => "正在安装管理器 APK: ${path}";

  static String m60(path) => "Kpimg 路径: ${path}";

  static String m61(module) => "KPM 模块: ${module}";

  static String m62(path) => "Kptools 路径: ${path}";

  static String m63(error) => "获取补丁信息失败: ${error}";

  static String m64(error) => "操作错误: ${error}";

  static String m65(path) => "输出文件: ${path}";

  static String m66(path) => "修补完成: ${path}";

  static String m67(error) => "修补异常: ${error}";

  static String m68(error) => "修补失败: ${error}";

  static String m69(error) => "重新打包异常: ${error}";

  static String m70(path, size) => "重新打包完成: ${path} (${size} MB)";

  static String m71(error) => "解包异常: ${error}";

  static String m72(path) => "已解包内核: ${path}";

  static String m73(timeout) => "等待 fastboot 设备 (${timeout} 秒)";

  static String m74(dir) => "工作目录: ${dir}";

  static String m75(path) => "日志已保存: ${path}";

  static String m76(version) => "发现新版本: ${version}";

  static String m77(count) => "已选择 (${count})";

  static String m78(serial) => "序列号: ${serial}";

  static String m79(appName, version) => "${appName} v${version} • 启用显式安全预检、驱动数字签名校验及标准 Windows 权限体系。";

  static String m80(error) => "无法打开三星官方驱动网页: ${error}";

  static String m81(error) => "无法打开链接: ${error}";

  static String m82(mode, serial) => "不受支持的 USB 模式 (${mode}): ${serial}";

  static String m83(serial) => "USB 调试未授权 (${serial})";

  static String m84(version) => "所选版本 (${version}) 较旧，不支持内置 kptools 解包或缺乏新版 GKI 6.x 内核修复；除非专门兼容旧内核，否则建议选用 0.13.8 或 0.13.9。";

  static String m85(kernel, range) => "设备内核版本 ${kernel} 可能超出当前 KernelPatch 测试兼容范围 (${range})。";

  static String m86(percent, minPercent) => "设备电量较低 (${percent}%)，建议充电至 ${minPercent}% 以上后再刷入。";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "aboutDescription": MessageLookupByLibrary.simpleMessage("Android Boot 镜像修补与 KernelPatch 自动刷入工具"),
    "aboutDescription2": MessageLookupByLibrary.simpleMessage("本工具用于在 Windows 桌面端通过 Bootloader Fastboot 安全修补并刷入 boot.img"),
    "aboutTitle": MessageLookupByLibrary.simpleMessage("关于"),
    "aboutTooltip": MessageLookupByLibrary.simpleMessage("关于"),
    "adbConnected": MessageLookupByLibrary.simpleMessage("ADB 已连接"),
    "adbOfflineDesc": MessageLookupByLibrary.simpleMessage("请重新插拔数据线、尝试主板直连 USB 接口，或重启手机的 USB 调试开关。"),
    "adbOfflineTitle": m0,
    "androidVersionLabel": m1,
    "apatchDesc": MessageLookupByLibrary.simpleMessage("Android 内核级 Root 解决方案"),
    "apatchSubtitle": MessageLookupByLibrary.simpleMessage("bmax121 官方原版"),
    "appFullName": MessageLookupByLibrary.simpleMessage("FolkTool - KernelPatch 自动刷入工具"),
    "appName": MessageLookupByLibrary.simpleMessage("FolkTool"),
    "appVersion": m2,
    "appVersionWithBuild": m3,
    "backupWarning": MessageLookupByLibrary.simpleMessage("刷入前请先备份原始 boot 分区"),
    "batteryLevelLabel": m4,
    "bootloaderLockedLabel": MessageLookupByLibrary.simpleMessage("Bootloader 未解锁"),
    "bootloaderUnlockedLabel": MessageLookupByLibrary.simpleMessage("Bootloader 已解锁"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelOperation": MessageLookupByLibrary.simpleMessage("取消操作"),
    "catalogNotesApatch11142": MessageLookupByLibrary.simpleMessage("bmax121 历史版本 APatch (11142)，搭载 KernelPatch 0.12.2，仅面向老版本内核 (3.18 - 6.6)。"),
    "catalogNotesApatch11224": MessageLookupByLibrary.simpleMessage("bmax121 官方 APatch (11224)，搭载 KernelPatch 0.13.3 稳定基线。"),
    "catalogNotesApatch11282": MessageLookupByLibrary.simpleMessage("bmax121 官方最新 APatch (11282)，内置 KernelPatch 0.13.9 并适配最新系统内核。"),
    "catalogNotesFolkpatch0138": MessageLookupByLibrary.simpleMessage("FolkPatch v5.0 (115032)，搭载 KernelPatch 0.13.8，兼顾老内核兼容及 Android 16。"),
    "catalogNotesFolkpatch115357": MessageLookupByLibrary.simpleMessage("FolkPatch 管理器 (115357)，搭载 KernelPatch 0.13.9 并修复了模块 WebUI 的 shell 泄漏问题。"),
    "catalogNotesFolkpatch115404": MessageLookupByLibrary.simpleMessage("最新 FolkPatch 管理器 (115404)，内置 KernelPatch 0.13.9、BTF 支持、热补丁修复与镜像大小适配优化。"),
    "checkDeviceStateBadge": MessageLookupByLibrary.simpleMessage("请检查设备状态"),
    "checking": MessageLookupByLibrary.simpleMessage("检测中..."),
    "checkingDriver": MessageLookupByLibrary.simpleMessage("工具链检测中"),
    "checkingDriverDesc": MessageLookupByLibrary.simpleMessage("正在检查 ADB/Fastboot 工具..."),
    "clear": MessageLookupByLibrary.simpleMessage("清除"),
    "clearAll": MessageLookupByLibrary.simpleMessage("清空全部"),
    "clearAllModules": MessageLookupByLibrary.simpleMessage("清空全部"),
    "clearList": MessageLookupByLibrary.simpleMessage("清空列表"),
    "clearLogs": MessageLookupByLibrary.simpleMessage("清除日志"),
    "clearLogsDialogBody": MessageLookupByLibrary.simpleMessage("这将清空当前会话中显示的全部操作日志记录。"),
    "clearLogsDialogTitle": MessageLookupByLibrary.simpleMessage("清除日志？"),
    "clearRecentFilesDesc": MessageLookupByLibrary.simpleMessage("这仅会清除最近使用列表中的记录，不会删除磁盘上的实际镜像文件。"),
    "clearRecentFilesTitle": MessageLookupByLibrary.simpleMessage("清空最近文件？"),
    "clearSessionLogsConfirmBody": MessageLookupByLibrary.simpleMessage("当前内存中的全部日志记录将被清空。"),
    "clickToSelectFile": MessageLookupByLibrary.simpleMessage("点击选择文件..."),
    "clientCheck": MessageLookupByLibrary.simpleMessage("客户端检测"),
    "clientPackageLabel": m5,
    "clientVersionBadge": m6,
    "confirmBootImage": m7,
    "confirmKpVersion": m8,
    "confirmPatchTarget": m9,
    "confirmQuickFlashBody": MessageLookupByLibrary.simpleMessage("即将开始修补 boot 镜像、重启设备至 Bootloader Fastboot 并写入 boot 分区。请确认 Bootloader 已解锁且全程切勿断开数据线。"),
    "confirmQuickFlashTitle": MessageLookupByLibrary.simpleMessage("确认一键刷入"),
    "confirmTargetDevice": m10,
    "connectFastbootToRestore": MessageLookupByLibrary.simpleMessage("请先将设备连接至 Fastboot 模式后再恢复原厂 Boot。"),
    "copyDetails": MessageLookupByLibrary.simpleMessage("复制详情"),
    "copyLogs": MessageLookupByLibrary.simpleMessage("复制日志"),
    "currentVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
    "customVersion": MessageLookupByLibrary.simpleMessage("自定义版本"),
    "customVersionSaved": MessageLookupByLibrary.simpleMessage("自定义版本已保存"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "deleteDiskLogsConfirmBody": MessageLookupByLibrary.simpleMessage("FolkTool/logs 中的全部历史日志文件将被永久删除，您的 Boot 镜像和备份不受任何影响。"),
    "deleteDiskLogsConfirmTitle": MessageLookupByLibrary.simpleMessage("删除已保存的日志文件？"),
    "deleteLogsButton": MessageLookupByLibrary.simpleMessage("删除日志"),
    "deletedSavedLogsCount": m11,
    "deviceConnectionTips": MessageLookupByLibrary.simpleMessage("设备连接提示"),
    "deviceConnectionTipsDesc": MessageLookupByLibrary.simpleMessage("1. 正常开机状态 (ADB)：请在设备上开启「开发者选项」和「USB 调试」，并解锁屏幕点击「允许 USB 调试」。\n2. 刷入状态 (Bootloader Fastboot)：请通过系统重启到 Bootloader 或按 音量下 + 电源键进入。注意：三星 Download 模式 (Odin) 并非 Fastboot。"),
    "deviceErrorTitle": MessageLookupByLibrary.simpleMessage("设备状态检测失败"),
    "deviceInFastboot": MessageLookupByLibrary.simpleMessage("设备已进入 Fastboot"),
    "deviceSafeBadge": MessageLookupByLibrary.simpleMessage("设备安全"),
    "deviceStateAdb": MessageLookupByLibrary.simpleMessage("ADB"),
    "deviceStateDisconnected": MessageLookupByLibrary.simpleMessage("未连接"),
    "deviceStateError": MessageLookupByLibrary.simpleMessage("检测出错"),
    "deviceStateFastboot": MessageLookupByLibrary.simpleMessage("Fastboot (Bootloader)"),
    "deviceStateFastbootd": MessageLookupByLibrary.simpleMessage("Fastbootd (用户态)"),
    "deviceStateMultiple": MessageLookupByLibrary.simpleMessage("多设备"),
    "deviceStateOffline": MessageLookupByLibrary.simpleMessage("离线"),
    "deviceStateRecovery": MessageLookupByLibrary.simpleMessage("恢复模式"),
    "deviceStateSideload": MessageLookupByLibrary.simpleMessage("线刷 Sideload"),
    "deviceStateUnauthorized": MessageLookupByLibrary.simpleMessage("未授权"),
    "deviceStateUnsupported": MessageLookupByLibrary.simpleMessage("不支持的模式"),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("设备状态"),
    "diagnosticsSaved": m12,
    "dismiss": MessageLookupByLibrary.simpleMessage("忽略"),
    "download": MessageLookupByLibrary.simpleMessage("下载"),
    "downloadOfficialSamsungDriver": MessageLookupByLibrary.simpleMessage("前往下载三星官方 USB 驱动"),
    "driverHelpGuide": MessageLookupByLibrary.simpleMessage("• ADB 驱动：在 Android 开机并启用 USB 调试时使用。\n• Fastboot 驱动：在 Bootloader 模式下使用。若设备管理器出现带黄色叹号的“Android”设备，可打开 Windows 更新 -> 可选更新 -> 驱动程序更新 安装“Android Bootloader Interface”。\n• 管理员权限：驱动安装需经过 Authenticode 数字签名验证并取得 Windows UAC 确认。"),
    "driverInstall": MessageLookupByLibrary.simpleMessage("驱动安装"),
    "driverInstallConfirmTitle": m13,
    "driverInstallPage": MessageLookupByLibrary.simpleMessage("驱动安装"),
    "driverInstallSubtitle": MessageLookupByLibrary.simpleMessage("安装设备驱动程序"),
    "driverLaunchedResult": m14,
    "driverPublisherLabel": m15,
    "driverSignatureNotice": MessageLookupByLibrary.simpleMessage("FolkTool 将首先校验安装包的数字签名，随后请求 Windows 管理员权限 (UAC) 启动驱动安装程序。"),
    "driverSupportedModesLabel": m16,
    "errAdbNotAvailable": MessageLookupByLibrary.simpleMessage("ADB 不可用"),
    "errAdbNotExist": m17,
    "errApkNotFound": m18,
    "errBackupException": m19,
    "errCatAdb": MessageLookupByLibrary.simpleMessage("ADB"),
    "errCatApplication": MessageLookupByLibrary.simpleMessage("应用"),
    "errCatCompatibility": MessageLookupByLibrary.simpleMessage("兼容性"),
    "errCatDeviceConnection": MessageLookupByLibrary.simpleMessage("设备连接"),
    "errCatDownload": MessageLookupByLibrary.simpleMessage("下载"),
    "errCatDriver": MessageLookupByLibrary.simpleMessage("驱动"),
    "errCatExtraction": MessageLookupByLibrary.simpleMessage("解包"),
    "errCatFastboot": MessageLookupByLibrary.simpleMessage("Fastboot"),
    "errCatFile": MessageLookupByLibrary.simpleMessage("文件"),
    "errCatFlashing": MessageLookupByLibrary.simpleMessage("刷入"),
    "errCatImageValidation": MessageLookupByLibrary.simpleMessage("镜像校验"),
    "errCatNetwork": MessageLookupByLibrary.simpleMessage("网络"),
    "errCatPermission": MessageLookupByLibrary.simpleMessage("权限"),
    "errCatProcess": MessageLookupByLibrary.simpleMessage("进程"),
    "errCheckClientFailed": m20,
    "errDriverCheckFailed": m21,
    "errFastbootNotAvailable": MessageLookupByLibrary.simpleMessage("Fastboot 不可用"),
    "errFastbootNotExist": m22,
    "errFlashBootFailed": MessageLookupByLibrary.simpleMessage("刷入 boot 分区失败"),
    "errFlashException": m23,
    "errFlashFailed": m24,
    "errGetAdbFailed": m25,
    "errGetFastbootFailed": m26,
    "errInputNotExist": m27,
    "errInstallApkException": m28,
    "errInstallApkFailed": m29,
    "errKernelNotFound": MessageLookupByLibrary.simpleMessage("未找到内核文件"),
    "errKpimgNotExist": m30,
    "errKptoolsNotExist": m31,
    "errMsgAdbFailed": MessageLookupByLibrary.simpleMessage("ADB 命令未能成功完成。"),
    "errMsgAdbPortConflict": MessageLookupByLibrary.simpleMessage("ADB 守护进程无法启动或绑定 5037 端口。"),
    "errMsgAdbTimeout": MessageLookupByLibrary.simpleMessage("设备未在规定时间内响应 ADB 指令。"),
    "errMsgBootNotFound": MessageLookupByLibrary.simpleMessage("所选 boot.img 文件已不存在或被移动。"),
    "errMsgBootloaderLocked": MessageLookupByLibrary.simpleMessage("刷入修补后的 boot 镜像必须先解锁设备 Bootloader。"),
    "errMsgCannotReadBoot": MessageLookupByLibrary.simpleMessage("无法读取所选 boot.img，请检查文件访问权限或关闭占用该文件的软件。"),
    "errMsgEmptyBoot": MessageLookupByLibrary.simpleMessage("所选 boot.img 文件大小为 0 字节。"),
    "errMsgFastbootPermission": MessageLookupByLibrary.simpleMessage("Windows 拒绝访问当前 Fastboot USB 接口。"),
    "errMsgFastbootTimeout": MessageLookupByLibrary.simpleMessage("未能检测到进入 Fastboot 模式的设备。"),
    "errMsgFastbootTimeoutCmd": MessageLookupByLibrary.simpleMessage("设备在 Fastboot 模式下超时无响应。"),
    "errMsgFastbootdBlocked": m32,
    "errMsgInvalidKpm": m33,
    "errMsgMissingKpimg": MessageLookupByLibrary.simpleMessage("所选 KernelPatch (kpimg) 文件不存在或为空。"),
    "errMsgMissingTool": m34,
    "errMsgMultipleDevices": MessageLookupByLibrary.simpleMessage("当前电脑同时连接了多台 Android 设备或模拟器。"),
    "errMsgNoDevice": MessageLookupByLibrary.simpleMessage("在 ADB 和 Fastboot 模式下均未检测到可用设备。"),
    "errMsgOffline": m35,
    "errMsgPartitionNotFound": MessageLookupByLibrary.simpleMessage("Fastboot 返回目标分区不存在。"),
    "errMsgUnauthorized": m36,
    "errNextAdbPortConflict": MessageLookupByLibrary.simpleMessage("请关闭占用 5037 端口的手机助手或安卓模拟器后重试。"),
    "errNextBootloaderLocked": MessageLookupByLibrary.simpleMessage("请先解锁 Bootloader（注意：解锁操作通常会清空设备用户数据）。"),
    "errNextCannotReadBoot": MessageLookupByLibrary.simpleMessage("请确认文件读权限或将镜像复制到普通本地目录后再试。"),
    "errNextEmptyBoot": MessageLookupByLibrary.simpleMessage("请提供有效的非空原厂 boot.img 文件。"),
    "errNextFastbootTimeout": MessageLookupByLibrary.simpleMessage("请检查数据线与驱动状态，并确认手机屏幕位于 Bootloader Fastboot 界面（并非三星 Download/Odin 模式）。"),
    "errNextInvalidKpm": MessageLookupByLibrary.simpleMessage("请移除缺失的模块或重新选择有效的 .kpm 文件。"),
    "errNextMissingKpimg": MessageLookupByLibrary.simpleMessage("请重新选择有效的内置版本或自定义 kpimg 文件。"),
    "errNextMissingTool": MessageLookupByLibrary.simpleMessage("请重新安装或修复 FolkTool，或恢复 bin/ 与 kp_versions/ 目录。"),
    "errNextMultipleDevices": MessageLookupByLibrary.simpleMessage("请断开多余设备或仅保留一台设备并在“设备状态”中选定目标。"),
    "errNextNoDevice": MessageLookupByLibrary.simpleMessage("请通过 USB 连接手机并开启 USB 调试，或手动进入 Bootloader Fastboot 模式。"),
    "errNextOffline": MessageLookupByLibrary.simpleMessage("请重插数据线或在手机上重新开关 USB 调试。"),
    "errNextPatchFailed": MessageLookupByLibrary.simpleMessage("尚未向手机写入任何内容。请核对所选 boot.img 与 KernelPatch 版本是否匹配。"),
    "errNextPreflightFailed": MessageLookupByLibrary.simpleMessage("请先解决上述问题后再试。"),
    "errNextSelectBoot": MessageLookupByLibrary.simpleMessage("请先选择一个有效的 boot.img 文件。"),
    "errNextUnauthorized": MessageLookupByLibrary.simpleMessage("请解锁手机屏幕并点击“允许 USB 调试”。"),
    "errNextUnexpected": MessageLookupByLibrary.simpleMessage("请导出诊断报告并查看完整日志后再重试。"),
    "errOutputKernelNotFound": MessageLookupByLibrary.simpleMessage("未找到输出内核"),
    "errPatchException": m37,
    "errPatchFailed": m38,
    "errRebootException": m39,
    "errRebootFailed": m40,
    "errRepackFailed": MessageLookupByLibrary.simpleMessage("重新打包失败"),
    "errSelectBootFirst": MessageLookupByLibrary.simpleMessage("请先选择 boot.img 文件"),
    "errTitleAdbFailed": MessageLookupByLibrary.simpleMessage("ADB 命令执行失败"),
    "errTitleAdbPortConflict": MessageLookupByLibrary.simpleMessage("ADB 服务端口被占用"),
    "errTitleAdbTimeout": MessageLookupByLibrary.simpleMessage("ADB 命令超时"),
    "errTitleBootNotFound": MessageLookupByLibrary.simpleMessage("Boot 镜像不存在"),
    "errTitleBootloaderLocked": MessageLookupByLibrary.simpleMessage("Bootloader 未解锁"),
    "errTitleCannotReadBoot": MessageLookupByLibrary.simpleMessage("无法读取 Boot 镜像"),
    "errTitleEmptyBoot": MessageLookupByLibrary.simpleMessage("Boot 镜像为空文件"),
    "errTitleFastbootFailed": MessageLookupByLibrary.simpleMessage("Fastboot 命令失败"),
    "errTitleFastbootPermission": MessageLookupByLibrary.simpleMessage("Fastboot 驱动或接口权限不足"),
    "errTitleFastbootTimeout": MessageLookupByLibrary.simpleMessage("等待 Fastboot 设备超时"),
    "errTitleFastbootTimeoutCmd": MessageLookupByLibrary.simpleMessage("Fastboot 命令超时"),
    "errTitleFastbootdBlocked": MessageLookupByLibrary.simpleMessage("设备处于用户态 Fastbootd"),
    "errTitleInvalidKpm": MessageLookupByLibrary.simpleMessage("KPM 模块无效"),
    "errTitleMissingKpimg": MessageLookupByLibrary.simpleMessage("缺少 KernelPatch 内核文件 (kpimg)"),
    "errTitleMissingTool": m41,
    "errTitleMultipleDevices": MessageLookupByLibrary.simpleMessage("检测到多台设备"),
    "errTitleNoBootSelected": MessageLookupByLibrary.simpleMessage("未选择 Boot 镜像"),
    "errTitleNoDevice": MessageLookupByLibrary.simpleMessage("未连接设备"),
    "errTitleOffline": MessageLookupByLibrary.simpleMessage("设备已离线"),
    "errTitlePartitionNotFound": MessageLookupByLibrary.simpleMessage("未找到目标分区"),
    "errTitlePatchFailed": MessageLookupByLibrary.simpleMessage("Boot 镜像修补失败"),
    "errTitlePreflightFailed": MessageLookupByLibrary.simpleMessage("预检未通过"),
    "errTitleUnauthorized": MessageLookupByLibrary.simpleMessage("设备 USB 调试未授权"),
    "errTitleUnexpected": MessageLookupByLibrary.simpleMessage("操作发生意外异常"),
    "errUnpackFailed": m42,
    "errorDetailsCopied": MessageLookupByLibrary.simpleMessage("错误详情已复制到剪贴板"),
    "errorStage": m43,
    "errorWhy": m44,
    "exportDiagnostics": MessageLookupByLibrary.simpleMessage("导出诊断报告"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("导出日志"),
    "exportLogsTooltip": MessageLookupByLibrary.simpleMessage("导出日志"),
    "fastbootConnected": MessageLookupByLibrary.simpleMessage("Fastboot 已连接"),
    "fastbootdDetectedDesc": MessageLookupByLibrary.simpleMessage("写入 boot 分区需要 Bootloader 层的 Fastboot 模式而非用户态 fastbootd，请先重启到 Bootloader。"),
    "fastbootdDetectedTitle": m45,
    "fileMissingBadge": MessageLookupByLibrary.simpleMessage("已缺失"),
    "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage("文件已保存"),
    "filterAll": MessageLookupByLibrary.simpleMessage("全部"),
    "filterErr": MessageLookupByLibrary.simpleMessage("错误"),
    "filterInfo": MessageLookupByLibrary.simpleMessage("信息"),
    "filterLogsHint": MessageLookupByLibrary.simpleMessage("搜索过滤日志..."),
    "filterOk": MessageLookupByLibrary.simpleMessage("成功"),
    "filterWarn": MessageLookupByLibrary.simpleMessage("警告"),
    "flashBoot": MessageLookupByLibrary.simpleMessage("刷入 boot"),
    "flashComplete": MessageLookupByLibrary.simpleMessage("刷入完成"),
    "flashCompleteDesc": MessageLookupByLibrary.simpleMessage("是否立即重启设备？"),
    "flashFile": MessageLookupByLibrary.simpleMessage("刷入文件"),
    "flashSuccess": MessageLookupByLibrary.simpleMessage("刷入成功！"),
    "flashing": MessageLookupByLibrary.simpleMessage("刷入中..."),
    "folderBackupsButton": MessageLookupByLibrary.simpleMessage("备份"),
    "folderLogsButton": MessageLookupByLibrary.simpleMessage("日志"),
    "folkpatchDesc": MessageLookupByLibrary.simpleMessage("一个优秀的KernelPatch管理客户端"),
    "folkpatchSubtitle": MessageLookupByLibrary.simpleMessage("LyraVoid 分支 • 增强版内核支持"),
    "github": MessageLookupByLibrary.simpleMessage("GitHub"),
    "home": MessageLookupByLibrary.simpleMessage("首页"),
    "install": MessageLookupByLibrary.simpleMessage("安装"),
    "installDriver": MessageLookupByLibrary.simpleMessage("安装驱动"),
    "installDriverFailed": m46,
    "installDriverSuccess": MessageLookupByLibrary.simpleMessage("驱动安装程序已启动"),
    "installDriverSuccessReconnect": m47,
    "installFailed": m48,
    "installSuccess": m49,
    "installed": MessageLookupByLibrary.simpleMessage("已安装"),
    "installing": MessageLookupByLibrary.simpleMessage("安装中..."),
    "invalidVersionFile": MessageLookupByLibrary.simpleMessage("无效的版本文件"),
    "kernelPatchVersion": MessageLookupByLibrary.simpleMessage("KernelPatch 版本"),
    "kpmModules": MessageLookupByLibrary.simpleMessage("KPM 模块 (可选)"),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "loadingVersions": MessageLookupByLibrary.simpleMessage("加载版本中..."),
    "logAutoRebootFailed": MessageLookupByLibrary.simpleMessage("自动重启到 fastboot 失败"),
    "logAutoRebootFailed2": MessageLookupByLibrary.simpleMessage("自动重启失败"),
    "logBackingUpBoot": MessageLookupByLibrary.simpleMessage("正在备份 boot 分区..."),
    "logBackingUpPartition": MessageLookupByLibrary.simpleMessage("正在备份分区..."),
    "logBackupComplete": m50,
    "logBackupFailed": MessageLookupByLibrary.simpleMessage("Boot 备份失败"),
    "logBackupFailedTryAlt": MessageLookupByLibrary.simpleMessage("备份失败，尝试备用方法..."),
    "logBackupKernel": MessageLookupByLibrary.simpleMessage("正在备份内核..."),
    "logBackupSuccess": m51,
    "logCancelling": MessageLookupByLibrary.simpleMessage("正在取消操作..."),
    "logCheckAdb": MessageLookupByLibrary.simpleMessage("正在检查 ADB..."),
    "logCheckFastboot": MessageLookupByLibrary.simpleMessage("正在检查 Fastboot..."),
    "logCheckingClient": MessageLookupByLibrary.simpleMessage("正在检测已安装的管理器应用..."),
    "logCheckingFile": MessageLookupByLibrary.simpleMessage("正在检查文件..."),
    "logCleanWorkDir": MessageLookupByLibrary.simpleMessage("正在清理临时文件..."),
    "logCleanWorkDirFailed": m52,
    "logConsole": MessageLookupByLibrary.simpleMessage("日志控制台"),
    "logCopied": m53,
    "logCopyBoot": MessageLookupByLibrary.simpleMessage("正在复制 boot 镜像..."),
    "logDeviceInFastboot": MessageLookupByLibrary.simpleMessage("设备已进入 fastboot 模式"),
    "logDeviceNotFastboot": MessageLookupByLibrary.simpleMessage("设备未处于 fastboot 模式"),
    "logDeviceRebooting": MessageLookupByLibrary.simpleMessage("设备正在重启..."),
    "logDriverCheckPassed": MessageLookupByLibrary.simpleMessage("驱动检查通过"),
    "logEntries": MessageLookupByLibrary.simpleMessage("条记录"),
    "logExecuteCmd": m54,
    "logFastbootDetected": m55,
    "logFileSaved": m56,
    "logFlashBootSuccess": MessageLookupByLibrary.simpleMessage("刷入完成"),
    "logFlashFailed": MessageLookupByLibrary.simpleMessage("刷入失败"),
    "logFlashSuccess": MessageLookupByLibrary.simpleMessage("刷入成功"),
    "logFlashingBoot": MessageLookupByLibrary.simpleMessage("正在刷入 boot 镜像..."),
    "logFlashingBootPath": m57,
    "logInputFile": m58,
    "logInstallApkSuccess": MessageLookupByLibrary.simpleMessage("管理器安装成功"),
    "logInstallingApk": m59,
    "logKpimgPath": m60,
    "logKpmModule": m61,
    "logKptoolsPath": m62,
    "logListPatchInfoFailed": m63,
    "logNoAdbDevice": MessageLookupByLibrary.simpleMessage("未检测到 ADB 设备"),
    "logOneClickComplete": MessageLookupByLibrary.simpleMessage("一键刷入完成！"),
    "logOperationError": m64,
    "logOutput": MessageLookupByLibrary.simpleMessage("日志输出"),
    "logOutputFile": m65,
    "logPatchComplete": m66,
    "logPatchException": m67,
    "logPatchFailed": m68,
    "logPatchSuccess": MessageLookupByLibrary.simpleMessage("内核修补成功"),
    "logPatchingBoot": MessageLookupByLibrary.simpleMessage("正在修补 boot 镜像..."),
    "logPatchingKernel": MessageLookupByLibrary.simpleMessage("正在修补内核..."),
    "logRebootCmdSent": MessageLookupByLibrary.simpleMessage("重启命令已发送"),
    "logRebootSuccess": MessageLookupByLibrary.simpleMessage("设备重启成功"),
    "logRebootingDevice": MessageLookupByLibrary.simpleMessage("正在重启设备..."),
    "logRebootingToFastboot": MessageLookupByLibrary.simpleMessage("正在重启到 fastboot 模式..."),
    "logRepackException": m69,
    "logRepackSuccess": m70,
    "logRepacking": MessageLookupByLibrary.simpleMessage("正在重新打包 boot 镜像..."),
    "logSavingFile": MessageLookupByLibrary.simpleMessage("正在保存修补文件..."),
    "logStartPatching": MessageLookupByLibrary.simpleMessage("开始修补操作..."),
    "logUnpackException": m71,
    "logUnpackSuccess": m72,
    "logUnpacking": MessageLookupByLibrary.simpleMessage("正在解包 boot 镜像..."),
    "logWaitFastboot": m73,
    "logWaitFastbootTimeout": MessageLookupByLibrary.simpleMessage("等待 fastboot 超时"),
    "logWorkDir": m74,
    "logsCopied": MessageLookupByLibrary.simpleMessage("日志已复制到剪贴板"),
    "logsSaved": m75,
    "manuallyEnterFastboot": MessageLookupByLibrary.simpleMessage("请手动进入 Bootloader Fastboot 模式"),
    "manuallyEnterFastbootDesc": MessageLookupByLibrary.simpleMessage("1. 将设备完全关机。\n2. 按住设备 Bootloader 组合键（通常为 音量下键 + 电源键）直至屏幕显示 Fastboot/Bootloader。\n3. 通过 USB 连接电脑（三星 Download/Odin 模式不支持 Fastboot）。"),
    "matsuzakaYuki": MessageLookupByLibrary.simpleMessage("Matsuzaka Yuki"),
    "mediatekDriver": MessageLookupByLibrary.simpleMessage("联发科 USB 驱动"),
    "mediatekDriverDesc": MessageLookupByLibrary.simpleMessage("适用于联发科芯片设备的 USB 驱动程序"),
    "multipleDevicesDesc": MessageLookupByLibrary.simpleMessage("请在下方选择唯一目标设备，或拔除多余设备/关闭模拟器后再试。"),
    "multipleDevicesTitle": MessageLookupByLibrary.simpleMessage("检测到多个设备"),
    "navDashboard": MessageLookupByLibrary.simpleMessage("概览"),
    "navDriversShort": MessageLookupByLibrary.simpleMessage("驱动"),
    "navLocalShort": MessageLookupByLibrary.simpleMessage("本地"),
    "navMore": MessageLookupByLibrary.simpleMessage("更多"),
    "navQuickShort": MessageLookupByLibrary.simpleMessage("一键"),
    "navSettings": MessageLookupByLibrary.simpleMessage("设置"),
    "navStepShort": MessageLookupByLibrary.simpleMessage("分步"),
    "newVersionAvailable": m76,
    "nextStep": MessageLookupByLibrary.simpleMessage("下一步"),
    "noDeviceDetected": MessageLookupByLibrary.simpleMessage("未检测到设备"),
    "noDeviceDetectedDesc": MessageLookupByLibrary.simpleMessage("请确保设备已连接并开启 USB 调试"),
    "noFastbootDevice": MessageLookupByLibrary.simpleMessage("未检测到 Fastboot 设备"),
    "noKpmModules": MessageLookupByLibrary.simpleMessage("未选择模块"),
    "noLogs": MessageLookupByLibrary.simpleMessage("暂无日志"),
    "noSavedLogsToDelete": MessageLookupByLibrary.simpleMessage("暂无可删除的磁盘日志文件"),
    "noVersionSelected": MessageLookupByLibrary.simpleMessage("未选择版本"),
    "noVersionsAvailable": MessageLookupByLibrary.simpleMessage("没有可用的版本"),
    "noneDetected": MessageLookupByLibrary.simpleMessage("暂未检测到"),
    "oneClickFlash": MessageLookupByLibrary.simpleMessage("一键刷入"),
    "oneplusAdbDriver": MessageLookupByLibrary.simpleMessage("一加官方 ADB 驱动"),
    "oneplusAdbDriverDesc": MessageLookupByLibrary.simpleMessage("一加官方 ADB 驱动程序，适用于 Windows 7 系统"),
    "openFileLocation": MessageLookupByLibrary.simpleMessage("打开文件所在位置"),
    "operationFailed": MessageLookupByLibrary.simpleMessage("操作失败"),
    "operationInProgressNavBlocked": MessageLookupByLibrary.simpleMessage("当前操作正在运行，请等待完成或取消后再切换页面。"),
    "operationProgress": MessageLookupByLibrary.simpleMessage("操作进度"),
    "oppoAdbDriver": MessageLookupByLibrary.simpleMessage("OPPO 官方 ADB 驱动"),
    "oppoAdbDriverDesc": MessageLookupByLibrary.simpleMessage("OPPO 官方 USB 驱动程序，适用于 Windows 10 及以上系统"),
    "patchOnlyComplete": MessageLookupByLibrary.simpleMessage("修补完成！"),
    "patchTarget": MessageLookupByLibrary.simpleMessage("修补目标"),
    "patchTargetDesc": MessageLookupByLibrary.simpleMessage("选择修补目标以使用对应的 KernelPatch 版本"),
    "patchedFile": MessageLookupByLibrary.simpleMessage("修补文件"),
    "patching": MessageLookupByLibrary.simpleMessage("修补中..."),
    "pleaseSelectFile": MessageLookupByLibrary.simpleMessage("请先选择 boot.img 文件"),
    "preflightActionRequired": MessageLookupByLibrary.simpleMessage("需完成前置准备"),
    "preflightReady": MessageLookupByLibrary.simpleMessage("安全预检通过"),
    "previousStep": MessageLookupByLibrary.simpleMessage("上一步"),
    "qualcommDriver32": MessageLookupByLibrary.simpleMessage("高通 Fastboot 驱动 (32位)"),
    "qualcommDriver32Desc": MessageLookupByLibrary.simpleMessage("适用于 32 位 Windows 系统的高通设备驱动"),
    "qualcommDriver64": MessageLookupByLibrary.simpleMessage("高通 Fastboot 驱动 (64位)"),
    "qualcommDriver64Desc": MessageLookupByLibrary.simpleMessage("适用于 64 位 Windows 系统的高通设备驱动"),
    "quickPatch": MessageLookupByLibrary.simpleMessage("一键刷入"),
    "quickPatchComplete": MessageLookupByLibrary.simpleMessage("一键刷入完成！"),
    "quickPatchSubtitle": MessageLookupByLibrary.simpleMessage("自动完成修补、重启与刷入流程"),
    "rebootLater": MessageLookupByLibrary.simpleMessage("稍后重启"),
    "rebootNow": MessageLookupByLibrary.simpleMessage("立即重启"),
    "rebootToFastboot": MessageLookupByLibrary.simpleMessage("重启到 Fastboot"),
    "recentFileMissingHint": MessageLookupByLibrary.simpleMessage("该文件在磁盘上已不存在，您可以从列表中移除它。"),
    "recentFiles": MessageLookupByLibrary.simpleMessage("最近使用"),
    "recentFilesCleared": MessageLookupByLibrary.simpleMessage("已清空最近文件历史"),
    "recheck": MessageLookupByLibrary.simpleMessage("重新检测"),
    "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "removeFromList": MessageLookupByLibrary.simpleMessage("从列表移除"),
    "removeModule": MessageLookupByLibrary.simpleMessage("移除"),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetAllSettingsConfirmBody": MessageLookupByLibrary.simpleMessage("确认将所有安全选项、监控开关与诊断设置恢复为默认值？"),
    "resetAllSettingsConfirmTitle": MessageLookupByLibrary.simpleMessage("恢复全部默认设置？"),
    "restart": MessageLookupByLibrary.simpleMessage("重新开始"),
    "restoreStockBootButton": MessageLookupByLibrary.simpleMessage("恢复原厂 Boot"),
    "restoreStockBootFailed": MessageLookupByLibrary.simpleMessage("原厂 Boot 镜像恢复失败。"),
    "restoreStockBootSuccess": MessageLookupByLibrary.simpleMessage("原厂 Boot 镜像已恢复。"),
    "retry": MessageLookupByLibrary.simpleMessage("重试"),
    "samsungDriverDesc": MessageLookupByLibrary.simpleMessage("三星官方发布的 Galaxy 手机/平板 USB 驱动，将直接跳转三星开发者官网下载，便于您验证三星官方签名后以管理员身份运行安装。"),
    "samsungDriverModes": MessageLookupByLibrary.simpleMessage("ADB / MTP / 三星 Download 模式"),
    "samsungDriverName": MessageLookupByLibrary.simpleMessage("三星官方 Android USB 驱动"),
    "saveAs": MessageLookupByLibrary.simpleMessage("另存为"),
    "savePatchedFile": MessageLookupByLibrary.simpleMessage("保存修补文件"),
    "saveToFile": MessageLookupByLibrary.simpleMessage("保存到文件"),
    "scanning": MessageLookupByLibrary.simpleMessage("正在扫描设备连接"),
    "selectBootImage": MessageLookupByLibrary.simpleMessage("选择 boot.img 文件"),
    "selectCustomVersion": MessageLookupByLibrary.simpleMessage("选择自定义 kpimg 文件"),
    "selectKpmModules": MessageLookupByLibrary.simpleMessage("选择 KPM 模块..."),
    "selectMode": MessageLookupByLibrary.simpleMessage("选择操作模式"),
    "selectSaveLocation": MessageLookupByLibrary.simpleMessage("选择保存位置"),
    "selectVersion": MessageLookupByLibrary.simpleMessage("选择版本"),
    "selectVersionDesc": MessageLookupByLibrary.simpleMessage("选择要使用的 KernelPatch 版本"),
    "selectedModules": m77,
    "serial": m78,
    "sessionLogsCleared": MessageLookupByLibrary.simpleMessage("会话日志已清空"),
    "settingsAdbVersionLabel": MessageLookupByLibrary.simpleMessage("ADB 运行时版本"),
    "settingsAppearanceSection": MessageLookupByLibrary.simpleMessage("外观与语言"),
    "settingsAutoMonitorDesc": MessageLookupByLibrary.simpleMessage("在后台定时轮询检测 ADB 与 Fastboot 连接状态变化"),
    "settingsAutoMonitorTitle": MessageLookupByLibrary.simpleMessage("自动后台监控已连接设备"),
    "settingsCheckUpdatesDesc": MessageLookupByLibrary.simpleMessage("通过 GitHub Releases 检查是否存在 FolkTool 新版本"),
    "settingsCheckUpdatesTitle": MessageLookupByLibrary.simpleMessage("启动时检查更新"),
    "settingsClearDiskLogsDesc": MessageLookupByLibrary.simpleMessage("删除 FolkTool/logs 下的 .txt 和 .log 文件（Boot 备份不受影响）"),
    "settingsClearDiskLogsTitle": MessageLookupByLibrary.simpleMessage("清理磁盘上的历史日志文件"),
    "settingsClearRecentDesc": MessageLookupByLibrary.simpleMessage("仅清除最近文件列表记录，不会删除磁盘上的原始镜像"),
    "settingsClearRecentTitle": MessageLookupByLibrary.simpleMessage("清空最近文件历史"),
    "settingsClearSessionLogsDesc": MessageLookupByLibrary.simpleMessage("清除内存中当前会话的全部操作日志"),
    "settingsClearSessionLogsTitle": MessageLookupByLibrary.simpleMessage("清空当前会话日志"),
    "settingsConfirmFlashDesc": MessageLookupByLibrary.simpleMessage("写入 boot 分区前核对目标设备、镜像路径与安全摘要"),
    "settingsConfirmFlashTitle": MessageLookupByLibrary.simpleMessage("刷入前显示二次确认弹窗"),
    "settingsFastbootVersionLabel": MessageLookupByLibrary.simpleMessage("Fastboot 运行时版本"),
    "settingsFooterSummary": m79,
    "settingsKptoolsVersionLabel": MessageLookupByLibrary.simpleMessage("KernelPatch 修补引擎 (kptools)"),
    "settingsMonitoringSection": MessageLookupByLibrary.simpleMessage("设备监控与安全保护"),
    "settingsOpenFoldersDesc": MessageLookupByLibrary.simpleMessage("查看导出的诊断报告、自动崩溃保护日志与原始 Boot 备份"),
    "settingsOpenFoldersTitle": MessageLookupByLibrary.simpleMessage("打开日志与备份目录"),
    "settingsPlatformToolsRevLabel": MessageLookupByLibrary.simpleMessage("Platform-Tools 修订号"),
    "settingsPlatformToolsTitle": MessageLookupByLibrary.simpleMessage("Android Platform-Tools"),
    "settingsRedactDiagDesc": MessageLookupByLibrary.simpleMessage("导出诊断报告时隐藏 Windows 用户名与完整设备序列号"),
    "settingsRedactDiagTitle": MessageLookupByLibrary.simpleMessage("导出诊断信息时自动脱敏"),
    "settingsRefreshToolchain": MessageLookupByLibrary.simpleMessage("重新检测工具链"),
    "settingsResetDefaultsDesc": MessageLookupByLibrary.simpleMessage("将安全开关与后台监控偏好恢复至默认配置"),
    "settingsResetDefaultsTitle": MessageLookupByLibrary.simpleMessage("恢复默认设置"),
    "settingsRestoredNotice": MessageLookupByLibrary.simpleMessage("已恢复默认设置"),
    "settingsShortcutTooltip": MessageLookupByLibrary.simpleMessage("设置 (Ctrl+,)"),
    "settingsStorageSection": MessageLookupByLibrary.simpleMessage("存储空间与维护"),
    "settingsThemeDark": MessageLookupByLibrary.simpleMessage("深色"),
    "settingsThemeLabel": MessageLookupByLibrary.simpleMessage("主题模式"),
    "settingsThemeLight": MessageLookupByLibrary.simpleMessage("浅色"),
    "settingsThemeSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "settingsToolchainMissing": MessageLookupByLibrary.simpleMessage("文件缺失或异常"),
    "settingsToolchainReady": MessageLookupByLibrary.simpleMessage("校验就绪"),
    "settingsToolchainSection": MessageLookupByLibrary.simpleMessage("工具链与运行时诊断"),
    "simplePatch": MessageLookupByLibrary.simpleMessage("简单修补"),
    "simplePatchSubtitle": MessageLookupByLibrary.simpleMessage("单纯的修补文件"),
    "startFlash": MessageLookupByLibrary.simpleMessage("开始刷入"),
    "startFlashingButton": MessageLookupByLibrary.simpleMessage("开始刷入"),
    "startPatch": MessageLookupByLibrary.simpleMessage("开始修补"),
    "step1": MessageLookupByLibrary.simpleMessage("步骤 1: 修补 boot.img"),
    "step1Desc": MessageLookupByLibrary.simpleMessage("选择文件并执行修补"),
    "step2": MessageLookupByLibrary.simpleMessage("步骤 2: 保存修补文件"),
    "step2Desc": MessageLookupByLibrary.simpleMessage("确认修补文件已保存"),
    "step3": MessageLookupByLibrary.simpleMessage("步骤 3: 设备进入 Fastboot"),
    "step3Desc": MessageLookupByLibrary.simpleMessage("将设备重启到 Fastboot 模式"),
    "step4": MessageLookupByLibrary.simpleMessage("步骤 4: 刷入 boot.img"),
    "step4Desc": MessageLookupByLibrary.simpleMessage("将修补后的文件刷入设备"),
    "stepBackupBoot": MessageLookupByLibrary.simpleMessage("备份 Boot"),
    "stepFlashDevice": MessageLookupByLibrary.simpleMessage("刷入设备"),
    "stepOperation": MessageLookupByLibrary.simpleMessage("分步操作"),
    "stepPatch": MessageLookupByLibrary.simpleMessage("分步操作"),
    "stepPatchImage": MessageLookupByLibrary.simpleMessage("修补镜像"),
    "stepPatchSubtitle": MessageLookupByLibrary.simpleMessage("手动分步执行，灵活掌控每一步"),
    "stepRebootComplete": MessageLookupByLibrary.simpleMessage("重启设备"),
    "stepRebootToFastboot": MessageLookupByLibrary.simpleMessage("重启到 Fastboot"),
    "stepSaveFile": MessageLookupByLibrary.simpleMessage("保存文件"),
    "stepSelectBoot": MessageLookupByLibrary.simpleMessage("选择 Boot 文件"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("切换主题"),
    "switchToChinese": MessageLookupByLibrary.simpleMessage("切换为中文"),
    "switchToEnglish": MessageLookupByLibrary.simpleMessage("Switch to English"),
    "themeDark": MessageLookupByLibrary.simpleMessage("深色模式"),
    "themeLight": MessageLookupByLibrary.simpleMessage("浅色模式"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "toggleNavigation": MessageLookupByLibrary.simpleMessage("切换导航栏"),
    "toolsAvailableTitle": MessageLookupByLibrary.simpleMessage("ADB 与 Fastboot 工具链可用"),
    "toolsMissingTitle": MessageLookupByLibrary.simpleMessage("未检测到 ADB / Fastboot 工具"),
    "unableOpenSamsungPage": m80,
    "unableToOpenLink": m81,
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unsupportedModeDesc": MessageLookupByLibrary.simpleMessage("修补并刷入需要正常 Android 系统 ADB 或 Bootloader Fastboot 模式。三星 Download (Odin) 模式与 Fastboot 不兼容。"),
    "unsupportedModeTitle": m82,
    "usbUnauthorizedDesc": MessageLookupByLibrary.simpleMessage("请解锁手机屏幕，在弹窗中勾选“一律允许使用这台计算机进行调试”并点击允许。"),
    "usbUnauthorizedTitle": m83,
    "verifyAndInstall": MessageLookupByLibrary.simpleMessage("验证并安装"),
    "versionChannelLegacy": MessageLookupByLibrary.simpleMessage("旧版兼容"),
    "versionChannelPrerelease": MessageLookupByLibrary.simpleMessage("预览版"),
    "versionChannelStable": MessageLookupByLibrary.simpleMessage("稳定版"),
    "versionCompatLabel": MessageLookupByLibrary.simpleMessage("兼容范围"),
    "versionCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "versionKpLabel": MessageLookupByLibrary.simpleMessage("KernelPatch"),
    "versionKptoolsLabel": MessageLookupByLibrary.simpleMessage("修补核心"),
    "versionManagerLabel": MessageLookupByLibrary.simpleMessage("管理器"),
    "versionRecommended": MessageLookupByLibrary.simpleMessage("推荐"),
    "versionReleaseDateLabel": MessageLookupByLibrary.simpleMessage("发布日期"),
    "versionSupportUnpack": MessageLookupByLibrary.simpleMessage("内置解包"),
    "versionUnpackUnsupportedWarn": m84,
    "versionVerifiedBadge": MessageLookupByLibrary.simpleMessage("SHA-256 已校验"),
    "viewLogs": MessageLookupByLibrary.simpleMessage("查看日志"),
    "warnKernelOutOfRange": m85,
    "warnLowBattery": m86,
    "warnNonStandardBootMagic": MessageLookupByLibrary.simpleMessage("文件头并非标准 ANDROID! 魔数（部分厂商压缩/init_boot/vendor_boot 存在差异，刷入前请确认镜像正确）。"),
  };
}
