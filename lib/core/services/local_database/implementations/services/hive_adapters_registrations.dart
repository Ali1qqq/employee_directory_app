import 'package:employeedirectoryapp/core/helper/extensions/hive_extensions.dart';
import 'package:employeedirectoryapp/features/employee/data/model/employee_model.dart';

class HiveAdaptersRegistrations {
  static void registerAllAdapters() {
    EmployeeModelAdapter().registerAdapter();
  }
}