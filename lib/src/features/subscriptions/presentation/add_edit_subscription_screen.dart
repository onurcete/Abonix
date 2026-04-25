import 'package:abonix_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/money/app_currency.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/application/currency_controller.dart';
import '../application/subscription_controller.dart';
import '../domain/subscription.dart';
import 'brand_assets.dart';

class AddEditSubscriptionScreen extends ConsumerStatefulWidget {
  const AddEditSubscriptionScreen({super.key, this.subscriptionId});
  final String? subscriptionId;

  @override
  ConsumerState<AddEditSubscriptionScreen> createState() => _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState extends ConsumerState<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _nameValue = ValueNotifier<String>('');
  BillingCycle _cycle = BillingCycle.monthly;
  DateTime _renewalDate = DateTime.now();
  bool _remindersEnabled = true;
  bool _isSaving = false;
  bool _didPrefill = false;
  AppCurrency _currency = AppCurrency.tl;
  bool _currencyTouched = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_syncNameValue);
    _nameFocusNode.addListener(_onNameFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = widget.subscriptionId;
    if (id == null) return;
    if (_didPrefill) return;
    final items = ref.read(subscriptionListProvider).valueOrNull ?? [];
    Subscription? existing;
    for (final item in items) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }
    if (existing != null && _nameController.text.isEmpty) {
      _nameController.text = existing.name;
      _priceController.text = existing.price.toStringAsFixed(2);
      _categoryController.text = existing.category ?? '';
      _cycle = existing.cycle;
      _renewalDate = existing.renewalDate;
      _remindersEnabled = existing.remindersEnabled;
      _currency = AppCurrency.parse(existing.currencyCode);
      _didPrefill = true;
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_syncNameValue);
    _nameFocusNode.removeListener(_onNameFocusChanged);
    _nameFocusNode.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _nameValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(subscriptionListProvider);
    final isEdit = widget.subscriptionId != null;
    if (!isEdit) {
      ref.listen<AppCurrency>(preferredCurrencyProvider, (previous, next) {
        if (!_currencyTouched) {
          setState(() => _currency = next);
        }
      });
    }
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.yMd(locale).format(_renewalDate);

    if (isEdit && state.isLoading && !_didPrefill) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editSubscription)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (isEdit && state.hasError && !_didPrefill) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editSubscription)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.subscriptionNotFound),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.read(subscriptionListProvider.notifier).load(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (isEdit && _didPrefill == false && state.hasValue) {
      final found = (state.valueOrNull ?? []).any((item) => item.id == widget.subscriptionId);
      if (!found) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.editSubscription)),
          body: Center(child: Text(l10n.subscriptionNotFound)),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l10n.editSubscription : l10n.addSubscription)),
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
            ValueListenableBuilder<String>(
              valueListenable: _nameValue,
              builder: (context, currentName, _) {
                return Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.adaptiveCardSurface(context),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BrandAssets.pathsForName(currentName) == null
                        ? Image.asset(
                            'UI/stitch_minimalist_subscription_tracker/logo/logo.png',
                            fit: BoxFit.contain,
                          )
                        : BrandAssets.logoImageForName(currentName, size: 60),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _FieldLabel(text: l10n.subscriptionName),
            TapRegion(
              onTapOutside: (_) => _nameFocusNode.unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    decoration: InputDecoration(
                      hintText: l10n.subscriptionNameHint,
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: _nameValue,
                    builder: (context, currentName, _) {
                      final suggestions = BrandAssets.startsWith(currentName);
                      final showSuggestions = _nameFocusNode.hasFocus && suggestions.isNotEmpty;
                      if (!showSuggestions) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.adaptiveSuggestionBackground(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.adaptiveSubtleBorder(context)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(suggestions.length, (index) {
                            final name = suggestions[index];
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  leading: BrandAssets.logoOrFallback(name: name, size: 34),
                                  title: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.adaptiveStrongText(context),
                                    ),
                                  ),
                                  onTap: () {
                                    _setName(name);
                                    _nameFocusNode.unfocus();
                                    setState(() {});
                                  },
                                ),
                                if (index != suggestions.length - 1)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppTheme.dividerSubtle,
                                  ),
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FieldLabel(text: l10n.price),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      prefixText: '${_currency.symbol}   ',
                      hintText: l10n.priceHint,
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      final parsed = double.tryParse((v ?? '').replaceAll(',', '.'));
                      if (parsed == null || parsed <= 0) return l10n.invalidPrice;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<AppCurrency>(
                    initialValue: _currency,
                    decoration: InputDecoration(labelText: l10n.currency),
                    items: [
                      for (final c in AppCurrency.values)
                        DropdownMenuItem(
                          value: c,
                          child: Text(
                            c.labelForDisplay(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _currency = value;
                        _currencyTouched = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final singleColumn = constraints.maxWidth < 390;
                final cycleField = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: l10n.billingCycle),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _pickCycle(context, l10n),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.expand_more),
                        ),
                        child: Text(
                          _cycleLabel(l10n, _cycle),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                );
                final dateField = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: l10n.renewalDate),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: _renewalDate,
                        );
                        if (date != null) setState(() => _renewalDate = date);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today, size: 18),
                        ),
                        child: Text(dateLabel, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                );

                if (singleColumn) {
                  return Column(
                    children: [
                      cycleField,
                      const SizedBox(height: 16),
                      dateField,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: cycleField),
                    const SizedBox(width: 8),
                    Expanded(child: dateField),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _FieldLabel(text: l10n.categoryOptional),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: l10n.selectCategory,
                hintStyle: TextStyle(color: AppTheme.textHint),
                suffixIcon: Icon(Icons.expand_more),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.adaptiveReminderPanel(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 20,
                    color: AppTheme.accentPrimary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.renewalReminders,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppTheme.adaptiveStrongText(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.getNotifiedTwoDaysBefore,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.adaptiveStrongText(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _remindersEnabled,
                    onChanged: _isSaving ? null : (value) => setState(() => _remindersEnabled = value),
                    activeThumbColor: AppTheme.switchThumbActive,
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: AppTheme.adaptiveBottomBarBackground(context),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle, size: 20),
              label: Text(
                _isSaving ? l10n.savingSubscription : l10n.saveSubscription,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setName(String value) {
    _nameController.text = value;
    _nameController.selection = TextSelection.collapsed(offset: value.length);
    _nameValue.value = value;
  }

  void _syncNameValue() {
    _nameValue.value = _nameController.text;
  }

  void _onNameFocusChanged() {
    if (mounted) setState(() {});
  }

  String _cycleLabel(AppLocalizations l10n, BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.monthly:
        return l10n.monthly;
      case BillingCycle.yearly:
        return l10n.yearly;
      case BillingCycle.weekly:
        return l10n.weekly;
      case BillingCycle.quarterly:
        return l10n.quarterly;
    }
  }

  Future<void> _pickCycle(BuildContext context, AppLocalizations l10n) async {
    final selected = await showModalBottomSheet<BillingCycle>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: BillingCycle.values
                  .map(
                    (cycle) => ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      leading: Icon(
                        cycle == _cycle ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: cycle == _cycle ? const Color(0xFF466557) : const Color(0xFF98A09C),
                      ),
                      title: Text(
                        _cycleLabel(l10n, cycle),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => Navigator.of(context).pop(cycle),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _cycle = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final price = double.parse(_priceController.text.replaceAll(',', '.'));
    setState(() => _isSaving = true);
    await ref.read(subscriptionListProvider.notifier).save(
      id: widget.subscriptionId,
      name: _nameController.text.trim(),
      price: price,
      cycle: _cycle,
      renewalDate: _renewalDate,
      remindersEnabled: _remindersEnabled,
      category: _categoryController.text.trim(),
      currencyCode: _currency.isoCode,
    );
    final latest = ref.read(subscriptionListProvider);
    if (!mounted) return;
    if (latest.hasError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.saveFailed)),
        );
      setState(() => _isSaving = false);
      return;
    }
    context.go('/');
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.fieldLabel,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
