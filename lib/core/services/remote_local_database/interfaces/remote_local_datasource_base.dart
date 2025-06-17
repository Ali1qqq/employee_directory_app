import '../../local_database/interfaces/i_local_database_service.dart';
import '../../remote_database/interfaces/i_remote_database_service.dart';

abstract class RemoteLocalDatasourceBase<T> {
  final IRemoteDatabaseService<Map<String, dynamic>> databaseService;
  final ILocalDatabaseService<T> localDatabaseService;

  RemoteLocalDatasourceBase({
    required this.databaseService,
    required this.localDatabaseService,
  });

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  /// Always prefers remote_database if available, fallback to local
  Future<List<T>> fetchAll({required String path});

  Future<T> fetchById({required String path});

  Future<T> save(T item, {required String path});

  Future<T> update(T item, {required String path});

  Future<void> delete({required String path});
}