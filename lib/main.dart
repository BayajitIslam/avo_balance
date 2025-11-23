import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/themes/themes.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/routes/app_routes.dart';
import 'package:template/routes/routes_name.dart';

void main() {
  // Initialize NavigationController BEFORE runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Put controller in memory permanently
  Get.put(NavigationController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Avo Balance',
          theme: MyAppThemes.lightThemes,
          initialRoute: RoutesName.splashScreen,
          getPages: AppRoutes.pages,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
      // 👉 This MUST be added, otherwise ScreenUtil DOES NOT APPLY
      child: const SizedBox(),
    );
  }
}
