import 'i_remote_database_service.dart';

abstract class RemoteDatasourceBase<T> {
  final IRemoteDatabaseService<Map<String, dynamic>> databaseService;

  RemoteDatasourceBase({required this.databaseService});

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  Future<List<T>> fetchAll({required String path}) ;

  Future<T> fetchById({required String path}) ;

  Future<T> save(T item, {required String path}) ;

  Future<void> delete( {required String path});

  Future<T> update( T item, {required String path});
}