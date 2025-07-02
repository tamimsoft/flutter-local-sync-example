import 'dart:io';


part 'db_tables.dart';
/// Represents various operators that can be used to filter database queries.
enum Operator {
  inFilter,
  eq,
  gt,
  gte,
  lt,
  lte,
  like,
  likeAllOf,
  likeAnyOf,
  ilike,
  ilikeAllOf,
  ilikeAnyOf,
  contains,
  overlaps,
}

/// Interface defining core operations for interacting with the application's database.
abstract interface class AppDb {
  /// Retrieves a list of entities from the database based on the provided criteria.
  Future<List<T>> findAll<T>({
    required DbTable table,
    List<Filter>? filters,
    int limit,
    int offset,
    String? orderBy,
    bool paginate = true,
    bool isAscending = false,
    Map<String, dynamic> Function(T)? toJson,
  });

  /// Finds a single entity by its ID.
  Future<T?> findById<T>({
    required DbTable table,
    required String id,
    String? select,
  });

  /// Inserts or updates an entity in the database.
  Future<void> upsert<T>({
    required DbTable table,
    required String id,
    required T data,
  });

  /// Deletes an entity from the database by its ID.
  Future<void> delete<T>({required DbTable table, required String id});

  /// Saves an image file to local storage and returns its path, if successful.
  Future<String?> saveImageToLocal({required File imageFile});
}

/// A class representing a generic filter for querying data from the database.
final class Filter {
  /// The column to apply the filter on.
  final String column;

  /// The [Operator] to use for this filter.
  final Operator operator;

  /// The value to compare against using the specified operator.
  final dynamic value;

  const Filter({
    required this.column,
    required this.operator,
    required this.value,
  });
}
