import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/bindings/bindings.dart';
import '../core/constants/app_strings.dart';
import '../core/router/app_router.dart';
import '../core/styling/app_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final TranslationController translationController = read<TranslationController>();

    return ScreenUtilInit(
      designSize: const Size(390, 852),
      splitScreenMode: true,
      fontSizeResolver: FontSizeResolvers.height,
      child: GetMaterialApp(
        initialBinding: AppBindings(),
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle.tr,
        theme: AppThemes.defaultTheme,
        getPages: appRouter,
      ),
    );
  }
}