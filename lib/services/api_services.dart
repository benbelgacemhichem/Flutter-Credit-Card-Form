import 'dart:convert';
import 'dart:io';
import 'package:add_card/models/success_model.dart';
import 'package:http/http.dart' as http;

import '../utils/exception_utils.dart';

class ApiService {
  static Future<MyResponse> createCardToken({
    required cardNumber,
    required cardHolder,
    required cardExpiryMonth,
    required cardExpiryYear,
    required cardCVC,
    required publicKey,
    required locale,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('https://vault.dibsy.one/card-tokens'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": 'bearer $publicKey',
        },
        body: jsonEncode({
          "cardNumber": cardNumber,
          "cardHolder": cardHolder,
          "cardExpiryMonth": cardExpiryMonth,
          "cardExpiryYear": cardExpiryYear,
          "cardCVC": cardCVC,
          "locale": locale
        }),
      );
      if (response.statusCode == 201) {
        return MyResponse(
          success: true,
          token: successModelFromJson(response.body).cardToken,
        );
      } else {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

        return MyResponse(
          success: false,
          error: AppError(
            errorType: AppErrorType.server,
            statusCode: response.statusCode,
            title: responseData['title'],
            message: responseData['details'],
          ),
        );
      }
    } on SocketException {
      return MyResponse(
          success: false,
          error: const AppError(
              errorType: AppErrorType.connection,
              title: 'Internet issue',
              message: 'Check your connectivity and retry...'));
    } catch (e) {
      return MyResponse(
          success: false,
          error: const AppError(
              errorType: AppErrorType.parsing,
              title: 'parsing issue',
              message: 'A casting problem has been caught...'));
    }
  }
}
