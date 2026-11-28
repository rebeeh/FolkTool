import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FolkTool/app/app_shell_screen.dart';
import 'package:FolkTool/core/config/app_theme.dart';
import 'package:FolkTool/core/process/process_runner.dart';
import 'package:FolkTool/features/device/providers/device_provider.dart';
import 'package:FolkTool/features/device/services/device_service.dart';
import 'package:FolkTool/features/patching/providers/patch_provider.dart';
import 'package:FolkTool/features/patching/providers/version_provider.dart';
import 'package:FolkTool/features/settings/providers/locale_provider.dart';
import 'package:FolkTool/features/settings/providers/settings_provider.dart';
import 'package:FolkTool/features/settings/providers/theme_provider.dart';
import 'package:FolkTool/generated/l10n.dart';

class _IdleProcessRunner implements ProcessRunner {
  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Duration? timeout,
  }) async {
    if (arguments.contains('version') || arguments.contains('--version')) {
      return ProcessResult(1, 0, 'version 37.0.3-123456\n', '');
    }
    if (arguments.contains('devices')) {
      return ProcessResult(1, 0, 'List of devices attached\n', '');
    }
    return ProcessResult(1, 0, '', '');
  }
}

Widget _buildShellApp({
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1.0,
  VersionProvider? versionProvider,
}) {
  final deviceService = DeviceService(
    processRunner: _IdleProcessRunner(),
    skipBinaryExistsCheck: true,
  );

  return MultiProvider(
    key: ValueKey('${locale.languageCode}_${themeMode.name}_$textScale'),
    providers: [
      ChangeNotifierProvider(
        create: (_) => DeviceProvider(deviceService: deviceService),
      ),
      ChangeNotifierProvider(create: (_) => PatchProvider()),
      ChangeNotifierProvider(
        create: (_) => LocaleProvider()..setLocale(locale.languageCode),
      ),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(
        create: (_) => ThemeProvider()..setThemeMode(themeMode),
      ),
      ChangeNotifierProvider(
        create: (_) => versionProvider ?? VersionProvider(),
      ),
    ],
    child: Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProv, themeProv, _) {
        return MaterialApp(
          locale: localeProv.locale,
          themeMode: themeProv.themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('zh'), Locale('en')],
          builder: (context, child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            );
          },
          home: const AppShellScreen(),
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'settings_auto_monitor': false,
      'settings_check_updates': false,
    });
  });

  const viewports = <Size>[
    Size(442, 870),
    Size(508, 870),
    Size(768, 900),
    Size(1024, 768),
    Size(1280, 800),
    Size(1390, 938),
    Size(1920, 1080),
  ];

  for (final size in viewports) {
    testWidgets(
        'AppShellScreen renders cleanly at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildShellApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      if (size.width < 720) {
        expect(find.byType(NavigationBar), findsOneWidget);
        expect(find.byType(NavigationRail), findsNothing);
      } else {
        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);
      }
    });
  }

  testWidgets(
      'Responsive shell navigates cleanly across all pages on 442x870 (1.25x scale) and 1390x938 (ZH dark mode)',
      (tester) async {
    // 1. Narrow viewport with 1.25x text scale in English Light Mode
    tester.view.physicalSize = const Size(442, 870);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildShellApp(textScale: 1.25));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Navigate via Bottom More sheet to Settings
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Appearance & Language'), findsOneWidget);

    // 2. Desktop viewport in Chinese Dark Mode across QuickPatch & Drivers
    SharedPreferences.setMockInitialValues({
      'locale': 'zh',
      'theme_mode': 'dark',
      'settings_auto_monitor': false,
      'settings_check_updates': false,
    });
    final zhVersionProvider = VersionProvider();
    tester.view.physicalSize = const Size(1390, 938);
    await tester.pumpWidget(
      _buildShellApp(
        locale: const Locale('zh'),
        themeMode: ThemeMode.dark,
        versionProvider: zhVersionProvider,
      ),
    );
    await tester.pump();
    for (var i = 0; i < 40 && zhVersionProvider.isLoading; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 25)),
      );
      await tester.pump();
    }
    expect(zhVersionProvider.isLoading, isFalse);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('一键刷入').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('驱动安装').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
