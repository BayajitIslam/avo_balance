// controllers/navigation_controller.dart
import 'package:get/get.dart';
import 'package:template/routes/routes_name.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs; // Default to 0 instead of -1

  // Change Page
  void changePage(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(RoutesName.home);
        break;
      case 1:
        Get.offAllNamed(RoutesName.dietScreen);
        break;
      case 2:
        Get.offAllNamed(RoutesName.profileScreen);
        break;
    }
  }

  // Set current page
  void setCurrentPage(int index) {
    currentIndex.value = index;
  }

  // Clear selection
  void clearSelection() {
    currentIndex.value = -1;
  }
}
