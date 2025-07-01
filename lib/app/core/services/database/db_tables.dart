part of 'app_db.dart';

/// Represents a database table with a specific name.
class DbTable {
  /// The internal name of the table.
  final String _tableName;

  /// Private constructor to enforce factory usage.
  DbTable._(this._tableName);

  /// Internal static value derived from app name for table naming conventions.
  static final String _appName = AppStrings.appName.toLowerCase().replaceAll(
    ' ',
    '_',
  );

  /// Factory to create a [DbTable] instance for the 'medicines' table.
  /// 
  /// If [isDefault] is true, returns a generic table name; otherwise,
  /// prefixes with the app name for flavor-specific databases.
  factory DbTable.medicine({bool isDefault = false}) =>
      DbTable._('${isDefault ? '' : '${_appName}_'}medicines');

  /// Getter for retrieving the table name.
  String get name => _tableName;

  /// Reconstructs a [DbTable] instance from a raw table name string.
  ///
  /// Useful for deserialization or dynamic table handling.
  /// Returns a flavor-safe and generic table instance.
  static DbTable fromName(String name) {
    return DbTable._(name); // Generic and flavor-safe
  }
}
