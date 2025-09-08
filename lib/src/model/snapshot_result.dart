sealed class SnapshotResult<T> {}

class FromDatabaseSnapshotResult<T> extends SnapshotResult<T> {
  final T data;

  FromDatabaseSnapshotResult({required this.data});
}

class EmptySnapshotResult<T> extends SnapshotResult<T> {}

class FromCacheSnapshotResult<T> extends SnapshotResult<T> {
  final T data;

  FromCacheSnapshotResult({required this.data});
}
