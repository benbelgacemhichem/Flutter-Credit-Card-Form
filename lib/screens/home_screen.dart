import 'package:flutter/material.dart';
import 'package:mad_pay/mad_pay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const ElevatedButton(
                onPressed: null,
                child: Text(
                  '1 QAR - Credit Card payment',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ApplePayButton(
                style: ApplePayButtonStyle.automatic,
                height: 56,
                width: MediaQuery.of(context).size.width,
                type: ApplePayButtonType.buy,
                request: PaymentRequest.apple(
                  apple: AppleParameters(
                    merchantIdentifier: 'merchant.linkia.dibsy',
                  ),
                  currencyCode: 'QAR',
                  countryCode: 'QA',
                  paymentItems: <PaymentItem>[
                    PaymentItem(name: 'Test Order', price: 1),
                  ],
                ),
                onPaymentResult: (PaymentResponse? req) {
                  // print(req?.rawData.);
                },
                onError: (Object? e) {
                  print(e);
                },
              ),
              GooglePayButton(
                type: GooglePayButtonType.plain,
                height: 56,
                width: MediaQuery.of(context).size.width,
                request: PaymentRequest.google(
                  google: GoogleParameters(
                    gatewayName: 'Your Gateway',
                    gatewayMerchantId: 'Your id',
                    merchantId: 'example_id',
                  ),
                  currencyCode: 'QAR',
                  countryCode: 'QA',
                  paymentItems: <PaymentItem>[
                    PaymentItem(name: 'Test Order', price: 1),
                  ],
                ),
                onPaymentResult: (PaymentResponse? req) {},
                onError: (Object? e) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
