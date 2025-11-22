import 'package:get/get.dart';
import 'package:template/features/main_screen/controllers/shopping_list_controller.dart';

class ShoppingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShoppingListController(), fenix: true);
  }
}
