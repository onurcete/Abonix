import 'subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getAll();
  Future<void> save(Subscription subscription);
  Future<void> delete(String id);
}
