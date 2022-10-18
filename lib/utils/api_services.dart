import 'dart:convert';
import 'package:add_card/models/success_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future createCardToken({
    required cardNumber,
    required cardHolder,
    required cardExpiryMonth,
    required cardExpiryYear,
    required cardCVC,
    required publicKey,
    required locale,
  }) async {
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
      return successModelFromJson(response.body).cardToken;
    } else {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      throw Exception(decodedResponse);
    }
  }
}
