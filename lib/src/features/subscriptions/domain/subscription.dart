enum BillingCycle {
  monthly(1),
  yearly(12),
  weekly(1),
  quarterly(3);

  const BillingCycle(this.monthFactor);
  final int monthFactor;
}

class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.cycle,
    required this.renewalDate,
    required this.remindersEnabled,
    this.category,
    this.currencyCode = 'TRY',
  });

  final String id;
  final String name;
  final double price;
  final BillingCycle cycle;
  final DateTime renewalDate;
  final bool remindersEnabled;
  final String? category;

  /// ISO 4217: TRY, EUR, USD
  final String currencyCode;

  Subscription copyWith({
    String? id,
    String? name,
    double? price,
    BillingCycle? cycle,
    DateTime? renewalDate,
    bool? remindersEnabled,
    String? category,
    String? currencyCode,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      cycle: cycle ?? this.cycle,
      renewalDate: renewalDate ?? this.renewalDate,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      category: category ?? this.category,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
