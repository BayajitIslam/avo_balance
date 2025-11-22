import 'package:get/get.dart';
import 'package:template/features/main_screen/controllers/tracking_controller.dart';

class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrackingController(), fenix: true);
  }
}
