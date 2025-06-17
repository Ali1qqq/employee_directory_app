
import 'package:flutter/material.dart';

import 'apps/app.dart';
import 'core/helper/init_app/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeAppServices();

  runApp(const MyApp() );
}