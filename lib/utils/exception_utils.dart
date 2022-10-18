class AppError {
  final AppErrorType errorType;
  final int? statusCode;
  final String title;
  final String message;
  const AppError({
    required this.title,
    required this.message,
    required this.errorType,
    this.statusCode,
  });
}

enum AppErrorType { server, connection, parsing }

class MyResponse {
  final bool success;
  final String? token;
  final AppError? error;

  MyResponse({required this.success, this.token, this.error});
}
