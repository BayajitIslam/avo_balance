import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:template/features/auth/bindings/auth_binding.dart';
import 'package:template/features/auth/bindings/otp_binding.dart';
import 'package:template/features/auth/screens/forgot_password_screen.dart';
import 'package:template/features/auth/screens/otp_verification_screen.dart';
import 'package:template/features/auth/screens/reset_password_screen.dart';
import 'package:template/features/auth/screens/sign_Up_screen.dart';
import 'package:template/features/auth/screens/sign_in_screen.dart';
import 'package:template/features/main_screen/bindings/diet_binding.dart';
import 'package:template/features/main_screen/bindings/edit_profile_binding.dart';
import 'package:template/features/main_screen/bindings/profile_binding.dart';
import 'package:template/features/main_screen/screens/diet/diet_screen.dart';
import 'package:template/features/main_screen/screens/home/home_screens.dart';
import 'package:template/features/main_screen/screens/profile/profile_screen.dart';
import 'package:template/features/main_screen/screens/profile/under_profile_screen/edit_profile_screen.dart';
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
      // transition: Transition.rightToLeft,
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
    GetPage(
      name: RoutesName.forgotPassword,
      page: () => ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.otpVerificationSignup,
      page: () => OTPVerificationScreen(verificationType: "signup"),
      transition: Transition.rightToLeft,
      binding: OtpBindingSignup(),
    ),
    GetPage(
      name: RoutesName.otpVerification,
      page: () => OTPVerificationScreen(verificationType: "forgot_password"),
      transition: Transition.rightToLeft,
      binding: OtpBindingPasswordReset(),
    ),
    GetPage(
      name: RoutesName.resetPassword,
      page: () => ResetPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.dietScreen,
      page: () => DietScreen(),
      // transition: Transition.circularReveal,
      binding: DietBinding(),
    ),
    GetPage(
      name: RoutesName.profileScreen,
      page: () => ProfileScreen(),
      // transition: Transition.rightToLeft,
      bindings: [AuthBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.rightToLeft,
      binding: EditProfileBinding(),
    ),
  ];
}
