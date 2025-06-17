import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_strings.dart';
import '../dialogs/custom_alert_dialog/helper_alert.dart';
import '../helper/enums/enums.dart';
import '../styling/app_colors.dart';
import '../styling/app_text_style.dart';
import '../widgets/app_button.dart';
import '../widgets/app_spacer.dart';

class AppUIUtils {


  static String convertArabicNumbers(String input) {
    // Check if the input contains any non-Arabic characters
    final nonArabicRegex = RegExp(r'[^٠-٩]'); // Matches any character that is not an Arabic numeral

    // If the input contains any non-Arabic characters, return it unchanged
    if (nonArabicRegex.hasMatch(input)) {
      return input;
    }

    // Mapping of Arabic numerals to Western numerals
    const arabicToWestern = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    // Process the input and replace only Arabic numerals
    return input.split('').map((char) {
      return arabicToWestern[char] ?? char; // Replace Arabic numerals, keep others unchanged
    }).join('');
  }



  static String formatDecimalNumberWithCommas(double number) {
    if (number == 0) return '0.00';

    // ضبط الرقم العشري إلى رقمين بعد الفاصلة
    String formattedNumber = number.toStringAsFixed(2);

    // تحويل الرقم إلى سلسلة نصية وتجزئته إلى جزء صحيح وجزء عشري
    List<String> parts = formattedNumber.split('.');
    String integerPart = parts[0]; // الجزء الصحيح
    String decimalPart = parts[1]; // الجزء العشري المحدد إلى رقمين

    // تنسيق الجزء الصحيح باستخدام RegExp لإضافة الفاصلة كل ثلاث خانات
    String formattedIntegerPart = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    final formattedValue = '$formattedIntegerPart.$decimalPart';
    return formattedValue == '-0.00' ? '0.00' : formattedValue;
  }

  static Widget showLoadingIndicator({
    double width = 20,
    double height = 20,
    Color? color = Colors.white,
  }) =>
      Center(
        child: SizedBox(width: width, height: height, child: CircularProgressIndicator(color: color)),
      );

  static showErrorSnackBar({String? title, required String message, NotificationStatus status = NotificationStatus.error}) {
    // Close any existing SnackBar
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    // Show the new SnackBar
    Get.snackbar(
      title ?? _getTitle(status),
      message,
      backgroundColor: _getBackgroundColor(status),
      icon: Icon(
        _getIcon(status),
        color: Colors.white,
      ),
      barBlur: 10,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
    );
  }

  static showSuccessSnackBar({String? title, required String message, NotificationStatus status = NotificationStatus.success}) {
    // Close any existing SnackBar
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    // Show the new SnackBar
    Get.snackbar(
      title ?? _getTitle(status),
      message,
      backgroundColor: _getBackgroundColor(status),
      icon: Icon(
        _getIcon(status),
        color: Colors.white,
      ),
      barBlur: 10,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
    );
  }

  static void showInfoSnackBar({
    String? title,
    required String message,
    NotificationStatus status = NotificationStatus.info,
  }) {
    Get.closeAllSnackbars();

    // Show the new SnackBar
    Get.snackbar(
      title ?? _getTitle(status),
      message,
      backgroundColor: _getBackgroundColor(status),
      icon: Icon(
        _getIcon(status),
        color: Colors.white,
      ),
      barBlur: 10,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
    );
  }

  static String _getTitle(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return 'نجاح';
      case NotificationStatus.error:
        return 'خطأ';
      case NotificationStatus.info:
        return 'تنبية';
    }
  }

  /// 🔹 Get Dynamic Background Color Based on Status
  static Color _getBackgroundColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return Colors.green.withValues(alpha: 0.8);
      case NotificationStatus.error:
        return Colors.red.withValues(alpha: 0.8);
      case NotificationStatus.info:
        return Colors.blue.withValues(alpha: 0.8);
    }
  }

  /// 🔹 Get Dynamic Icon Based on Status
  static IconData _getIcon(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.success:
        return Icons.check_circle;
      case NotificationStatus.error:
        return Icons.error;
      case NotificationStatus.info:
        return Icons.info;
    }
  }

  static onFailure(String message) => HelperAlert.showError( text: message);

  static onSuccess(String message) =>HelperAlert.showSuccess( text: message);

  static onInfo(String message) => showInfoSnackBar(message: message);

  /// The `title` argument is used to title of alert dialog.
  /// The `content` argument is used to content of alert dialog.
  /// The `textOK` argument is used to text for 'OK' Button of alert dialog.
  /// The `textCancel` argument is used to text for 'Cancel' Button of alert dialog.
  /// The `canPop` argument is `canPop` of PopScope.
  /// The `onPopInvokedWithResult` argument is `onPopInvokedWithResult` of PopScope.
  ///
  /// Returns a [Future<bool>].
  static Future<bool> confirm(
    BuildContext context, {
    String? title,
    Widget? content,
    Widget? textOK,
    Widget? textCancel,
    bool canPop = false,
    void Function(bool, dynamic)? onPopInvokedWithResult,
  }) async {
    final bool? isConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.red)),
          alignment: Alignment.center,
          backgroundColor: AppColors.backGroundColor,
          title: title == null
              ? null
              : Center(
                  child: Text(
                    title,
                    style: AppTextStyles.headLineStyle2,
                  ),
                ),
          content: title != null
              ? null
              : Text(
                  AppStrings.areYouSureContinue.tr,
                  style: AppTextStyles.headLineStyle2,
                  textAlign: TextAlign.center,
                ),
          actions: <Widget>[
            AppButton(
              title: AppStrings.no,
              onPressed: () => Navigator.pop(context, false),
              iconData: Icons.clear,
              width: 80,
            ),
            const HorizontalSpace(20),
            AppButton(
              title: AppStrings.yes,
              onPressed: () => Navigator.pop(context, true),
              color: Colors.red,
              iconData: Icons.check,
              width: 80,
            ),
          ],
        ),
      ),
    );
    return isConfirm ?? false;
  }


}