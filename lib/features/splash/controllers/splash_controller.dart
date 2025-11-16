import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/routes/routes_name.dart';

class SplashController extends GetxService {
  Timer? timer;
  var opacity = 0.0.obs;
  //get x storeage
  // final LocalStorage _localStorage = Get.put(LocalStorage());

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (opacity.value != 1.0) {
        opacity.value += 0.5;
      }
    });

    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if onboarding is completed
      bool? onboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;

      // Check if user is logged in
      bool? isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (!onboardingCompleted) {
        // First time user → Show onboarding
        Get.offAllNamed(RoutesName.onboarding);
      } else if (isLoggedIn) {
        // User is logged in → Go to HomePage
        Get.offAllNamed(RoutesName.home);
      } else {
        // User completed onboarding but not logged in → LoginPage
        Get.offAllNamed(RoutesName.onboarding);
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
