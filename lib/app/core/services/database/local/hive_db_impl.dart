import 'dart:io';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../app_db.dart';

/// Implementation of [AppDb] using Hive as a local database.
@LazySingleton(as: AppDb)
class HiveDbImpl implements AppDb {
  /// Fetches all records from the specified table with optional filtering, sorting, and pagination.
  @override
  Future<List<T>> findAll<T>({
    required DbTable table,
    List<Filter>? filters,
    bool paginate = true,
    int limit = 10,
    int offset = 0,
    String? orderBy,
    bool isAscending = true,
    Map<String, dynamic> Function(T)? toJson, // optional, needed only if filters/sort needed
  }) async {
    final box = Hive.isBoxOpen(table.name)
        ? Hive.box<T>(table.name)
        : await Hive.openBox<T>(table.name);

    var allData = box.values.cast<T>().toList();

    // Apply filters if provided along with a toJson function
    if (filters != null && toJson != null) {
      allData = _applyFilters(allData, filters, toJson);
    }

    // Sort data if an orderBy field is provided along with a toJson function
    if (orderBy != null && toJson != null) {
      allData.sort((a, b) {
        final aVal = toJson(a)[orderBy] ?? '';
        final bVal = toJson(b)[orderBy] ?? '';
        return isAscending
            ? Comparable.compare(aVal, bVal)
            : Comparable.compare(bVal, aVal);
      });
    }

    // Paginate results if enabled
    if (paginate) {
      final end = (offset + limit).clamp(0, allData.length);
      return allData.sublist(offset, end);
    }

    return allData;
  }

  /// Internal helper method to apply filters on the data.
  List<T> _applyFilters<T>(
    List<T> data,
    List<Filter>? filters,
    Map<String, dynamic> Function(T) toJson,
  ) {
    if (filters == null) return data;
    return data.where((item) {
      final map = toJson(item);
      return filters.every((filter) {
        final value = map[filter.column];
        switch (filter.operator) {
          case Operator.eq:
            return value == filter.value;
          case Operator.gt:
            return value > filter.value;
          case Operator.gte:
            return value >= filter.value;
          case Operator.lt:
            return value < filter.value;
          case Operator.lte:
            return value <= filter.value;
          case Operator.contains:
            return (value as List).contains(filter.value);
          case Operator.inFilter:
            return (filter.value as List).contains(value);
          default:
            return true;
        }
      });
    }).toList();
  }

  /// Retrieves a single record by its ID.
  @override
  Future<T?> findById<T>({
    required DbTable table,
    required String id,
    String? select,
  }) async {
    final box = Hive.isBoxOpen(table.name)
        ? Hive.box<T>(table.name)
        : await Hive.openBox<T>(table.name);
    return box.get(id);
  }

  /// Inserts or updates a record in the specified table.
  @override
  Future<void> upsert<T>({
    required DbTable table,
    required String id,
    required T data,
  }) async {
    final box = Hive.isBoxOpen(table.name)
        ? Hive.box<T>(table.name)
        : await Hive.openBox<T>(table.name);
    await box.put(id, data);
  }

  /// Deletes a record by its ID from the specified table.
  @override
  Future<void> delete<T>({required DbTable table, required String id}) async {
    final box = Hive.isBoxOpen(table.name)
        ? Hive.box<T>(table.name)
        : await Hive.openBox<T>(table.name);
    await box.delete(id);
  }

  /// Saves an image file to the local device and returns the path to the saved file.
  @override
  Future<String?> saveImageToLocal({required File imageFile}) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = '${dir.path}/$fileName.png';
    final newImage = await imageFile.copy(path);
    return newImage.path;
  }
}
