
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employeedirectoryapp/core/helper/extensions/hive_extensions.dart';

import '../../../features/splash/controller/splash_controller.dart';
import '../extensions/getx_controller_extensions.dart';



Future<void> initializeAppServices() async {

  WidgetsFlutterBinding.ensureInitialized();
  lazyPut( SplashController());
  await Hive.initializeApp();


}