import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/money/app_currency.dart';

const _currencyKey = 'app_preferred_currency';

final preferredCurrencyProvider = StateNotifierProvider<PreferredCurrencyController, AppCurrency>(
  (ref) => PreferredCurrencyController()..load(),
);

class PreferredCurrencyController extends StateNotifier<AppCurrency> {
  PreferredCurrencyController() : super(AppCurrency.tl);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_currencyKey);
    final parsed = AppCurrency.tryParse(stored);
    if (parsed != null) {
      state = parsed;
    }
  }

  Future<void> setCurrency(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.isoCode);
    state = currency;
  }
}
