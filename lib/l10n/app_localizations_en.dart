// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ABONIX';

  @override
  String get homeTitle => 'My Subscriptions';

  @override
  String get totalSpending => 'Total Spending';

  @override
  String get thisMonth => 'This month';

  @override
  String get thisYear => 'This year';

  @override
  String get tapToSwitchPeriod => 'Tap to switch period';

  @override
  String get upcomingPayments => 'Upcoming Payments';

  @override
  String get next30Days => 'Next 30 days';

  @override
  String get activeSubscriptions => 'Active subs';

  @override
  String get remindersOn => 'Reminders on';

  @override
  String get byCycle => 'By cycle';

  @override
  String get monthlyEquivalent => 'Monthly equivalent';

  @override
  String get allSubscriptions => 'All Subscriptions';

  @override
  String get addSubscription => 'Add Subscription';

  @override
  String get editSubscription => 'Edit Subscription';

  @override
  String get saveSubscription => 'Save Subscription';

  @override
  String get savingSubscription => 'Saving...';

  @override
  String get subscriptionName => 'Subscription Name';

  @override
  String get subscriptionNameHint => 'e.g., Netflix';

  @override
  String get price => 'Price';

  @override
  String get currency => 'Currency';

  @override
  String get preferredCurrency => 'Preferred currency';

  @override
  String get priceHint => '0.00';

  @override
  String get billingCycle => 'Billing Cycle';

  @override
  String get renewalDate => 'Renewal Date';

  @override
  String get categoryOptional => 'Category (Optional)';

  @override
  String get noSubscriptionsYet => 'No subscriptions yet';

  @override
  String get emptyStateSubtitle =>
      'Start tracking your monthly expenses by adding your first subscription.';

  @override
  String get addFirstSubscription => 'Add your first subscription';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Turkish';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get subscriptionDetail => 'Subscription Detail';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusPaid => 'Paid';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get weekly => 'Weekly';

  @override
  String get quarterly => 'Quarterly';

  @override
  String get selectCategory => 'Select category';

  @override
  String get renewalReminders => 'Renewal Reminders';

  @override
  String get getNotifiedTwoDaysBefore => 'Get notified 2 days before';

  @override
  String get saveFailed => 'Could not save subscription. Please try again.';

  @override
  String get subscriptionNotFound => 'Subscription not found';

  @override
  String get retry => 'Retry';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidPrice => 'Enter a valid price';

  @override
  String renewsInDays(int days) {
    return 'Renews in $days days';
  }
}
