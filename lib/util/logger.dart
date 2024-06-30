import 'package:logger/logger.dart';

class MyLogger {
  static Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: _getLogLevel(),
  );

  static Level _getLogLevel() {
    bool isProduction = const bool.fromEnvironment('dart.vm.product');
    return isProduction ? Level.nothing : Level.verbose;
  }

  static void d(String message) {
    _logger.d(message);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  static void disable() {
    _logger = Logger(
      printer: PrettyPrinter(),
      level: Level.nothing,
    );
  }
}
