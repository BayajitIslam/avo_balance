
class SubscriptionPlan {
  final String id;
  final String title;
  final String priceUSD;
  final String priceEUR;
  final String description;
  final String icon;
  final bool isBestValue;
  final String? dailyCost;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.priceUSD,
    required this.priceEUR,
    required this.description,
    required this.icon,
    this.isBestValue = false,
    this.dailyCost,
  });

  String get displayPrice => '\$$priceUSD/€$priceEUR';
}
