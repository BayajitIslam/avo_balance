import 'package:get/get.dart';
import 'package:template/features/main_screen/controllers/diet_controller.dart';

class DietBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DietController(), fenix: true);
  }
}
