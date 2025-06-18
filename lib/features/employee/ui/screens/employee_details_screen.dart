import 'package:employeedirectoryapp/core/styling/app_text_style.dart';
import 'package:employeedirectoryapp/core/widgets/app_spacer.dart';
import 'package:employeedirectoryapp/core/widgets/image_url_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/employee_model.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeModel employee = Get.arguments as EmployeeModel;

    return Scaffold(
      appBar: AppBar(title: Text('Employee Details', style: AppTextStyles.headLineStyle1), centerTitle: true, backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ImageUrlWidget(imgUrl: employee.imgUrl),
            const VerticalSpace(16),
            Text(employee.name, style: AppTextStyles.headLineStyle1),
            Text(employee.designation, style: AppTextStyles.headLineStyle2),
            const VerticalSpace(24),
            const Divider(),
            ListTile(leading: const Icon(Icons.badge), title: const Text('id:'), subtitle: Text(employee.id)),
            ListTile(leading: const Icon(Icons.person), title: const Text('designation :'), subtitle: Text(employee.designation)),
          ],
        ),
      ),
    );
  }
}