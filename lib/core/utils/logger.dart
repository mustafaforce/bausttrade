class Logger {
  static void log(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag]' : '[BaustTrade]';
    print('$prefix $message');
  }

  static void api(String method, String endpoint, {Map<String, dynamic>? data}) {
    print('[API] $method $endpoint');
    if (data != null) {
      print('[API] Payload: $data');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    print('[ERROR] $message');
    if (error != null) {
      print('[ERROR] Error: $error');
    }
    if (stackTrace != null) {
      print('[ERROR] StackTrace: $stackTrace');
    }
  }

  static void success(String message) {
    print('[SUCCESS] $message');
  }
}
