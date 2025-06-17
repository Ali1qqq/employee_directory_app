import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../styling/app_text_style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.isNumeric = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLine = 1,
    this.height,
    this.textStyle,
    this.maxLength,
    this.filedColor,
    this.hint,
    this.isField = true,
    this.iconData,
    this.borderColor,
  });

  final TextEditingController textEditingController;
  final void Function(String)? onSubmitted;
  final void Function(String _)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final bool enabled;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final double? height;
  final TextStyle? textStyle;
  final int? maxLine;
  final int? maxLength;
  final Color? filedColor;
  final String? hint;
  final bool isField;
  final IconData? iconData;
  final Color? borderColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(convertArabicNumbersToEnglish);
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(convertArabicNumbersToEnglish);
    super.dispose();
  }

  void convertArabicNumbersToEnglish() {
    if (widget.isNumeric) {
      final text = widget.textEditingController.text;
      final convertedText = text.replaceAllMapped(
        RegExp(r'[٠-٩]'),
            (match) => (match.group(0)!.codeUnitAt(0) - 0x660).toString(),
      );
      if (text != convertedText) {
        widget.textEditingController.value =
            widget.textEditingController.value.copyWith(
              text: convertedText,
              selection: TextSelection.collapsed(offset: convertedText.length),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.borderColor ?? Colors.grey;
    final focusedColor = baseColor;
    final enabledColor = baseColor.withValues(alpha:0.7);
    return SizedBox(
      height: widget.height ?? AppConstants.constHeightTextField,
      child: TextFormField(
        maxLines: widget.maxLine,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        validator: widget.validator,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        onFieldSubmitted: widget.onSubmitted,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        scrollPadding: EdgeInsets.zero,
        cursorHeight: 15,
        onTap: () => widget.textEditingController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: widget.textEditingController.text.length),
        inputFormatters: widget.inputFormatters,
        style: widget.textStyle ?? AppTextStyles.headLineStyle3,
        decoration: InputDecoration(
          prefixIcon: widget.iconData != null ? Icon(widget.iconData) : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: enabledColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          fillColor: widget.filedColor ?? Colors.white,
          filled: true,
          hintText: widget.hint,
          hintStyle:
          AppTextStyles.headLineStyle3.copyWith(color: Colors.grey),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        ),
        textDirection: widget.isNumeric ? TextDirection.ltr : null,
      ),
    );
  }
}