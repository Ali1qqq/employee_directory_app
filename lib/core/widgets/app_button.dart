import 'package:flutter/material.dart';

import '../styling/app_text_style.dart';
import '../utils/app_ui_utils.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.iconData,
    this.isLoading = false,
    this.color,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
  });

  final String title;
  final Color? color;
  final IconData? iconData;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final bool isLoading;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
              isLoading ? Colors.grey : (color ?? Colors.blue.shade700)),
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius:
                    borderRadius ?? BorderRadius.all(Radius.circular(5))),
          ),
        ),
        onPressed: isLoading ? () {} : onPressed,
        child: SizedBox(
          width: width ?? 120,
          height: height ?? 35,
          child: Center(
            child: Row(
              mainAxisAlignment: iconData != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                isLoading
                    ? AppUIUtils.showLoadingIndicator(width: 16, height: 16)
                    : Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headLineStyle3.copyWith(
                              fontSize: fontSize ?? 12, color: Colors.white),
                        ),
                      ),
                if (iconData != null)
                  Icon(iconData, size: iconSize ?? 18, color: Colors.white),
              ],
            ),
          ),
        ));
  }
}