import 'package:credit_card_form/screens/credit_card_form/credit_card_form.dart';
import 'package:credit_card_form/theme.dart';
import 'package:credit_card_form/utils/env/environments.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  initializeDibsy(
    env: DibsyEnvironnement.test,
    pkTest: 'pk_test_kzN0KU5RuMjBPjuweNNq86QxtVCdaezRu6v',
    pkLive: 'pk_live_8egKOPfooJ12Y6XipDyWjEkPQsG97KZWaKLN',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dibsy Example',
      debugShowCheckedModeBanner: false,
      theme: appThemeData(context),
      home: const CreditCardForm(),
    );
  }
}
