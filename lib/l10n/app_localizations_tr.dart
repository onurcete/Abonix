// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'ABONIX';

  @override
  String get homeTitle => 'Aboneliklerim';

  @override
  String get totalSpending => 'Toplam Harcama';

  @override
  String get thisMonth => 'Bu ay';

  @override
  String get thisYear => 'Bu yıl';

  @override
  String get tapToSwitchPeriod => 'Dönem değiştirmek için dokun';

  @override
  String get upcomingPayments => 'Yaklaşan Ödemeler';

  @override
  String get next30Days => 'Sonraki 30 gün';

  @override
  String get activeSubscriptions => 'Aktif abonelik';

  @override
  String get remindersOn => 'Hatırlatıcı açık';

  @override
  String get byCycle => 'Döngüye göre';

  @override
  String get monthlyEquivalent => 'Aylık eşdeğer';

  @override
  String get allSubscriptions => 'Tüm Abonelikler';

  @override
  String get addSubscription => 'Abonelik Ekle';

  @override
  String get editSubscription => 'Aboneliği Düzenle';

  @override
  String get saveSubscription => 'Aboneliği Kaydet';

  @override
  String get savingSubscription => 'Kaydediliyor...';

  @override
  String get subscriptionName => 'Abonelik Adı';

  @override
  String get subscriptionNameHint => 'örn. Netflix';

  @override
  String get price => 'Fiyat';

  @override
  String get currency => 'Para birimi';

  @override
  String get preferredCurrency => 'Tercih edilen para birimi';

  @override
  String get priceHint => '0,00';

  @override
  String get billingCycle => 'Fatura Döngüsü';

  @override
  String get renewalDate => 'Yenileme Tarihi';

  @override
  String get categoryOptional => 'Kategori (Opsiyonel)';

  @override
  String get noSubscriptionsYet => 'Henüz abonelik yok';

  @override
  String get emptyStateSubtitle =>
      'İlk aboneliğini ekleyerek aylık harcamalarını takip etmeye başla.';

  @override
  String get addFirstSubscription => 'İlk aboneliğini ekle';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Sistem';

  @override
  String get lightTheme => 'Açık';

  @override
  String get darkTheme => 'Koyu';

  @override
  String get english => 'İngilizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get subscriptionDetail => 'Abonelik Detayı';

  @override
  String get statusOverdue => 'Gecikmiş';

  @override
  String get statusUpcoming => 'Yaklaşıyor';

  @override
  String get statusPaid => 'Ödendi';

  @override
  String get monthly => 'Aylık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get weekly => 'Haftalık';

  @override
  String get quarterly => '3 Aylık';

  @override
  String get selectCategory => 'Kategori seç';

  @override
  String get renewalReminders => 'Yenileme Hatırlatıcıları';

  @override
  String get getNotifiedTwoDaysBefore => '2 gün önce bildirim al';

  @override
  String get saveFailed => 'Abonelik kaydedilemedi. Lütfen tekrar dene.';

  @override
  String get subscriptionNotFound => 'Abonelik bulunamadı';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get requiredField => 'Bu alan zorunludur';

  @override
  String get invalidPrice => 'Geçerli bir fiyat girin';

  @override
  String renewsInDays(int days) {
    return '$days gün içinde yenilenir';
  }
}
