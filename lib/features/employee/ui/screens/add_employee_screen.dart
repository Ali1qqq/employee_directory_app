import 'package:employeedirectoryapp/core/styling/app_text_style.dart';
import 'package:employeedirectoryapp/core/widgets/app_button.dart';
import 'package:employeedirectoryapp/core/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../controllers/add_employee_controller.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text('Add Employee',style: AppTextStyles.headLineStyle1,),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: GetBuilder<AddEmployeeController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.pickedImage != null
                          ? FileImage(controller.pickedImage!)
                          :  AssetImage(AppAssets.defaultAvatar) as ImageProvider,
                    ),
                  ),
                ),
                const VerticalSpace(16),
                CustomTextField(
                  hint: 'full name',
                  textEditingController: controller.nameController,
                  validator: (value) => value!.isEmpty ? 'please enter name' : null,
                ),
                const VerticalSpace(16),
                CustomTextField(
                  hint: 'designation',
                  textEditingController: controller.designationController,
                  validator: (value) => value!.isEmpty ? 'please enter designation' : null,
                ),
                const VerticalSpace(16*2),

                AppButton(title: "save", onPressed: controller.saveEmployee,isLoading: controller.isUploading ,)

              ],
            ),
          ),
        );
      }),
    );
  }
}