import 'package:get/get_navigation/get_navigation.dart';
import 'package:template/features/auth/bindings/auth_binding.dart';
import 'package:template/features/auth/screens/sign_Up_screen.dart';
import 'package:template/features/auth/screens/sign_in_screen.dart';
import 'package:template/features/home/screens/home_screens.dart';
import 'package:template/features/splash/bindings/onboarding_binding.dart';
import 'package:template/features/splash/bindings/splash_binding.dart';
import 'package:template/features/splash/bindings/subscription_binding.dart';
import 'package:template/features/splash/screens/onboarding_screen.dart';
import 'package:template/features/splash/screens/splash_screen.dart';
import 'package:template/features/splash/screens/subscription_package_screen.dart';
import 'package:template/routes/routes_name.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(
      name: RoutesName.home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.login,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.signup,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),

    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
      binding: SplashBinding(),
    ),
    GetPage(
      name: RoutesName.onboarding,
      page: () => OnboardingScreen(),
      transition: Transition.rightToLeft,
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: RoutesName.subscriptionPackage,
      page: () => SubscriptionPackageScreen(),
      transition: Transition.rightToLeft,
      binding: SubscriptionBinding(),
    ),
  ];
}
