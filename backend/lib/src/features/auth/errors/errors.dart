import 'dart:convert';

class AuthException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;

  AuthException(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'error': message});
  }

  @override
  String toString() => 'AuthException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}
