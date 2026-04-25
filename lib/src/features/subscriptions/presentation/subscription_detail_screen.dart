import 'package:abonix_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/money/app_currency.dart';
import '../application/subscription_controller.dart';
import '../domain/subscription.dart';
import 'brand_assets.dart';

class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});
  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = ref.watch(subscriptionListProvider).valueOrNull ?? [];
    final item = _findById(items, subscriptionId);
    if (item == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Not found')));
    }

    final locale = Localizations.localeOf(context).toString();
    final currency = AppCurrency.parse(item.currencyCode).numberFormat(locale);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscriptionDetail)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: BrandAssets.logoOrFallback(name: item.name, size: 72)),
                  const SizedBox(height: 12),
                  Text(item.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('${l10n.price}: ${currency.format(item.price)}'),
                  Text('${l10n.billingCycle}: ${item.cycle.name}'),
                  Text('${l10n.renewalDate}: ${DateFormat.yMMMd(locale).format(item.renewalDate)}'),
                  if (item.category != null) Text('${l10n.categoryOptional}: ${item.category}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/edit/${item.id}'),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.edit),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    await ref.read(subscriptionListProvider.notifier).remove(item.id);
                    if (context.mounted) context.go('/');
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Subscription? _findById(List<Subscription> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
