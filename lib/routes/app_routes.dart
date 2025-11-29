import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:template/features/auth/bindings/auth_binding.dart';
import 'package:template/features/auth/bindings/otp_binding.dart';
import 'package:template/features/auth/screens/forget_password/email_verify.dart';
import 'package:template/features/auth/screens/forget_password/otp_verify.dart';
import 'package:template/features/auth/screens/forget_password/password_saved.dart';
import 'package:template/features/auth/screens/forgot_password_screen.dart';
import 'package:template/features/auth/screens/otp_verification_screen.dart';
import 'package:template/features/auth/screens/reset_password_screen.dart';
import 'package:template/features/auth/screens/sign_Up_screen.dart';
import 'package:template/features/auth/screens/sign_in_screen.dart';
import 'package:template/features/main_screen/bindings/diet_binding.dart';
import 'package:template/features/main_screen/bindings/edit_profile_binding.dart';
import 'package:template/features/main_screen/bindings/profile_binding.dart';
import 'package:template/features/main_screen/bindings/shopping_list_binding.dart';
import 'package:template/features/main_screen/bindings/tracking_binding.dart';
import 'package:template/features/main_screen/screens/diet/diet_screen.dart';
import 'package:template/features/main_screen/screens/home/home_screens.dart';
import 'package:template/features/main_screen/screens/home/weight_entry_screen.dart';
import 'package:template/features/main_screen/screens/legal/faqs_screen.dart';
import 'package:template/features/main_screen/screens/legal/privacy_policy_screen.dart';
import 'package:template/features/main_screen/screens/legal/terms_conditions_screen.dart';
import 'package:template/features/main_screen/screens/profile/profile_screen.dart';
import 'package:template/features/main_screen/screens/profile/under_profile_screen/change_subscription_screen.dart';
import 'package:template/features/main_screen/screens/profile/under_profile_screen/edit_profile_screen.dart';
import 'package:template/features/main_screen/screens/profile/under_profile_screen/password_changes.dart';
import 'package:template/features/main_screen/screens/shoping/shopping_list_screen.dart';
import 'package:template/features/main_screen/screens/tracking/tracking_screen.dart';
import 'package:template/features/splash/bindings/onboarding_binding.dart';
import 'package:template/features/splash/bindings/splash_binding.dart';
import 'package:template/features/splash/bindings/subscription_binding.dart';
import 'package:template/features/splash/screens/after_subscribe_screen.dart';
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
    GetPage(
      name: RoutesName.changeSubscriptionScreen,
      page: () => ChangeSubscriptionScreen(),
      transition: Transition.rightToLeft,
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: RoutesName.changePasswordScreen,
      page: () => ChangePasswordScreen(),
      transition: Transition.rightToLeft,
      // binding: SubscriptionBinding(),
    ),
    GetPage(
      name: RoutesName.faqsScreen,
      page: () => FAQsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.termsConditions,
      page: () => TermsConditionsScreen(),
      transition: Transition.rightToLeft,
      // binding: SubscriptionBinding(),
    ),
    GetPage(
      name: RoutesName.privacyPolicy,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
      // binding: SubscriptionBinding(),
    ),
    GetPage(
      name: RoutesName.shoppingList,
      page: () => ShoppingListScreen(),
      transition: Transition.rightToLeft,
      binding: ShoppingListBinding(),
    ),
    GetPage(
      name: RoutesName.trackingScreen,
      page: () => TrackingScreen(),
      transition: Transition.rightToLeft,
      binding: TrackingBinding(),
    ),
    GetPage(
      name: RoutesName.weightEntryScreen,
      page: () => WeightEntryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.afterSubscribeScreen,
      page: () => AfterSubscribeScreen(),
      transition: Transition.rightToLeft,
      binding: DietBinding(),
    ),
    GetPage(
      name: RoutesName.emailverify,
      page: () => EmailVerify(),
      transition: Transition.rightToLeft,
      // binding: DietBinding(),
    ),
    GetPage(
      name: RoutesName.otpVerify,
      page: () => OtpVerify(),
      transition: Transition.rightToLeft,
      // binding: DietBinding(),
    ),
    GetPage(
      name: RoutesName.passwordSaved,
      page: () => PasswordSaved(),
      transition: Transition.rightToLeft,
      // binding: DietBinding(),
    ),
  ];
}
