#!/usr/bin/env python3
"""Synchronize, verify, and generate Flutter Intl localization files cleanly."""

import argparse
import json
import os
import re
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
ARB_EN_PATH = os.path.join(REPO_ROOT, 'lib', 'l10n', 'intl_en.arb')
ARB_ZH_PATH = os.path.join(REPO_ROOT, 'lib', 'l10n', 'intl_zh.arb')
GENERATED_DIR = os.path.join(REPO_ROOT, 'lib', 'generated')
GENERATED_INTL_DIR = os.path.join(GENERATED_DIR, 'intl')


def extract_placeholders(value: str) -> list[str]:
    seen = []
    for m in re.finditer(r'\{([A-Za-z_][A-Za-z0-9_]*)\}', value):
        name = m.group(1)
        if name not in seen:
            seen.append(name)
    return seen


def dart_dq(s: str) -> str:
    """Escape a string as a Dart double-quoted literal."""
    out = (
        s.replace('\\', '\\\\')
        .replace('"', '\\"')
        .replace('\n', '\\n')
        .replace('\r', '\\r')
        .replace('\t', '\\t')
        .replace('$', '\\$')
    )
    return f'"{out}"'


def dart_sq_with_vars(s: str, args: list[str]) -> str:
    """Escape a string as a Dart single-quoted Intl.message template."""
    out = (
        s.replace('\\', '\\\\')
        .replace("'", "\\'")
        .replace('\n', '\\n')
        .replace('\r', '\\r')
        .replace('\t', '\\t')
        .replace('$', '\\$')
    )
    for arg in args:
        out = out.replace('{' + arg + '}', f'${arg}' if not _needs_braces(out, arg) else f'${{{arg}}}')
    return f"'{out}'"


def _needs_braces(template_escaped: str, arg: str) -> bool:
    token = '{' + arg + '}'
    idx = template_escaped.find(token)
    while idx != -1:
        after_idx = idx + len(token)
        if after_idx < len(template_escaped):
            ch = template_escaped[after_idx]
            if ch.isalnum() or ch == '_':
                return True
        idx = template_escaped.find(token, after_idx)
    return False


def dart_dq_with_vars(s: str, args: list[str]) -> str:
    """Escape a string as a Dart double-quoted MessageLookupByLibrary template."""
    out = (
        s.replace('\\', '\\\\')
        .replace('"', '\\"')
        .replace('\n', '\\n')
        .replace('\r', '\\r')
        .replace('\t', '\\t')
        .replace('$', '\\$')
    )
    for arg in args:
        out = out.replace('{' + arg + '}', f'${{{arg}}}')
    return f'"{out}"'


def validate_arbs(en: dict, zh: dict) -> list[str]:
    errors = []
    en_keys = {k: v for k, v in en.items() if not k.startswith('@')}
    zh_keys = {k: v for k, v in zh.items() if not k.startswith('@')}

    missing_in_zh = sorted(set(en_keys) - set(zh_keys))
    missing_in_en = sorted(set(zh_keys) - set(en_keys))
    if missing_in_zh:
        errors.append(f'Keys missing in intl_zh.arb: {missing_in_zh}')
    if missing_in_en:
        errors.append(f'Keys missing in intl_en.arb: {missing_in_en}')

    for k in sorted(set(en_keys) & set(zh_keys)):
        ev = en_keys[k]
        zv = zh_keys[k]
        if not isinstance(ev, str) or not ev.strip():
            errors.append(f'Empty or invalid EN string for key "{k}"')
        if not isinstance(zv, str) or not zv.strip():
            errors.append(f'Empty or invalid ZH string for key "{k}"')
        if isinstance(ev, str) and isinstance(zv, str):
            ep = set(extract_placeholders(ev))
            zp = set(extract_placeholders(zv))
            if ep != zp:
                errors.append(f'Placeholder mismatch for "{k}": EN={sorted(ep)} vs ZH={sorted(zp)}')
    return errors


def generate_messages_file(locale_name: str, entries: dict[str, str], en_entries: dict[str, str]) -> str:
    lines = [
        '// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart',
        f'// This is a library that provides messages for a {locale_name} locale. All the',
        '// messages from the main program should be duplicated here with the same',
        '// function name.',
        '',
        '// Ignore issues from commonly used lints in this file.',
        '// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new',
        '// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering',
        '// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases',
        '// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes',
        '// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes',
        '',
        "import 'package:intl/intl.dart';",
        "import 'package:intl/message_lookup_by_library.dart';",
        '',
        'final messages = new MessageLookup();',
        '',
        'typedef String MessageIfAbsent(String messageStr, List<dynamic> args);',
        '',
        'class MessageLookup extends MessageLookupByLibrary {',
        f"  String get localeName => '{locale_name}';",
        '',
    ]

    helper_map = {}
    helper_idx = 0
    sorted_keys = sorted(en_entries.keys())
    for k in sorted_keys:
        args = extract_placeholders(en_entries[k])
        val = entries[k]
        if args:
            helper_name = f'm{helper_idx}'
            helper_idx += 1
            helper_map[k] = helper_name
            arg_sig = ', '.join(args)
            lines.append(f'  static String {helper_name}({arg_sig}) => {dart_dq_with_vars(val, args)};')
            lines.append('')

    lines.append('  final messages = _notInlinedMessages(_notInlinedMessages);')
    lines.append('  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{')
    for k in sorted_keys:
        if k in helper_map:
            lines.append(f'    {dart_dq(k)}: {helper_map[k]},')
        else:
            lines.append(f'    {dart_dq(k)}: MessageLookupByLibrary.simpleMessage({dart_dq(entries[k])}),')
    lines.append('  };')
    lines.append('}')
    lines.append('')
    return '\n'.join(lines)


def generate_l10n_dart(en_entries: dict[str, str]) -> str:
    lines = [
        '// GENERATED CODE - DO NOT MODIFY BY HAND',
        "import 'package:flutter/material.dart';",
        "import 'package:intl/intl.dart';",
        "import 'intl/messages_all.dart';",
        '',
        '// **************************************************************************',
        '// Generator: FolkTool ARB Synchronization Script',
        '// **************************************************************************',
        '',
        '// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars',
        '// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each',
        '// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes',
        '',
        'class S {',
        '  S();',
        '',
        '  static S? _current;',
        '',
        '  static S? get maybeCurrent => _current;',
        '',
        '  static S get current {',
        '    assert(',
        '      _current != null,',
        "      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',",
        '    );',
        '    return _current!;',
        '  }',
        '',
        '  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();',
        '',
        '  static Future<S> load(Locale locale) {',
        '    final name = (locale.countryCode?.isEmpty ?? false)',
        '        ? locale.languageCode',
        '        : locale.toString();',
        '    final localeName = Intl.canonicalizedLocale(name);',
        '    return initializeMessages(localeName).then((_) {',
        '      Intl.defaultLocale = localeName;',
        '      final instance = S();',
        '      S._current = instance;',
        '',
        '      return instance;',
        '    });',
        '  }',
        '',
        '  static S of(BuildContext context) {',
        '    final instance = S.maybeOf(context);',
        '    assert(',
        '      instance != null,',
        "      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',",
        '    );',
        '    return instance!;',
        '  }',
        '',
        '  static S? maybeOf(BuildContext context) {',
        '    return Localizations.of<S>(context, S);',
        '  }',
        '',
    ]

    for k, val in en_entries.items():
        args = extract_placeholders(val)
        safe_doc = val.replace('\n', ' ')
        lines.append(f'  /// `{safe_doc}`')
        if args:
            sig = ', '.join(f'Object {a}' for a in args)
            tpl = dart_sq_with_vars(val, args)
            args_list = ', '.join(args)
            lines.extend([
                f'  String {k}({sig}) {{',
                '    return Intl.message(',
                f'      {tpl},',
                f"      name: '{k}',",
                "      desc: '',",
                f'      args: [{args_list}],',
                '    );',
                '  }',
                '',
            ])
        else:
            tpl = dart_sq_with_vars(val, [])
            lines.extend([
                f'  String get {k} {{',
                '    return Intl.message(',
                f'      {tpl},',
                f"      name: '{k}',",
                "      desc: '',",
                '      args: [],',
                '    );',
                '  }',
                '',
            ])

    lines = lines + [
        '}',
        '',
        'class AppLocalizationDelegate extends LocalizationsDelegate<S> {',
        '  const AppLocalizationDelegate();',
        '',
        '  List<Locale> get supportedLocales {',
        "    return const <Locale>[Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'zh')];",
        '  }',
        '',
        '  @override',
        '  bool isSupported(Locale locale) => _isSupported(locale);',
        '  @override',
        '  Future<S> load(Locale locale) => S.load(locale);',
        '  @override',
        '  bool shouldReload(AppLocalizationDelegate old) => false;',
        '',
        '  bool _isSupported(Locale locale) {',
        '    for (var supportedLocale in supportedLocales) {',
        '      if (supportedLocale.languageCode == locale.languageCode) {',
        '        return true;',
        '      }',
        '    }',
        '    return false;',
        '  }',
        '}',
        '',
    ]
    return '\n'.join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--verify-only', action='store_true')
    args = parser.parse_args()

    with open(ARB_EN_PATH, encoding='utf-8') as f:
        en_raw = json.load(f)
    with open(ARB_ZH_PATH, encoding='utf-8') as f:
        zh_raw = json.load(f)

    errs = validate_arbs(en_raw, zh_raw)
    if errs:
        for e in errs:
            print('ERROR:', e, file=sys.stderr)
        return 1

    en_entries = {k: v for k, v in en_raw.items() if not k.startswith('@')}
    zh_entries = {k: v for k, v in zh_raw.items() if not k.startswith('@')}

    if args.verify_only:
        l10n_text = open(os.path.join(GENERATED_DIR, 'l10n.dart'), encoding='utf-8').read()
        msg_en_text = open(os.path.join(GENERATED_INTL_DIR, 'messages_en.dart'), encoding='utf-8').read()
        msg_zh_text = open(os.path.join(GENERATED_INTL_DIR, 'messages_zh.dart'), encoding='utf-8').read()
        missing_gen = [
            k for k in en_entries
            if f'"{k}":' not in msg_en_text or f'"{k}":' not in msg_zh_text or (f'String get {k}' not in l10n_text and f'String {k}(' not in l10n_text)
        ]
        if missing_gen:
            print('ERROR: Generated files missing keys:', missing_gen, file=sys.stderr)
            return 1
        print(f'OK: {len(en_entries)} localization keys verified in EN/ZH ARBs and generated files.')

        lib_root = os.path.join(REPO_ROOT, 'lib')
        leaks = []
        allowed_en = {'English', 'APatch', 'FolkPatch', 'ADB', 'Fastboot', 'Platform-Tools'}
        for dp, _, fns in sorted(os.walk(lib_root)):
            if '/generated' in dp or '\\generated' in dp:
                continue
            for fn in sorted(fns):
                if not fn.endswith('.dart'):
                    continue
                fp = os.path.join(dp, fn)
                with open(fp, encoding='utf-8') as f:
                    for idx, line in enumerate(f, 1):
                        s = line.strip()
                        if s.startswith('//') or s.startswith('import ') or s.startswith('///'):
                            continue
                        if re.search(r'[\u4e00-\u9fff]', s) and "Text('中文')" not in s:
                            leaks.append(f'{os.path.relpath(fp, REPO_ROOT)}:{idx} [ZH]: {s[:90]}')
                        else:
                            m = re.search(r"""(?:Text|tooltip|label|confirmLabel)\s*[:(]\s*(?:const\s+)?['"]([A-Za-z][^'"]*)['"]""", s)
                            if m and m.group(1) not in allowed_en and 'ValueKey' not in s:
                                leaks.append(f'{os.path.relpath(fp, REPO_ROOT)}:{idx} [EN]: {s[:90]}')
        if leaks:
            print('ERROR: Hardcoded UI strings detected:\n  ' + '\n  '.join(leaks), file=sys.stderr)
            return 1
        print('OK: Zero leaked hardcoded UI strings across lib/.')
        return 0

    os.makedirs(GENERATED_INTL_DIR, exist_ok=True)
    with open(os.path.join(GENERATED_DIR, 'l10n.dart'), 'w', encoding='utf-8') as f:
        f.write(generate_l10n_dart(en_entries))
    with open(os.path.join(GENERATED_INTL_DIR, 'messages_en.dart'), 'w', encoding='utf-8') as f:
        f.write(generate_messages_file('en', en_entries, en_entries))
    with open(os.path.join(GENERATED_INTL_DIR, 'messages_zh.dart'), 'w', encoding='utf-8') as f:
        f.write(generate_messages_file('zh', zh_entries, en_entries))
    print(f'Generated localization files for {len(en_entries)} keys cleanly.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
