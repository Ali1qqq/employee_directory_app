import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
 static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      log(connectivityResults.toString(), name: 'NetworkChecker.hasInternetConnection')  ;
      return connectivityResults.isNotEmpty && connectivityResults.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return true;
    }
  }
}