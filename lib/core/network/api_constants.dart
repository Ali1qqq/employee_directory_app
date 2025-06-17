class ApiConstants {

  static const String baseUrl = 'https://dummy.restapiexample.com/api/v1';

  //  Employee Endpoints
  static const String getAllEmployees = '$baseUrl/employees';
  static String getEmployeeById(String id) => '$baseUrl/employee/$id';
  static const String addEmployee = '$baseUrl/create';
  static String updateEmployee(String id) => '$baseUrl/update/$id';
  static String deleteEmployee(String id) => '$baseUrl/delete/$id';


  // hive boxes
  static const String employeesBoxName ="employeesBoxName";
}