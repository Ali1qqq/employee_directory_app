import '../../../../core/services/remote_database/interfaces/remote_datasource_base.dart';
import '../model/employee_model.dart';

class EmployeeDatasource extends RemoteDatasourceBase<EmployeeModel> {

  EmployeeDatasource({required super.databaseService});

  @override
  Future<List<EmployeeModel>> fetchAll({required String path}) async {
    final data = await databaseService.getAll(path);
    return data.map(fromJson).toList();
  }

  @override
  Future<EmployeeModel> fetchById({required String path}) async {
    final data = await databaseService.getById(path);
    return fromJson(data);
  }

  @override
  Future<EmployeeModel> save(EmployeeModel item, {required String path}) async {
    final data = await databaseService.post(path, toJson(item));
    return fromJson(data);
  }

  @override
  Future<void> delete({required String path}) async {
    await databaseService.delete(path);
  }

  @override
  Future<EmployeeModel> update(EmployeeModel item, {required String path}) async {
    final data = await databaseService.put(path, toJson(item));
    return fromJson(data);
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