import 'dart:convert';
import 'dart:io';
import 'package:credit_card_form/constants/exception_constants.dart';
import 'package:credit_card_form/models/success_model.dart';
import 'package:http/http.dart' as http;

import '../models/appError.dart';
import '../models/cardTokenResponse.dart';

class ApiService {
  static Future<CardTokenResponse> createCardToken({
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
        return CardTokenResponse(
          success: true,
          token: successModelFromJson(response.body).cardToken,
        );
      } else {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(
            response.bodyBytes,
          ),
        ) as Map<String, dynamic>;

        return CardTokenResponse(
          success: false,
          error: AppError(
            errorType: AppErrorType.server,
            statusCode: response.statusCode,
            title: responseData['title'] ?? responseData['error'],
            message: responseData['details'] ?? responseData['error'],
          ),
        );
      }
    } on SocketException {
      return CardTokenResponse(
          success: false,
          error: const AppError(
            errorType: AppErrorType.connection,
            title: ExceptionConstants.noInternetTitle,
            message: ExceptionConstants.noInternetMessage,
          ));
    } catch (e) {
      return CardTokenResponse(
          success: false,
          error: const AppError(
              errorType: AppErrorType.parsing,
              title: ExceptionConstants.pasrsingIssueTitle,
              message: ExceptionConstants.pasrsingIssueMessage));
    }
  }
}
