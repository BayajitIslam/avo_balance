import 'package:get/get.dart';
import 'package:template/features/main_screen/controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController(), fenix: true);
  }
}
