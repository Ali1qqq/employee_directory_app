
import 'package:flutter/material.dart';

import '../../../../../core/styling/app_text_style.dart';
import '../../../../../core/widgets/image_url_widget.dart';
import '../../../data/model/employee_model.dart';

class EmployeeCardWidget extends StatelessWidget {
  const EmployeeCardWidget({super.key, required this.employee, required this.onTap});

  final EmployeeModel employee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Material(
        elevation: 2, // يعطي ظل خفيف
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              leading: ImageUrlWidget(imgUrl: employee.imgUrl),
              title: Text(
                employee.name,
                style: AppTextStyles.headLineStyle1.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                employee.designation,
                style: AppTextStyles.headLineStyle2.copyWith(color: Colors.grey.shade600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

}