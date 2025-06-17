import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../../../controllers/all_employee_controller.dart';

class AllEmpSearchBar extends StatelessWidget {
  const AllEmpSearchBar({
    super.key,
    required this.allEmployeeController,
  });
  final AllEmployeeController allEmployeeController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: CustomTextField(
        iconData: Icons.search,
        textEditingController: allEmployeeController.searchController,
        onChanged: (value) {
          allEmployeeController.searchEmployee(value);
        },
        hint: 'search',
      ),
    );
  }
}