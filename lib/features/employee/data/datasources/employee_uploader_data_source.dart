
import 'package:employeedirectoryapp/features/employee/data/model/employee_model.dart';
import '../../../../core/network/as.dart';
import '../../../../core/services/dio/interfaces/uploader_storage_datasource.dart';

class EmployeeUploaderDataSource extends UploaderStorageDataSource<EmployeeModel> {
  EmployeeUploaderDataSource({
    required super.databaseService,
    required super.databaseStorageService,
    required super.localDatabaseService,
  });

  Future<bool> _hasConnection() async => await NetworkChecker.hasInternetConnection();

  @override
  Future<String> uploadImage(String imagePath) async {
    if (!await _hasConnection()) {
      throw Exception('No internet connection — cannot upload image.');
    }
    return databaseStorageService.uploadImage(imagePath: imagePath);
  }

  @override
  Future<EmployeeModel> save(EmployeeModel item, {required String path}) async {
    if (await _hasConnection()) {
      final response = await databaseService.post(path, toJson(item));
      final emp = fromJson(response);
      await localDatabaseService.insert(emp.id,emp);
      return emp;
    } else {
      await localDatabaseService.insert(item.id,item);
      return item;
    }
  }

  @override
  Future<EmployeeModel> update(EmployeeModel item, {required String path}) async {
    if (await _hasConnection()) {
      final response = await databaseService.put(path, toJson(item));
      final emp = fromJson(response);
      await localDatabaseService.update(emp.id,emp);
      return emp;
    } else {
      await localDatabaseService.update(item.id,item);
      return item;
    }
  }

  @override
  Future<void> delete({required String path}) async {
    final id = path.split('/').last;
    await localDatabaseService.delete(id);

    if (await _hasConnection()) {
      await databaseService.delete(path);
    }
  }

  @override
  Future<List<EmployeeModel>> fetchAll({required String path}) async {

    if (await _hasConnection()) {
      final list = await databaseService.getAll(path);

      final employees = list.map((json) => fromJson(json)).toList();
      final map = {for (var e in employees) e.id: e};
      await localDatabaseService.insertAll(map);
      return employees;
    } else {
      return await localDatabaseService.fetchAll();
    }
  }

  @override
  Future<EmployeeModel> fetchById({required String path}) async {
    final id = path.split('/').last;

    if (await _hasConnection()) {
      final json = await databaseService.getById(path);
      final emp = fromJson(json);

      await localDatabaseService.insert(emp.id,emp);
      return emp;
    } else {
      return localDatabaseService.fetchById(id) ??
          (throw Exception('Employee not found locally'));
    }
  }

  @override
  EmployeeModel fromJson(Map<String, dynamic> json) {
    return EmployeeModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(EmployeeModel item) {
    return item.toJson();
  }
}