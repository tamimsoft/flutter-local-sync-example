/// Adapter class for handling synchronization operations for a specific model.
///
/// This abstract class defines the essential methods and properties needed to map
/// between JSON representations of data and domain models, as well as to provide
/// key information like unique identifiers and timestamps. It serves as a generic
/// base for synchronization logic in various data sources.
library;

import '/app/core/services/database/app_db.dart';

abstract class GenericSyncAdapter<T> {
  /// The name of the table or collection associated with this model type.
  DbTable get table;

  /// Converts a JSON map into a domain model instance.
  T fromJson(Map<String, dynamic> json);

  /// Converts a domain model instance into its JSON representation.
  Map<String, dynamic> toJson(T model);

  /// Retrieves a unique identifier for the given model instance.
  String getId(T model);

  /// Retrieves the last updated timestamp for the given model instance.
  DateTime getUpdatedAt(T model);
}
