import 'package:abonix_tracker/src/features/subscriptions/domain/subscription.dart';
import 'package:abonix_tracker/src/features/subscriptions/domain/subscription_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('monthly total converts billing cycles', () {
    final items = [
      Subscription(
        id: '1',
        name: 'Netflix',
        price: 100,
        cycle: BillingCycle.monthly,
        renewalDate: DateTime(2026, 1, 1),
        remindersEnabled: true,
      ),
      Subscription(
        id: '2',
        name: 'Cloud',
        price: 1200,
        cycle: BillingCycle.yearly,
        renewalDate: DateTime(2026, 1, 2),
        remindersEnabled: false,
      ),
      Subscription(
        id: '3',
        name: 'Weekly',
        price: 10,
        cycle: BillingCycle.weekly,
        renewalDate: DateTime(2026, 1, 3),
        remindersEnabled: false,
      ),
    ];

    final total = SubscriptionMetrics.monthlyTotal(items);
    expect(total, closeTo(243.33, 0.1));
  });

  test('upcoming sort orders by renewal date', () {
    final older = Subscription(
      id: '1',
      name: 'A',
      price: 10,
      cycle: BillingCycle.monthly,
      renewalDate: DateTime(2026, 1, 10),
      remindersEnabled: false,
    );
    final sooner = older.copyWith(id: '2', renewalDate: DateTime(2026, 1, 2));

    final sorted = SubscriptionMetrics.sortByUpcoming([older, sooner]);
    expect(sorted.first.id, '2');
  });

  test('upcoming sort uses next billing date for past renewals', () {
    final now = DateTime.now();
    final monthlyPast = Subscription(
      id: '1',
      name: 'MonthlyPast',
      price: 10,
      cycle: BillingCycle.monthly,
      renewalDate: now.subtract(const Duration(days: 40)),
      remindersEnabled: false,
    );
    final yearlyFuture = Subscription(
      id: '2',
      name: 'YearlyFuture',
      price: 100,
      cycle: BillingCycle.yearly,
      renewalDate: now.add(const Duration(days: 2)),
      remindersEnabled: false,
    );

    final sorted = SubscriptionMetrics.sortByUpcoming([yearlyFuture, monthlyPast]);
    expect(sorted.first.id, '2');
  });
}
