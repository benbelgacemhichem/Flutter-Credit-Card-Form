import 'dart:io';

import 'package:add_card/screens/new_card/components/card_strings.dart';
import 'package:add_card/screens/new_card/components/card_type.dart';
import 'package:add_card/screens/new_card/components/card_utilis.dart';
import 'package:add_card/screens/new_card/components/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumberController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  var _paymentCard = PaymentCard();
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // const Spacer(),
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
                          child: SvgPicture.asset('assets/icons/card.svg'),
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
                          child: SvgPicture.asset('assets/icons/user.svg'),
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
                                child: SvgPicture.asset('assets/icons/Cvv.svg'),
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
                                    'assets/icons/calender.svg'),
                              ),
                            ),
                            validator: CardUtils.validateDate,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              List<int> expiryDate =
                                  CardUtils.getExpiryDate(value!);
                              _paymentCard.month = expiryDate[0];
                              _paymentCard.year = 2000 + expiryDate[1];
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: _validateInputs,
                  child: const Text('Pay Now'),
                ),
              )
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
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      _showInSnackBar('Payment card is valid');
      print(_paymentCard);
    }
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 3),
    ));
  }
}
