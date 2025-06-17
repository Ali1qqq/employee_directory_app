import 'package:employeedirectoryapp/features/employee/ui/screens/add_employee_screen.dart';
import 'package:get/get.dart';

import '../../features/employee/ui/screens/all_employee_screen.dart';
import '../../features/employee/ui/screens/employee_details_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? appRouter = [
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen()),
  GetPage(name: AppRoutes.allEmployeeScreen, page: () => const AllEmployeeScreen()),
  GetPage(name: AppRoutes.employeeDetails, page: () => const EmployeeDetailsScreen()),
  GetPage(name: AppRoutes.addEmployee, page: () => const AddEmployeeScreen()),

];