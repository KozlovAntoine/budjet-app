abstract class DAO<T> {
  Future<T> getFromId(int id);
  Future<List<T>> getAll();

  Future<void> update(T t);

  Future<int> insert(T t);
  Future<void> delete(T t);
}
