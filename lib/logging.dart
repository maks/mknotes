import 'dart:developer' as developer;

class Log {
  static final Log _singleton = Log._();

  Log._();

  void debug(String message) {
    developer.log(message, time: DateTime.now(), level: 1);
  }

  factory Log() => _singleton;
}
