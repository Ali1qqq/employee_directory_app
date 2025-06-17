import 'package:employeedirectoryapp/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../core/helper/extensions/getx_controller_extensions.dart' as Get;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<SplashController>(builder: (_) {
              return FlutterLogo(size: 100);
            }),
          ],
        ),
      ),
    );
  }
}