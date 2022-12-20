import 'dart:convert';

SuccessModel successModelFromJson(String str) =>
    SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  SuccessModel({
    required this.cardToken,
    this.tokenizeCard = false,
  });

  String cardToken;
  bool tokenizeCard;

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        cardToken: json["cardToken"],
      );

  Map<String, dynamic> toJson() => {
        "cardToken": cardToken,
      };
}
