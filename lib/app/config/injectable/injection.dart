import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

/// Initializes all dependencies using Injectable + GetIt.
/// This method generates the DI initialization code using `$init` as the entry point.
@InjectableInit(
  initializerName: r'$init',
  asExtension: false,
  includeMicroPackages: false,
)
/// Call this early in your app's lifecycle (e.g., in `main()`).
Future<void> configureDependencies({
  String environment = Environment.dev,
}) async {
  await _ServiceLocatorInitializer.init(environment);
}

/// Internal class to ensure DI is initialized only once.
class _ServiceLocatorInitializer {
  _ServiceLocatorInitializer._();

  static final Completer<void> _initCompleter = Completer<void>();

  //static Future<void> get initFuture => _initCompleter.future;

  /// Initializes dependency injection if not already completed.
  /// Ensures a single initialization attempt across the app lifecycle.
  static Future<void> init(String env) async {
    if (_initCompleter.isCompleted) return;

    try {
      $init(getIt, environment: env);
      _initCompleter.complete();
    } catch (e, stack) {
      _initCompleter.completeError(e, stack);
      rethrow;
    }
  }
}
