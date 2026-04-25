import 'package:abonix_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/money/app_currency.dart';
import '../application/currency_controller.dart';
import '../application/locale_controller.dart';
import '../application/theme_mode_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider)?.languageCode ?? 'en';
    final themeMode = ref.watch(themeModeControllerProvider);
    final preferredCurrency = ref.watch(preferredCurrencyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: locale,
            decoration: InputDecoration(labelText: l10n.language),
            items: [
              DropdownMenuItem(value: 'en', child: Text(l10n.english)),
              DropdownMenuItem(value: 'tr', child: Text(l10n.turkish)),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(localeControllerProvider.notifier).setLocale(value);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AppCurrency>(
            initialValue: preferredCurrency,
            decoration: InputDecoration(labelText: l10n.preferredCurrency),
            items: [
              for (final c in AppCurrency.values)
                DropdownMenuItem(
                  value: c,
                  child: Text(c.labelForDisplay()),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(preferredCurrencyProvider.notifier).setCurrency(value);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ThemeMode>(
            initialValue: themeMode,
            decoration: InputDecoration(labelText: l10n.theme),
            items: [
              DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.systemTheme)),
              DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.lightTheme)),
              DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.darkTheme)),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeControllerProvider.notifier).setThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
