abstract class ILocalDatabaseService<T> {
  Future<void> insert(String id, T data);

  Future<void> insertAll(Map<String, T> data);

/* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Retrieves all entries from the local database.
  ///
  /// Returns a [Future] that completes with a [List] of all entries
  /// of type [T] stored in the local database.

/* <<<<<<<<<<  0422cf08-dca4-421c-be6b-1a0ba852ec9d  >>>>>>>>>>> */
  Future<List<T>> fetchAll();

  T? fetchById(String id);

  Future<void> update(String id, T data);

  Future<void> updateAll(Map<String, T> data);

  Future<void> delete(String id);

  Future<void> deleteAll(List<String> ids);

  Future<void> clear();
}