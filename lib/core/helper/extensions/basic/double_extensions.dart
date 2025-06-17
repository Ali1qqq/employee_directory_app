
extension ArabicNumberParsing on String {
  /// محاولة تحويل النص إلى قيمة Double
  double? parseToDouble() {

    return double.tryParse(this);
  }
}
extension DoubleNullableToString on double? {
  String toFixedString() {
    return this?.toString() ?? "0";
  }
}