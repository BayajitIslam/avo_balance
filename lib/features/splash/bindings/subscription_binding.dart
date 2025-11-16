import 'package:get/get.dart';
import 'package:template/features/splash/controllers/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}
