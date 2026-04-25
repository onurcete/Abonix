import 'package:abonix_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/money/app_currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../settings/application/currency_controller.dart';
import '../application/subscription_controller.dart';
import '../domain/subscription.dart';
import '../domain/subscription_metrics.dart';
import 'brand_assets.dart';

/// Ana sayfa kartlarında ortak kullanılan yavaş parlama gradienti.
LinearGradient _ambientLinearGradient(BuildContext context, double controllerT, bool disableAmbient) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;
  final t = disableAmbient ? 0.5 : controllerT;
  final primarySoft = isDark
      ? scheme.primary.withValues(alpha: 0.14)
      : AppTheme.accentPrimary.withValues(alpha: 0.13);
  final secondarySoft = isDark
      ? scheme.secondary.withValues(alpha: 0.10)
      : scheme.secondary.withValues(alpha: 0.22);
  return LinearGradient(
    begin: Alignment(-0.85 + 1.1 * t, -0.55),
    end: Alignment(0.75 - 0.9 * t, 0.65),
    colors: [
      primarySoft,
      secondarySoft,
      scheme.surface.withValues(alpha: 0),
    ],
    stops: const [0.0, 0.45, 1.0],
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _listBottomSpacing = 96.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(subscriptionListProvider);
    final items = state.valueOrNull;
    final isEmptyState = items != null && items.isEmpty;

    return Scaffold(
      appBar: isEmptyState
          ? null
          : AppBar(
              title: Row(
                children: [
                  SizedBox(
                    width: 46,
                    height: 46,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'UI/stitch_minimalist_subscription_tracker/logo/logo.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ABONIX',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 0.6,
                      height: 1,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          if (items.isEmpty) return _EmptyState(l10n: l10n);

          final locale = Localizations.localeOf(context).toString();
          final preferred = ref.watch(preferredCurrencyProvider);
          final uniqueCodes = items.map((s) => s.currencyCode).toSet();
          final totalsCurrency =
              uniqueCodes.length == 1 ? AppCurrency.parse(uniqueCodes.first) : preferred;
          final currency = totalsCurrency.numberFormat(locale);
          final monthlyTotal = SubscriptionMetrics.monthlyTotal(items);
          final yearlyTotal = items.fold<double>(0, (sum, s) => sum + _yearlyContribution(s));
          final upcoming = SubscriptionMetrics.sortByUpcoming(items);
          final next30Total = SubscriptionMetrics.nextDaysTotal(items, 30);
          final remindersOnCount = items.where((s) => s.remindersEnabled).length;
          final bottomInset = MediaQuery.paddingOf(context).bottom;
          return ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, _listBottomSpacing + bottomInset),
            children: [
              _TotalSpendingCard(
                l10n: l10n,
                currency: currency,
                monthlyTotal: monthlyTotal,
                yearlyTotal: yearlyTotal,
                next30Total: next30Total,
                subscriptionCount: items.length,
                remindersOnCount: remindersOnCount,
              ),
              const SizedBox(height: 24),
              _AmbientSectionCard(
                title: l10n.upcomingPayments,
                ambientDuration: const Duration(milliseconds: 4600),
                child: SizedBox(
                  height: 118,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: upcoming.length > 8 ? 8 : upcoming.length,
                    separatorBuilder: (_, i) => const SizedBox(width: 10),
                    itemBuilder: (context, index) => _UpcomingTile(upcoming[index]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _AmbientSectionCard(
                title: l10n.allSubscriptions,
                ambientDuration: const Duration(milliseconds: 5200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [...items.map((s) => _SubscriptionTile(s))],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: isEmptyState
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/add'),
              child: const Icon(Icons.add),
            ),
    );
  }

}

class _TotalSpendingCard extends StatefulWidget {
  const _TotalSpendingCard({
    required this.l10n,
    required this.currency,
    required this.monthlyTotal,
    required this.yearlyTotal,
    required this.next30Total,
    required this.subscriptionCount,
    required this.remindersOnCount,
  });

  final AppLocalizations l10n;
  final NumberFormat currency;
  final double monthlyTotal;
  final double yearlyTotal;
  final double next30Total;
  final int subscriptionCount;
  final int remindersOnCount;

  @override
  State<_TotalSpendingCard> createState() => _TotalSpendingCardState();
}

class _TotalSpendingCardState extends State<_TotalSpendingCard> with TickerProviderStateMixin {
  bool _showYearlyTotal = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.028).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
    );
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      }
    });
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _ambientController.stop();
    } else if (!_ambientController.isAnimating) {
      _ambientController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    setState(() => _showYearlyTotal = !_showYearlyTotal);
    _pulseController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAmbient = MediaQuery.disableAnimationsOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          return Transform.scale(
            scale: _pulseScale.value,
            alignment: Alignment.center,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _ambientController,
                    builder: (context, _) {
                      return Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: _ambientLinearGradient(
                              context,
                              _ambientController.value,
                              disableAmbient,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.l10n.totalSpending, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 340),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final curved = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                              reverseCurve: Curves.easeInCubic,
                            );
                            final offset = Tween<Offset>(
                              begin: const Offset(0, 0.16),
                              end: Offset.zero,
                            ).animate(curved);
                            final scale = Tween<double>(begin: 0.93, end: 1.0).animate(curved);
                            return FadeTransition(
                              opacity: curved,
                              child: SlideTransition(
                                position: offset,
                                child: ScaleTransition(
                                  scale: scale,
                                  alignment: Alignment.centerLeft,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            widget.currency.format(
                              _showYearlyTotal ? widget.yearlyTotal : widget.monthlyTotal,
                            ),
                            key: ValueKey(_showYearlyTotal ? 'yearlyAmount' : 'monthlyAmount'),
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 340),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final delayed = CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.14, 1.0, curve: Curves.easeOutCubic),
                              reverseCurve: Curves.easeInCubic,
                            );
                            final offset = Tween<Offset>(
                              begin: const Offset(0.08, 0),
                              end: Offset.zero,
                            ).animate(delayed);
                            return FadeTransition(
                              opacity: delayed,
                              child: SlideTransition(position: offset, child: child),
                            );
                          },
                          child: Text(
                            _showYearlyTotal ? widget.l10n.thisYear : widget.l10n.thisMonth,
                            key: ValueKey(_showYearlyTotal ? 'yearlyLabel' : 'monthlyLabel'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.l10n.tapToSwitchPeriod,
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _MetricPill(
                                label: widget.l10n.next30Days,
                                value: widget.currency.format(widget.next30Total),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricPill(
                                label: widget.l10n.activeSubscriptions,
                                value: '${widget.subscriptionCount}',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricPill(
                                label: widget.l10n.remindersOn,
                                value: '${widget.remindersOnCount}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AmbientSectionCard extends StatefulWidget {
  const _AmbientSectionCard({
    required this.title,
    required this.child,
    this.ambientDuration = const Duration(milliseconds: 4400),
  });

  final String title;
  final Widget child;
  final Duration ambientDuration;

  @override
  State<_AmbientSectionCard> createState() => _AmbientSectionCardState();
}

class _AmbientSectionCardState extends State<_AmbientSectionCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: widget.ambientDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _ambientController.stop();
    } else if (!_ambientController.isAnimating) {
      _ambientController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAmbient = MediaQuery.disableAnimationsOf(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, _) {
              return Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _ambientLinearGradient(
                      context,
                      _ambientController.value,
                      disableAmbient,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                widget.child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  const _UpcomingTile(this.subscription);
  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.MMMd(locale).format(AppDateUtils.nextBillingDate(subscription));
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      splashColor: AppTheme.softPressedSplash,
      highlightColor: AppTheme.softPressedHighlight,
      onTap: () => context.push('/detail/${subscription.id}'),
      child: Container(
        width: 98,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.adaptiveAmbientInnerTileBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.adaptiveAmbientInnerTileBorder(context)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BrandAssets.logoOrFallback(name: subscription.name, size: 56),
            const SizedBox(height: 10),
            Text(
              date,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.adaptiveSoftPillBackground(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11.5),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionTile extends ConsumerWidget {
  const _SubscriptionTile(this.subscription);
  final Subscription subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final nextDate = AppDateUtils.nextBillingDate(subscription);
    final date = DateFormat.yMMMd(locale).format(nextDate);
    final currency = AppCurrency.parse(subscription.currencyCode).numberFormat(locale);
    final dueDays = nextDate.difference(AppDateUtils.startOfDay(DateTime.now())).inDays;
    final (badgeLabel, badgeColor) = _statusForDueDays(context, dueDays);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      color: AppTheme.adaptiveAmbientInnerTileBackground(context),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppTheme.adaptiveAmbientInnerTileBorder(context)),
      ),
      child: InkWell(
        onTap: () => context.push('/detail/${subscription.id}'),
        splashColor: AppTheme.softPressedSplash,
        highlightColor: AppTheme.softPressedHighlight,
        child: ListTile(
          leading: BrandAssets.logoOrFallback(name: subscription.name, size: 50),
          title: Text(
            subscription.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                date,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency.format(subscription.price),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              const SizedBox(height: 4),
              Icon(
                subscription.remindersEnabled
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded,
                size: 18,
                color: subscription.remindersEnabled
                    ? const Color(0xFF466557)
                    : AppTheme.iconMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _statusForDueDays(BuildContext context, int dueDays) {
    final l10n = AppLocalizations.of(context)!;
    if (dueDays < 0) {
      return (l10n.statusOverdue, const Color(0xFFE8A0A0));
    }
    if (dueDays <= 3) {
      return (l10n.statusUpcoming, const Color(0xFFE6C48F));
    }
    return (l10n.statusPaid, Theme.of(context).colorScheme.primary);
  }
}

double _yearlyContribution(Subscription item) {
  switch (item.cycle) {
    case BillingCycle.monthly:
      return item.price * 12;
    case BillingCycle.yearly:
      return item.price;
    case BillingCycle.weekly:
      return item.price * 52;
    case BillingCycle.quarterly:
      return item.price * 4;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(26),
              child: Image.asset(
                'UI/stitch_minimalist_subscription_tracker/logo/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.noSubscriptionsYet,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 42 / 2,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF24282B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.emptyStateSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 30 / 2,
                color: const Color(0xFF707477),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 34),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: const Color(0xFF466557),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add_circle_outline),
              label: Text(
                l10n.addFirstSubscription,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
