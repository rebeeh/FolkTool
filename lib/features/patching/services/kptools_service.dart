import 'dart:io';
import 'package:path/path.dart' as p;
import '../../../core/config/app_config.dart';
import '../../../core/l10n/l10n_helper.dart';
import '../../../core/process/process_runner.dart';
import '../models/kp_version.dart';
import '../models/patch_result.dart';
import '../models/patch_target.dart';

typedef PatchLogCallback = void Function(String line);

class KpToolsService {
  final ProcessRunner _processRunner;

  KpToolsService({ProcessRunner? processRunner})
      : _processRunner = processRunner ??
            const DefaultProcessRunner(timeout: Duration(seconds: 60));

  Future<String> _resolveKptoolsExecutable(KpVersion? kpVersion) async {
    final preferred = kpVersion?.kptoolsPath ??
        AppConfig.kptoolsPathForSource(
          (kpVersion?.source ?? PatchTarget.folkpatch).directoryName,
        );
    if (await File(preferred).exists()) {
      return preferred;
    }
    return AppConfig.kptoolsPath;
  }

  Future<PatchResult> patchBootImage({
    required String inputPath,
    required String outputPath,
    List<String> kpmModules = const [],
    KpVersion? kpVersion,
    PatchLogCallback? onLog,
  }) async {
    final logs = <String>[];
    final l10n = appL10n;

    try {
      final kpimgPath = kpVersion?.kpimgPath ?? _getKpimgPath();
      final kptoolsPath = await _resolveKptoolsExecutable(kpVersion);

      onLog?.call(l10n.logCheckingFile);
      onLog?.call(l10n.logInputFile(inputPath));
      onLog?.call(l10n.logOutputFile(outputPath));
      onLog?.call(l10n.logKpimgPath(kpimgPath));
      onLog?.call(l10n.logKptoolsPath(kptoolsPath));

      if (!await File(inputPath).exists()) {
        return PatchResult.failure(
          l10n.errInputNotExist(inputPath),
          logs: logs,
        );
      }

      if (!await File(kpimgPath).exists()) {
        return PatchResult.failure(
          l10n.errKpimgNotExist(kpimgPath),
          logs: logs,
        );
      }

      if (!await File(kptoolsPath).exists()) {
        return PatchResult.failure(
          l10n.errKptoolsNotExist(kptoolsPath),
          logs: logs,
        );
      }

      final workDir = await Directory.systemTemp.createTemp('folkpatch_');
      onLog?.call(l10n.logWorkDir(workDir.path));

      try {
        onLog?.call(l10n.logCopyBoot);
        final bootImgName = p.basename(inputPath);
        final workBootImg = p.join(workDir.path, bootImgName);
        await File(inputPath).copy(workBootImg);
        onLog?.call(l10n.logCopied(workBootImg));

        onLog?.call(l10n.logUnpacking);
        final unpackResult = await _runKptools(
          ['unpack', workBootImg],
          executablePath: kptoolsPath,
          workDir: workDir.path,
          onLog: (line) {
            logs.add(line);
            onLog?.call(line);
          },
        );

        if (unpackResult.exitCode != 0) {
          return PatchResult.failure(
            l10n.errUnpackFailed(unpackResult.stderr),
            logs: logs,
          );
        }

        final kernelPath = p.join(workDir.path, 'kernel');
        if (!await File(kernelPath).exists()) {
          return PatchResult.failure(
            l10n.errKernelNotFound,
            logs: logs,
          );
        }
        onLog?.call(l10n.logUnpackSuccess(kernelPath));

        final kernelOriPath = p.join(workDir.path, 'kernel.ori');
        await File(kernelPath).copy(kernelOriPath);
        onLog?.call(l10n.logBackupKernel);

        onLog?.call(l10n.logPatchingKernel);
        final patchArgs = [
          '-p',
          '-i',
          kernelOriPath,
          '-k',
          kpimgPath,
          '-o',
          kernelPath,
        ];

        final kpmPaths = <String>[];
        for (final module in kpmModules) {
          final fileName = p.basename(module);
          final workModulePath = p.join(workDir.path, fileName);
          await File(module).copy(workModulePath);
          kpmPaths.add(fileName);
          onLog?.call(l10n.logKpmModule(module));
        }

        for (final kpmPath in kpmPaths) {
          patchArgs.addAll(['-M', kpmPath, '-N', kpmPath, '-T', 'kpm']);
        }

        final patchResult = await _runKptools(
          patchArgs,
          executablePath: kptoolsPath,
          workDir: workDir.path,
          onLog: (line) {
            logs.add(line);
            onLog?.call(line);
          },
        );

        if (patchResult.exitCode != 0) {
          return PatchResult.failure(
            l10n.errPatchFailed(patchResult.stderr),
            logs: logs,
          );
        }

        if (!await File(kernelPath).exists()) {
          return PatchResult.failure(
            l10n.errOutputKernelNotFound,
            logs: logs,
          );
        }
        onLog?.call(l10n.logPatchSuccess);

        onLog?.call(l10n.logRepacking);
        await _runKptools(
          ['repack', workBootImg],
          executablePath: kptoolsPath,
          workDir: workDir.path,
          onLog: (line) {
            logs.add(line);
            onLog?.call(line);
          },
        );

        final newBootPath = p.join(workDir.path, 'new-boot.img');

        if (await File(newBootPath).exists()) {
          await File(newBootPath).copy(outputPath);
          final size = await File(outputPath).length();
          onLog?.call(
            l10n.logRepackSuccess(
              outputPath,
              (size / 1024 / 1024).toStringAsFixed(2),
            ),
          );
          return PatchResult.success(outputPath, logs: logs);
        } else {
          return PatchResult.failure(
            l10n.errRepackFailed,
            logs: logs,
          );
        }
      } finally {
        try {
          await workDir.delete(recursive: true);
          onLog?.call(l10n.logCleanWorkDir);
        } catch (e) {
          onLog?.call(l10n.logCleanWorkDirFailed(e));
        }
      }
    } catch (e) {
      return PatchResult.failure(
        l10n.errPatchException(e),
        logs: logs,
      );
    }
  }

  Future<PatchResult> unpatchBootImage({
    required String inputPath,
    required String outputPath,
    PatchLogCallback? onLog,
  }) async {
    final logs = <String>[];
    final l10n = appL10n;

    try {
      final result = await _runKptools(
        ['-u', '-i', inputPath, '-o', outputPath],
        onLog: (line) {
          logs.add(line);
          onLog?.call(line);
        },
      );

      if (result.exitCode == 0 && await File(outputPath).exists()) {
        return PatchResult.success(outputPath, logs: logs);
      } else {
        return PatchResult.failure(
          l10n.errPatchFailed(result.stderr),
          logs: logs,
        );
      }
    } catch (e) {
      return PatchResult.failure(l10n.errPatchException(e), logs: logs);
    }
  }

  Future<String?> unpackBootImage(
    String inputPath, {
    PatchLogCallback? onLog,
  }) async {
    try {
      final result = await _runKptools(['unpack', inputPath], onLog: onLog);

      if (result.exitCode == 0) {
        final dir = p.dirname(inputPath);
        final kernelPath = p.join(dir, 'kernel');
        if (await File(kernelPath).exists()) {
          return kernelPath;
        }
      }
      return null;
    } catch (e) {
      onLog?.call(appL10n.logUnpackException(e));
      return null;
    }
  }

  Future<String?> repackBootImage(
    String inputPath,
    String outputPath, {
    PatchLogCallback? onLog,
  }) async {
    try {
      final result = await _runKptools(
        ['repack', inputPath, '-o', outputPath],
        onLog: onLog,
      );

      if (result.exitCode == 0 && await File(outputPath).exists()) {
        return outputPath;
      }
      return null;
    } catch (e) {
      onLog?.call(appL10n.logRepackException(e));
      return null;
    }
  }

  Future<String> listPatchInfo(
    String inputPath, {
    PatchLogCallback? onLog,
  }) async {
    try {
      final result =
          await _runKptools(['-l', '-i', inputPath], onLog: onLog);
      return result.stdout.toString();
    } catch (e) {
      return appL10n.logListPatchInfoFailed(e);
    }
  }

  Future<bool> checkKpimgExists() => File(_getKpimgPath()).exists();

  Future<bool> checkKptoolsExists() => File(AppConfig.kptoolsPath).exists();

  String _getKpimgPath() => AppConfig.fallbackKpimgPath;

  Future<ProcessResult> _runKptools(
    List<String> args, {
    String? executablePath,
    String? workDir,
    PatchLogCallback? onLog,
  }) async {
    final executable = executablePath ?? AppConfig.kptoolsPath;

    onLog?.call(appL10n.logExecuteCmd('kptools ${args.join(' ')}'));

    final result = await _processRunner.run(
      executable,
      args,
      workingDirectory: workDir,
    );

    if (result.stdout.toString().isNotEmpty) {
      onLog?.call(result.stdout.toString().trim());
    }
    if (result.stderr.toString().isNotEmpty) {
      onLog?.call('[STDERR] ${result.stderr}'.trim());
    }

    return result;
  }
}