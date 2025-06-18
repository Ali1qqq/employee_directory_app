import 'package:employeedirectoryapp/core/helper/extensions/getx_controller_extensions.dart';
import 'package:employeedirectoryapp/core/helper/extensions/request_state_extension.dart';
import 'package:employeedirectoryapp/core/styling/app_text_style.dart';
import 'package:employeedirectoryapp/core/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/all_employee_controller.dart';
import '../widgets/all_employee/all_emp_searchbar.dart';
import '../widgets/all_employee/employee_card_widget.dart';

class AllEmployeeScreen extends StatelessWidget {
  const AllEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Directory', style: AppTextStyles.headLineStyle1,), centerTitle: true, backgroundColor: Colors.teal,),
      body: GetBuilder<AllEmployeeController>(
        builder: (allEmployeeController) {
          if (allEmployeeController.fetchEmployeeState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              AllEmpSearchBar(allEmployeeController: allEmployeeController),
              Expanded(
                child: ListView.builder(
                  itemCount: allEmployeeController.viewEmployeeList.length,
                  itemBuilder: (context, index) {
                    return EmployeeCardWidget(employee: allEmployeeController.viewEmployeeList[index],
                      onTap: () => allEmployeeController.navigateToEmployeeDetails(allEmployeeController.viewEmployeeList[index]),);
                  },
                ),
              ),
              Text('employee length: ${allEmployeeController.viewEmployeeList.length}', style: AppTextStyles.headLineStyle3),
              VerticalSpace(20),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => read<AllEmployeeController>().navigateToAddEmployeeScreen(),
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.teal,),
      ),
    );
  }
}