import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_expansion_panel.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/adv_text_with_number.dart';
import 'package:pit_components/components/adv_visibility.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/components/extras/date_formatter.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';

//class PitPayment {
//

//}

typedef PaymentBodyBuilder = Widget Function(PaymentMethodItem item);
typedef ResetCaller = void Function();
typedef PaymentCallback = void Function(PaymentType paymentType,
    {dynamic result});

enum PaymentType {
  creditCard,
  permataVirtualAccount,
  mandiriClickPay,
  mandiriBillPay,
}

const Map<PaymentType, String> displayValues = {
  PaymentType.creditCard: "Credit Card",
  PaymentType.permataVirtualAccount: "Permata Virtual Account",
  PaymentType.mandiriClickPay: "Mandiri Click Pay",
  PaymentType.mandiriBillPay: "Mandiri Bill Payment",
};

class PaymentMethodItem {
  PaymentMethodItem({this.paymentType, this.builder, this.resetCaller});

  final PaymentType paymentType;
  final PaymentBodyBuilder builder;
  final ResetCaller resetCaller;
  bool isExpanded = false;

  AdvExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            displayValues[paymentType],
            style: ts.fs16.merge(ts.fw700),
          ));
    };
  }

  Widget build() => builder != null ? builder(this) : () {};

  void reset() => resetCaller != null ? resetCaller() : () {};
}

const MethodChannel _channel = const MethodChannel('pit_payment');

class PitPayment extends StatefulWidget {
  final num price;
  final PaymentCallback paymentCallback;
  final EdgeInsetsGeometry padding;

  static Color expansionPanelRadioColor = Colors.blue;
  static Color expansionPanelBackgroundColor = Color(0xffF4FAFE);
  static Color expansionPanelButtonColor = Colors.blue;

  PitPayment(this.price, this.paymentCallback, {this.padding});

  @override
  _PitPaymentState createState() => _PitPaymentState();
}

class CreditCardDetail {
  final String creditCardNumber;
  final int expiryMonth;
  final int expiryYear;
  final int cvv;
  final double amount;

  CreditCardDetail(this.creditCardNumber, this.expiryMonth, this.expiryYear,
      this.cvv, this.amount);

  String toMap() {
    return "{"
        "\"creditCardNumber\": \"$creditCardNumber\", "
        "\"expiryMonth\": $expiryMonth, "
        "\"expiryYear\": $expiryYear, "
        "\"cvv\": $cvv, "
        "\"amount\": $amount"
        "}";
  }
}

class _PitPaymentState extends State<PitPayment> {
  List<PaymentMethodItem> _paymentMethodItem;
  AdvTextFieldController creditCardController = AdvTextFieldController(
      hint: "Credit Card Number", maxLength: 16, maxLengthEnforced: true);
  AdvTextFieldController cvvController = AdvTextFieldController(
      hint: "CVV Number", maxLength: 3, maxLengthEnforced: true);
  AdvTextFieldController expiryDateController =
  AdvTextFieldController(hint: "Expiry Date", text: "00/0000");

  AdvTextFieldController mandiriDebitController = AdvTextFieldController(
      hint: "Mandiri Debit Card Number",
      label: "Mandiri Debit Card Number",
      maxLength: 16,
      maxLengthEnforced: true);
  AdvTextFieldController mandiriTokenController = AdvTextFieldController(
      hint: "Your security code", label: "Challenge Token");
  String randomNumber = "";
  String _creditCardResult = "";

  _randomNumber() {
    var rnd = Random();
    var next = rnd.nextDouble() * 100000;
    while (next < 10000) {
      next *= 10;
    }

    return next.toInt();
  }

  @override
  void initState() {
    super.initState();

    PitComponents.expansionPanelRadioColor =
        PitPayment.expansionPanelRadioColor;
    PitComponents.buttonBackgroundColor = PitPayment.expansionPanelButtonColor;

    randomNumber = _randomNumber().toString();
    _paymentMethodItem = <PaymentMethodItem>[
      PaymentMethodItem(
        paymentType: PaymentType.creditCard,
        resetCaller: () {
          creditCardController.text = "";
          cvvController.text = "";
          expiryDateController.text = "00/0000";
        },
        builder: (PaymentMethodItem item) {
          return Container(
              color: PitPayment.expansionPanelBackgroundColor,
              padding: EdgeInsets.all(32.0),
              child: AdvColumn(divider: ColumnDivider(8.0), children: [
                AdvTextField(
                  controller: creditCardController,
                ),
                AdvTextField(
                  controller: cvvController,
                ),
                AdvTextField(
                  controller: expiryDateController,
                  inputFormatters: [DateTextFormatter("MM/yyyy")],
                ),
                AdvButton(
                  "Submit",
                  width: double.infinity,
                  onPressed: () {
                    String creditCard = creditCardController.text;
                    String expiryDateString = expiryDateController.text;
                    int cvv = int.tryParse(cvvController.text ?? "");
                    DateFormat df = DateFormat("MM/yyyy");
                    DateTime expiryDate = df.parse(expiryDateString);

                    _channel.invokeMethod('generateCreditCardToken', {
                      "creditCard": CreditCardDetail(
                          creditCard,
                          expiryDate.month,
                          expiryDate.year,
                          cvv,
                          widget.price)
                          .toMap()
                    }).then((result) {
                      print("result = $result!");
                      setState(() {
                        if (result.substring(0, 5) == "error") {
                          _creditCardResult = result;
                        } else {
                          _creditCardResult = "";
                          print("sukses $result!");
                          widget.paymentCallback(PaymentType.creditCard,
                              result: result.replaceAll("ccToken: ", ""));
                        }
                      });
                    });
                  },
                ),
                AdvVisibility(
                  child: Text(
                    _creditCardResult,
                    style: ts.fw700.copyWith(color: Colors.redAccent),
                  ),
                  visibility: _creditCardResult == ""
                      ? VisibilityFlag.gone
                      : VisibilityFlag.visible,
                ),
              ]));
        },
      ),
      PaymentMethodItem(
          paymentType: PaymentType.permataVirtualAccount,
          builder: (PaymentMethodItem item) {
            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(
                    divider: ColumnDivider(16.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ATM Transfer Step-by-step",
                        style: ts.fs16.merge(ts.fw700),
                      ),
                      AdvTextWithNumber(
                          Text("1. "),
                          Text.rich(TextSpan(children: [
                            TextSpan(text: "Click the "),
                            TextSpan(text: "Submit", style: ts.fw700),
                            TextSpan(text: " button")
                          ]))),
                      AdvTextWithNumber(
                          Text("2. "),
                          Text(
                              "You will receive a unique account number and instructions on how to pay (you can receive instructions via your email)")),
                      AdvTextWithNumber(
                          Text("3. "),
                          Text(
                              "Please complete payment through the Prima (BCA), ATM Bersama (Mandiri), or Alto (Permata) ATM Network")),
                      AdvTextWithNumber(
                          Text("4. "),
                          Text(
                              "Once payment is complete, you will receive a confirmation email")),
                      AdvButton("Submit", width: double.infinity,
                          onPressed: () {
                            widget
                                .paymentCallback(PaymentType.permataVirtualAccount);
                          })
                    ]));
          }),
      PaymentMethodItem(
          paymentType: PaymentType.mandiriClickPay,
          resetCaller: () {
            mandiriDebitController.text = "";
            mandiriTokenController.text = "";
          },
          builder: (PaymentMethodItem item) {
            String mandiriDebitNumber = (mandiriDebitController.text ?? "");
            String input1 = mandiriDebitNumber.length >= 6
                ? mandiriDebitNumber.substring(6, mandiriDebitNumber.length)
                : "";

            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(
                    divider: ColumnDivider(16.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdvTextField(
                        controller: mandiriDebitController,
                        textChangeListener: (String oldValue, String newValue) {
                          setState(() {});
                        },
                      ),
                      Text(
                        "Input Token",
                        style: ts.fs16.merge(ts.fw700),
                      ),
                      AdvTextWithNumber(Text("APPLI : "), Text("3")),
                      AdvTextWithNumber(Text("Input 1 : "), Text(input1)),
                      AdvTextWithNumber(Text("Input 2 : "), Text(widget.price.toInt().toString())),
                      AdvTextWithNumber(
                          Text("Input 3 : "), Text("$randomNumber")),
                      AdvTextField(
                        controller: mandiriTokenController,
                      ),
                      AdvButton("Submit", width: double.infinity,
                          onPressed: () {
                            String mandiriToken =
                            (mandiriTokenController.text ?? "");
                            widget.paymentCallback(PaymentType.mandiriClickPay,
                                result: {
                                  "mandiriDebitNumber": mandiriDebitNumber,
                                  "input1": input1,
                                  "input2": widget.price.toInt().toString(),
                                  "input3": randomNumber,
                                  "mandiriToken": mandiriToken
                                });
                          })
                    ]));
          }),
      PaymentMethodItem(
          paymentType: PaymentType.mandiriBillPay,
          builder: (PaymentMethodItem item) {
            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(
                    divider: ColumnDivider(16.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mandiri Bill Payment Information :",
                        style: ts.fs16.merge(ts.fw700),
                      ),
                      Text(
                          "Payment can be made through Mandiri ATM or Mandiri Internet Banking"),
                      Text(
                          "Please make a payment as soon as possible - the payment code will expire within 24 hours"),
                      Text(
                          "Minimum transaction using Mandiri ATM is Rp. 50.000 and Mandiri Internet Banking is Rp. 10.000"),
                      Text("Order details will be sent via email"),
                      AdvButton("Submit", width: double.infinity,
                          onPressed: () {
                            widget.paymentCallback(PaymentType.mandiriBillPay);
                          })
                    ]));
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdvExpansionPanelList.radio(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _paymentMethodItem[index].reset();
              _paymentMethodItem[index].isExpanded = !isExpanded;
            });
          },
          children: _paymentMethodItem
              .map<AdvExpansionPanelRadio>((PaymentMethodItem item) {
            return AdvExpansionPanelRadio(
                value: item.paymentType,
                headerBuilder: item.headerBuilder,
                body: item.build());
          }).toList(),
      padding: widget.padding),
    );
  }
}
