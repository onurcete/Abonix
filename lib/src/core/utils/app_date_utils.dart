import '../../features/subscriptions/domain/subscription.dart';

class AppDateUtils {
  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime addBillingCycle(DateTime date, BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.monthly:
        return _addMonthsClamped(date, 1);
      case BillingCycle.quarterly:
        return _addMonthsClamped(date, 3);
      case BillingCycle.yearly:
        return _addMonthsClamped(date, 12);
      case BillingCycle.weekly:
        return date.add(const Duration(days: 7));
    }
  }

  static DateTime nextBillingDate(Subscription item, {DateTime? from}) {
    final today = startOfDay(from ?? DateTime.now());
    var next = startOfDay(item.renewalDate);
    while (next.isBefore(today)) {
      next = addBillingCycle(next, item.cycle);
    }
    return next;
  }

  static DateTime _addMonthsClamped(DateTime date, int monthsToAdd) {
    final totalMonthIndex = (date.month - 1) + monthsToAdd;
    final targetYear = date.year + (totalMonthIndex ~/ 12);
    final targetMonth = (totalMonthIndex % 12) + 1;
    final maxDay = _daysInMonth(targetYear, targetMonth);
    final targetDay = date.day > maxDay ? maxDay : date.day;
    return DateTime(
      targetYear,
      targetMonth,
      targetDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static int _daysInMonth(int year, int month) {
    if (month == 12) return DateTime(year + 1, 1, 0).day;
    return DateTime(year, month + 1, 0).day;
  }
}
