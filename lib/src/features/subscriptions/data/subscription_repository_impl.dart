import '../domain/subscription.dart';
import '../domain/subscription_repository.dart';
import 'subscription_local_db.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._db);
  final SubscriptionLocalDb _db;

  @override
  Future<List<Subscription>> getAll() async {
    final rows = await _db.listRows();
    return rows.map((row) {
      return Subscription(
        id: row['id'] as String,
        name: row['name'] as String,
        price: (row['price'] as num).toDouble(),
        cycle: BillingCycle.values.firstWhere((c) => c.name == row['cycle']),
        renewalDate: DateTime.parse(row['renewalDate'] as String),
        remindersEnabled: ((row['remindersEnabled'] as num?) ?? 0) == 1,
        category: row['category'] as String?,
        currencyCode: (row['currency'] as String?)?.isNotEmpty == true
            ? row['currency'] as String
            : 'TRY',
      );
    }).toList();
  }

  @override
  Future<void> save(Subscription subscription) {
    return _db.upsert({
      'id': subscription.id,
      'name': subscription.name,
      'price': subscription.price,
      'cycle': subscription.cycle.name,
      'renewalDate': subscription.renewalDate.toIso8601String(),
      'remindersEnabled': subscription.remindersEnabled ? 1 : 0,
      'category': subscription.category,
      'currency': subscription.currencyCode,
    });
  }

  @override
  Future<void> delete(String id) => _db.deleteById(id);
}
