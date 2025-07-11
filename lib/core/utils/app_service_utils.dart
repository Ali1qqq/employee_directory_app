import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

class AppServiceUtils {
  static String formatSecretEmail(String email) {
    final firstPart = email.split("@").first;
    final lastPart = email.split("@").last;
    var secretFormatted = "";
    for (int i = 0; i < firstPart.length; i++) {
      secretFormatted +=
          (i == 0 || i == firstPart.length - 1) ? firstPart[i] : "*";
    }
    return "$secretFormatted@$lastPart";
  }

  static DateTime? convertStringToDateTime(String? dateString) {
    if (dateString == null) return null;
    final DateFormat dateFormat;
    if (RegExp(r"\d+m").hasMatch(dateString)) {
      final minutes = int.parse(dateString.replaceAll("m", ""));
      return DateTime.now().add(Duration(minutes: minutes));
    } else {
      dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
    }
    return dateFormat.parse(dateString);
  }

  static String? convertDateTimeToString(DateTime? date) {
    if (date == null) return null;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
    return dateFormat.format(date);
  }

  static String capitalizeString({required String text}) {
    String newText = "";
    for (int i = 0; i < text.length; i++) {
      if (i == 0 || (i - 1 >= 0 && (text[i - 1] == " "))) {
        newText += text[i].toUpperCase();
      } else {
        newText += text[i];
      }
    }
    return newText;
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String convertFeetToFeetInches(double feet) {
    int feetPart = feet.floor();
    double inchesPart = (feet - feetPart) * 12.0;
    int inches = inchesPart.round();
    return '$feetPart\'$inches';
  }

  static String replaceArabicNumbersWithEnglish(String input) {
    return input.replaceAllMapped(RegExp(r'[٠-٩]'), (Match match) {
      return String.fromCharCode(
          match.group(0)!.codeUnitAt(0) - 0x0660 + 0x0030);
    });
  }

  static String extractNumbersAndCalculate(String input) {
    // استبدال الفاصلة العربية بالنقطة

    input = replaceArabicNumbersWithEnglish(input);
    String cleanedInput = input.replaceAll('٫', '.');

    // تحقق مما إذا كانت السلسلة تحتوي على معاملات حسابية
    bool hasOperators = cleanedInput.contains(RegExp(r'[+\-*/]'));

    // معالجة الفواصل الزائدة بحيث تبقى فقط الفاصلة الأولى
    cleanedInput =
        cleanedInput.replaceAllMapped(RegExp(r'(\d+)\.(\d+)\.(\d+)'), (match) {
      return '${match.group(1)}.${match.group(2)}';
    });
    if (hasOperators) {
      // إذا كان هناك معاملات، قم باستخراج الأرقام والعمليات وإجراء الحسابات
      RegExp regex = RegExp(r'[0-9.]+|[+\-*/]');
      Iterable<Match> matches = regex.allMatches(cleanedInput);
      List<String> elements = matches.map((match) => match.group(0)!).toList();

      List<double> numbers = [];
      String? operation;

      for (var element in elements) {
        if (double.tryParse(element) != null) {
          double number = double.parse(element);
          if (operation == null) {
            numbers.add(number);
          } else {
            double lastNumber = numbers.removeLast();
            switch (operation) {
              case '+':
                numbers.add(lastNumber + number);
                break;
              case '-':
                numbers.add(lastNumber - number);
                break;
              case '*':
                numbers.add(lastNumber * number);
                break;
              case '/':
                numbers.add(lastNumber / number);
                break;
            }
            operation = null;
          }
        } else {
          operation = element;
        }
      }

      return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
    } else {
      //! إذا لم يكن هناك معاملات، فقط استخرج الأرقام /
      RegExp regex = RegExp(r'[0-9.]+');
      Iterable<Match> matches = regex.allMatches(cleanedInput);
      List<double> numbers =
          matches.map((match) => double.parse(match.group(0)!)).toList();

      // إذا لم توجد أرقام، قم بإرجاع 0
      return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
    }
  }

  static String extractNumbersAndCalculateToInt(String input) {
    // استبدال الفاصلة العربية بالنقطة

    input = replaceArabicNumbersWithEnglish(input);
    String cleanedInput = input.replaceAll('٫', '.');

    // تحقق مما إذا كانت السلسلة تحتوي على معاملات حسابية
    bool hasOperators = cleanedInput.contains(RegExp(r'[+\-*/]'));

    // معالجة الفواصل الزائدة بحيث تبقى فقط الفاصلة الأولى
    cleanedInput =
        cleanedInput.replaceAllMapped(RegExp(r'(\d+)\.(\d+)\.(\d+)'), (match) {
      return '${match.group(1)}.${match.group(2)}';
    });
    if (hasOperators) {
      // إذا كان هناك معاملات، قم باستخراج الأرقام والعمليات وإجراء الحسابات
      RegExp regex = RegExp(r'[0-9.]+|[+\-*/]');
      Iterable<Match> matches = regex.allMatches(cleanedInput);
      List<String> elements = matches.map((match) => match.group(0)!).toList();

      List<double> numbers = [];
      String? operation;

      for (var element in elements) {
        if (double.tryParse(element) != null) {
          double number = double.parse(element);
          if (operation == null) {
            numbers.add(number);
          } else {
            double lastNumber = numbers.removeLast();
            switch (operation) {
              case '+':
                numbers.add(lastNumber + number);
                break;
              case '-':
                numbers.add(lastNumber - number);
                break;
              case '*':
                numbers.add(lastNumber * number);
                break;
              case '/':
                numbers.add(lastNumber / number);
                break;
            }
            operation = null;
          }
        } else {
          operation = element;
        }
      }

      return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
    } else {
      //! إذا لم يكن هناك معاملات، فقط استخرج الأرقام /
      RegExp regex = RegExp(r'[0-9.]+');
      Iterable<Match> matches = regex.allMatches(cleanedInput);
      List<double> numbers =
          matches.map((match) => double.parse(match.group(0)!)).toList();

      // إذا لم توجد أرقام، قم بإرجاع 0
      return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
    }
  }

  static String getAccountType(int? type) {
    switch (type) {
      case 0:
        return 'حساب عادي';
      case 1:
        return 'حساب ختامي';
      case 2:
        return 'حساب تجميعي';
      default:
        return 'حساب عادي';
    }
  }

  static String getAccountAccDebitOrCredit(int? type) {
    switch (type) {
      case 0:
        return 'Debit';
      case 1:
        return 'Credit';
      default:
        return 'Debit';
    }
  }

  static double toFixedDouble(double? value, [int fractionDigits = 2]) =>
      double.tryParse(value?.toStringAsFixed(fractionDigits) ?? '0') ?? 0.0;

  static double calcSub(int vatRatio, double subTotal) {
    double sub = subTotal * (1 + (vatRatio / 100));

    return sub;
  }

  static double calcVat(int? vatRatio, double? subTotal) {
    if (vatRatio == null || vatRatio == 0 || subTotal == null || subTotal == 0) {
      return 0;
    }

    return calcSub(vatRatio, subTotal) - subTotal;
  }

  static double calcSubtotal(int? quantity, double? total) {
    if (quantity == null || quantity == 0 || total == null || total == 0) {
      return 0;
    }

    return total / quantity;
  }

  static double calcGiftPrice(int? quantity, double? subTotal) {
    if (quantity == null || quantity == 0 || subTotal == null || subTotal == 0) {
      return 0;
    }

    return subTotal * quantity;
  }

  static double calcTotal(int? quantity, double? subtotal, double? vat) {
    if (quantity == null || quantity == 0 || subtotal == null || subtotal == 0) {
      return 0;
    }

    return quantity * (subtotal + (vat ?? 0));
  }


  static String generateUniqueId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    // DateTime dateTime = DateTime.parse(isoString);
    // print(dateTime);
    String period = dateTime.hour >= 12 ? "PM" : "AM";

    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;

    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
        "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";
  }

  static String extractTimeFromDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'null';
    }
    // DateTime dateTime = DateTime.parse(isoString);
    // print(dateTime);
    String period = dateTime.hour >= 12 ? "PM" : "AM";

    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;

    return "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";
  }

  static String getDayNameAndMonthName(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String dayName = DateFormat.EEEE().format(date);
    String monthName = DateFormat.MMMM().format(date);
    String year = DateFormat.y().format(date);
    return "$dayName - $monthName -  $year";
  }

  static String formatDateTimeFromString(String? isoString) {
    if (isoString == null) {
      return '';
    }
    DateTime dateTime = DateTime.parse(isoString);

    // تحديد الفترة (AM/PM)
    String period = dateTime.hour >= 12 ? "PM" : "AM";

    // تحويل الساعة إلى تنسيق 12 ساعة
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12; // تحويل الساعة 0 إلى 12

    // تنسيق التاريخ والوقت
    String formattedDateTime =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
        "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

    return formattedDateTime;
  }


  static Map<String, int> convertMinutesToHoursAndMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return {
      'hours': hours,
      'minutes': minutes,
    };
  }

  static String convertMinutesAndFormat(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${AppStrings.hours} $hours  ${AppStrings.minutes} $minutes';
  }



  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(AppServiceUtils.replaceArabicNumbersWithEnglish(
            value.toString())) ??
        0;
  }

  static int parseInt(dynamic value) {
    if (value == null) return 0;
    return int.tryParse(AppServiceUtils.replaceArabicNumbersWithEnglish(
            value.toString())) ??
        0;
  }
}