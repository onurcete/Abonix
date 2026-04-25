import 'package:intl/intl.dart';

/// Uygulama içi para birimleri (ISO 4217 kodları veritabanında saklanır).
enum AppCurrency {
  tl('TRY', '₺'),
  eur('EUR', '€'),
  usd('USD', r'$');

  const AppCurrency(this.isoCode, this.symbol);
  final String isoCode;
  final String symbol;

  static AppCurrency parse(String? code) {
    switch ((code ?? 'TRY').toUpperCase()) {
      case 'EUR':
        return AppCurrency.eur;
      case 'USD':
        return AppCurrency.usd;
      default:
        return AppCurrency.tl;
    }
  }

  static AppCurrency? tryParse(String? code) {
    if (code == null || code.isEmpty) return null;
    switch (code.toUpperCase()) {
      case 'TRY':
        return AppCurrency.tl;
      case 'EUR':
        return AppCurrency.eur;
      case 'USD':
        return AppCurrency.usd;
      default:
        return null;
    }
  }

  String labelForDisplay() => '$isoCode ($symbol)';

  NumberFormat numberFormat(String locale) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
  }
}
