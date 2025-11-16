// controllers/subscription_controller.dart
import 'package:get/get.dart';
import 'package:template/features/splash/models/subscription_model.dart';

class SubscriptionController extends GetxController {
  final RxString selectedPlanId = ''.obs;

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: 'monthly',
      title: 'Monthly',
      priceUSD: '4.99',
      priceEUR: '4.99',
      description: 'Perfect to start using the app and discover your balance',
      icon: '⭐',
      dailyCost: 'Only \$0.16/day',
    ),
    SubscriptionPlan(
      id: 'quarterly',
      title: 'Quarterly',
      priceUSD: '13.99',
      priceEUR: '13.99',
      description: 'Stay consistent and save while building new habits',
      icon: '🏆',
    ),
    SubscriptionPlan(
      id: 'annual',
      title: 'Annual',
      priceUSD: '49.99',
      priceEUR: '49.99',
      description: 'For those serious about long-term results and balance',
      icon: '👑',
      isBestValue: true,
    ),
  ];

  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }

  bool isSelected(String planId) {
    return selectedPlanId.value == planId;
  }
}
