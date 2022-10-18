import 'package:add_card/utils/api_services.dart';
import 'package:add_card/utils/card_strings.dart';
import 'package:add_card/utils/card_type.dart';
import 'package:add_card/utils/card_utilis.dart';
import 'package:add_card/utils/env/environnments.dart';
import 'package:add_card/utils/input_formatters.dart';
import 'package:add_card/screens/credit_card_form/widgets/custom_checkbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({Key? key}) : super(key: key);

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  TextEditingController cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    cardNumberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Credit card form'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  children: [
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormater()
                      ],
                      decoration: InputDecoration(
                        hintText: "Card number",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CardUtils.getCardIcon(_paymentCard.type),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SvgPicture.asset(
                            'assets/icons/card.svg',
                          ),
                        ),
                      ),
                      onSaved: (String? value) {
                        _paymentCard.number =
                            CardUtils.getCleanedNumber(value!);
                      },
                      validator: CardUtils.validateCardNum,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Holder name",
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SvgPicture.asset(
                            'assets/icons/user.svg',
                          ),
                        ),
                      ),
                      onSaved: (String? value) {
                        _paymentCard.name = value;
                      },
                      keyboardType: TextInputType.text,
                      validator: (String? value) =>
                          value!.isEmpty ? Strings.fieldReq : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              hintText: "CVV",
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/Cvv.svg',
                                ),
                              ),
                            ),
                            validator: CardUtils.validateCVV,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _paymentCard.cvv = int.parse(value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter()
                            ],
                            decoration: InputDecoration(
                              hintText: "MM/YY",
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/calender.svg',
                                ),
                              ),
                            ),
                            validator: CardUtils.validateDate,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              List<int> expiryDate =
                                  CardUtils.getExpiryDate(value!);
                              _paymentCard.month = expiryDate[0];
                              _paymentCard.year = expiryDate[1];
                            },
                          ),
                        ),
                      ],
                    ),
                    DibsyEnvironnement.live == DibsyConfig.environnement
                        ? const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: CustomCheckBox(
                              isChecked: false,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _validateInputs,
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    cardNumberController.removeListener(_getCardTypeFrmNumber);
    cardNumberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(cardNumberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar(
        'Please fix the errors in red before submitting.',
        'error',
      );
    } else {
      form.save();
      ApiService.createCardToken(
        cardNumber: _paymentCard.number,
        cardHolder: _paymentCard.name,
        cardExpiryMonth: _paymentCard.month,
        cardExpiryYear: _paymentCard.year,
        cardCVC: _paymentCard.cvv,
        publicKey: DibsyConfig.pk,
        locale: 'en_US',
      )
          .then(
            (response) {},
          )
          .catchError((error) {});
    }
  }

  void _showInSnackBar(String value, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: type == 'success' ? Colors.green : Colors.red,
      ),
    );
  }
}
