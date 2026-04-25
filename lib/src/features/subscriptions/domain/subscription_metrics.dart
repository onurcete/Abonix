import 'subscription.dart';
import '../../../core/utils/app_date_utils.dart';

class SubscriptionMetrics {
  static double monthlyTotal(List<Subscription> items) {
    return items.fold(0, (sum, item) {
      switch (item.cycle) {
        case BillingCycle.monthly:
          return sum + item.price;
        case BillingCycle.yearly:
          return sum + (item.price / 12);
        case BillingCycle.weekly:
          return sum + (item.price * 52 / 12);
        case BillingCycle.quarterly:
          return sum + (item.price / 3);
      }
    });
  }

  static List<Subscription> sortByUpcoming(List<Subscription> items) {
    final result = [...items];
    result.sort((a, b) {
      final da = AppDateUtils.nextBillingDate(a);
      final db = AppDateUtils.nextBillingDate(b);
      return da.compareTo(db);
    });
    return result;
  }

  static double nextDaysTotal(List<Subscription> items, int days, {DateTime? now}) {
    final base = AppDateUtils.startOfDay(now ?? DateTime.now());
    final rangeEnd = base.add(Duration(days: days));
    return items.where((item) {
      final next = AppDateUtils.nextBillingDate(item, from: base);
      return !next.isBefore(base) && !next.isAfter(rangeEnd);
    }).fold<double>(0, (sum, item) => sum + item.price);
  }
}
