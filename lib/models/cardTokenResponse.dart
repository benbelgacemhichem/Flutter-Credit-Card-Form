import 'appError.dart';

class CardTokenResponse {
  final bool success;
  final String? token;
  final AppError? error;

  CardTokenResponse({required this.success, this.token, this.error});
}
