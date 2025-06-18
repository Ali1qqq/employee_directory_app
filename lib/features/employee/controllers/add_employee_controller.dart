import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/error/failure.dart';
import '../../../core/helper/extensions/getx_controller_extensions.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/services/remote_database/implementations/repos/uploader_storage_repo.dart';
import '../../../core/utils/app_ui_utils.dart';
import '../data/model/employee_model.dart';
import 'all_employee_controller.dart'; // implements UploaderStorageDataSource<EmployeeModel>

class AddEmployeeController extends GetxController {
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final imgUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? pickedImage;
  bool isUploading = false;



  final RemoteDataServiceWithUploaderRepo<EmployeeModel> uploaderRepo;

  AddEmployeeController(this.uploaderRepo);

  bool validateForm() => formKey.currentState?.validate() ?? false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage = File(picked.path);
      update(); // trigger rebuild if using GetBuilder
    }
  }

  Future<void> saveEmployee() async {
    if (!validateForm()) return;

    if (pickedImage != null) {
      isUploading = true;
      update();
      final result = await uploaderRepo.uploadImage(pickedImage!.path);

      result.fold(
        (Failure failure) {
          AppUIUtils.onFailure(failure.message);
          isUploading = false;
          update();
          return;
        },
        (String uploadedUrl) {
          _onImageUploadSuccess(uploadedUrl);
          // store in text field if needed
        },
      );
    } else {
      _onSaveSuccess(EmployeeModel(name: nameController.text, designation: designationController.text, imgUrl: ''));
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    designationController.dispose();
    imgUrlController.dispose();
    super.onClose();
  }

  void _onImageUploadSuccess(String uploadedUrl) async {
    isUploading = false;
    update();
    imgUrlController.text = uploadedUrl;
    final newEmployee = EmployeeModel(
      name: nameController.text.trim(),
      designation: designationController.text.trim(),
      imgUrl: uploadedUrl,
    );

    final result = await uploaderRepo.save(newEmployee, ApiConstants.addEmployee);

    result.fold(
      (Failure failure) {
        AppUIUtils.onFailure(failure.message);
      },
      (EmployeeModel employee) {
        _onSaveSuccess(newEmployee);
      },
    );

    update();
  }

  void _onSaveSuccess(EmployeeModel employee) {
    log("employee: ${employee.toJson()}");
    read<AllEmployeeController>().addToListEmployee(employee);

    AppUIUtils.onSuccess('Employee saved successfully');
  }
}