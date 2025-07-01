import 'package:logger/logger.dart';

/// Represents the different levels of logging.
enum LogLevel { info, debug, warning, error, verbose }

/// A singleton logger utility to handle application-wide logging needs.
///
/// The [AppLogger] provides an easy interface to log messages at different 
/// severity levels using the underlying `logger` package.
///
/// Supported log levels include:
/// - Info
/// - Debug
/// - Warning
/// - Error
/// - Verbose (default behavior)
///
/// Usage:
/// ```dart
/// AppLogger.log("An informational message", level: LogLevel.info);
/// AppLogger.log("An error occurred", level: LogLevel.error);
/// ```
mixin class AppLogger {
  /// Private constructor for internal use only.
  AppLogger._internal();

  /// Static instance for accessing logger methods.
  static final AppLogger _instance = AppLogger._internal();

  /// Factory constructor to provide singleton access.
  factory AppLogger() => _instance;

  /// Internal logger instance configured with a pretty printer.
  static final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Logs a message at the specified [level].
  ///
  /// [message]: The message to be logged.
  /// [level]: The severity level of the message. Defaults to [LogLevel.info].
  static void log(String message, {LogLevel level = LogLevel.info}) {
    switch (level) {
      case LogLevel.info:
        _logger.i(message);
        break;
      case LogLevel.debug:
        _logger.d(message);
        break;
      case LogLevel.warning:
        _logger.w(message);
        break;
      case LogLevel.error:
        _logger.e(message);
        break;
      default:
        _logger.i(message);
        break;
    }
  }
}