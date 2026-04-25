import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/subscription_local_db.dart';
import '../data/subscription_repository_impl.dart';
import '../domain/subscription.dart';
import '../domain/subscription_metrics.dart';
import '../domain/subscription_repository.dart';

final subscriptionDbProvider = Provider((ref) => SubscriptionLocalDb());

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepositoryImpl(ref.read(subscriptionDbProvider)),
);

final subscriptionListProvider =
    StateNotifierProvider<SubscriptionController, AsyncValue<List<Subscription>>>(
  (ref) => SubscriptionController(ref.read(subscriptionRepositoryProvider))..load(),
);

class SubscriptionController extends StateNotifier<AsyncValue<List<Subscription>>> {
  SubscriptionController(this._repo) : super(const AsyncLoading());
  final SubscriptionRepository _repo;
  static const _uuid = Uuid();

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getAll);
  }

  Future<void> save({
    String? id,
    required String name,
    required double price,
    required BillingCycle cycle,
    required DateTime renewalDate,
    required bool remindersEnabled,
    String? category,
    required String currencyCode,
  }) async {
    final item = Subscription(
      id: id ?? _uuid.v4(),
      name: name,
      price: price,
      cycle: cycle,
      renewalDate: renewalDate,
      remindersEnabled: remindersEnabled,
      category: category?.trim().isEmpty == true ? null : category,
      currencyCode: currencyCode,
    );
    final result = await AsyncValue.guard(() async {
      await _repo.save(item);
      final current = state.valueOrNull;
      if (current == null) {
        return _repo.getAll();
      }
      final updated = [...current];
      final index = updated.indexWhere((s) => s.id == item.id);
      if (index >= 0) {
        updated[index] = item;
      } else {
        updated.add(item);
      }
      return SubscriptionMetrics.sortByUpcoming(updated);
    });
    state = result;
  }

  Future<void> remove(String id) async {
    final result = await AsyncValue.guard(() async {
      await _repo.delete(id);
      final current = state.valueOrNull;
      if (current == null) {
        return _repo.getAll();
      }
      return current.where((s) => s.id != id).toList();
    });
    state = result;
  }
}
