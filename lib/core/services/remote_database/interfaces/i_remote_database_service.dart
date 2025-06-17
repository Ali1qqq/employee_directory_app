abstract class IRemoteDatabaseService<T> {
  Future<List<T>> getAll(String path);
  Future<T> getById(String path);
  Future<T> post(String path, T data);
  Future<T> put(String path, T data);
  Future<void> delete(String path);
}