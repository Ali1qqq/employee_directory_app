import 'dart:developer';

import 'package:employeedirectoryapp/core/helper/mixin/app_navigator.dart';
import 'package:employeedirectoryapp/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/enums/enums.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/services/dio/implementations/repos/uploader_storage_repo.dart';
import '../../../core/utils/app_ui_utils.dart';
import '../../employee/data/model/employee_model.dart';

class AllEmployeeController extends GetxController with AppNavigator {
  final RemoteDataServiceWithUploaderRepo<EmployeeModel> _employeeRepo;

  AllEmployeeController(this._employeeRepo);

  final List<EmployeeModel> allEmployeeList = <EmployeeModel>[];
  final List<EmployeeModel> searchEmployeeList = <EmployeeModel>[];

  List<EmployeeModel> get viewEmployeeList => searchEmployeeList.isEmpty ? allEmployeeList : searchEmployeeList;

  RequestState fetchEmployeeState = RequestState.initial;

  TextEditingController searchController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    getAllEmployees();
  }

  getAllEmployees() async {
    fetchEmployeeState = RequestState.loading;
    update();
    final result = await _employeeRepo.getAll(ApiConstants.getAllEmployees);
    result.fold((failure) {
      fetchEmployeeState = RequestState.error;
      update();
      AppUIUtils.onFailure(failure.message);
    }, (fetchedEmployees) => _onGetAllUsersSuccess(fetchedEmployees));
  }

  void _onGetAllUsersSuccess(List<EmployeeModel> fetchedEmployees) {
    allEmployeeList.addAll(fetchedEmployees);
    log("allEmployeeList ${allEmployeeList.length}");
    fetchEmployeeState = RequestState.success;
    update();
  }

  void searchEmployee(String value) {
    searchEmployeeList.assignAll(allEmployeeList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList());

    update();
  }

  void navigateToEmployeeDetails(EmployeeModel selectedEmployee) {
    to(AppRoutes.employeeDetails, arguments: selectedEmployee);
  }

  void navigateToAddEmployeeScreen() {
    to(AppRoutes.addEmployee);

  }

  void addToListEmployee(EmployeeModel newEmployee) {
    allEmployeeList.add(newEmployee);
    update();

  }
}