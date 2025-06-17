
import 'package:employeedirectoryapp/core/router/app_routes.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/helper/mixin/app_navigator.dart';

class SplashController extends GetxController with AppNavigator {
  @override
  void onInit() {
    super.onInit();

    _navigateToAllEmployeeScreen();

  }

  void _navigateToAllEmployeeScreen() async{
   await Future.delayed(const Duration(seconds: 1),);
    offAll(AppRoutes.allEmployeeScreen);
  }
}