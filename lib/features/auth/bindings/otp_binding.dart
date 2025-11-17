import 'package:get/get.dart';
import 'package:template/features/auth/controllers/otp_controller.dart';

class OtpBindingSignup extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OTPController(verificationType: "signup"), fenix: true);
  }
}

class OtpBindingPasswordReset extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OTPController(verificationType: "forgot_password"),
      fenix: true,
    );
  }
}
