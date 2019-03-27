import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_expansion_panel.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/adv_text_with_number.dart';
import 'package:pit_components/components/adv_visibility.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/components/extras/date_formatter.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/utils/utils.dart';
import 'package:pit_payment/localization.dart';

//class PitPayment {
//

//}

typedef PaymentBodyBuilder = Widget Function(BuildContext context);
typedef ResetCaller = void Function();
typedef PaymentCallback = void Function(PaymentType paymentType, {dynamic result});

enum PaymentType {
  bankTransfer,
  creditCard,
  permataVirtualAccount,
  mandiriClickPay,
  mandiriBillPay,
}

const Map<PaymentType, String> displayValues = {
  PaymentType.creditCard: "Credit Card",
  PaymentType.bankTransfer: "Bank Transfer",
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

  Widget build(BuildContext context) => builder != null ? builder(context) : () {};

  void reset() => resetCaller != null ? resetCaller() : () {};
}

const MethodChannel _channel = const MethodChannel('pit_payment');

class PitPayment extends StatefulWidget {
  final num price;
  final PaymentCallback paymentCallback;
  final EdgeInsetsGeometry padding;
  final Locale locale;

  static Color expansionPanelRadioColor = Colors.blue;
  static Color expansionPanelBackgroundColor = Color(0xffF4FAFE);
  static Color expansionPanelButtonColor = Colors.blue;
  static String bcaAccountNumber = "123 456 7890";
  static String bcaAccountName = "Mr. BCA";
  static String bcaAccountBranch = "Central BCA";
  static String mandiriAccountNumber = "123-45-6789012-3";
  static String mandiriAccountName = "Mr. Mandiri";
  static String mandiriAccountBranch = "Central Mandiri";

  PitPayment(this.price, this.paymentCallback, {this.padding, Locale locale}) : this.locale = locale ?? Locale("en");

  @override
  _PitPaymentState createState() => _PitPaymentState();
}

class CreditCardDetail {
  final String creditCardNumber;
  final int expiryMonth;
  final int expiryYear;
  final int cvv;
  final double amount;

  CreditCardDetail(this.creditCardNumber, this.expiryMonth, this.expiryYear, this.cvv, this.amount);

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
  Dict dict;
  List<PaymentMethodItem> _paymentMethodItem;
  AdvTextFieldController creditCardController =
  AdvTextFieldController(maxLength: 16, maxLengthEnforced: true);
  AdvTextFieldController cvvController = AdvTextFieldController(maxLength: 3, maxLengthEnforced: true);
  AdvTextFieldController expiryDateController = AdvTextFieldController(text: "00/0000");

  AdvTextFieldController mandiriDebitController = AdvTextFieldController(
      maxLength: 16, maxLengthEnforced: true);
  AdvTextFieldController mandiriTokenController = AdvTextFieldController(label: "Challenge Token");
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

    dict = Dict(widget.locale);
    PitComponents.expansionPanelRadioColor = PitPayment.expansionPanelRadioColor;
    PitComponents.buttonBackgroundColor = PitPayment.expansionPanelButtonColor;

    creditCardController.hint = dict.getString("credit_card_number");
    cvvController.hint = dict.getString("cvv_number");
    mandiriDebitController.hint = dict.getString("mandiri_debit_card_number");
    mandiriDebitController.label = dict.getString("mandiri_debit_card_number");
    mandiriTokenController.hint = dict.getString("your_security_code");

    randomNumber = _randomNumber().toString();
    _paymentMethodItem = <PaymentMethodItem>[
      PaymentMethodItem(
        paymentType: PaymentType.creditCard,
        resetCaller: () {
          creditCardController.text = "";
          cvvController.text = "";
          expiryDateController.text = "00/0000";
        },
        builder: (BuildContext context) {
          return Container(
              color: PitPayment.expansionPanelBackgroundColor,
              padding: EdgeInsets.all(32.0),
              child: AdvColumn(divider: ColumnDivider(8.0), children: [
                AdvTextField(controller: creditCardController),
                AdvTextField(controller: cvvController),
                AdvTextField(controller: expiryDateController, inputFormatters: [DateTextFormatter("MM/yyyy")]),
                AdvButton(
                  dict.getString("submit"),
                  width: double.infinity,
                  onPressed: () {
                    String creditCard = creditCardController.text;
                    String expiryDateString = expiryDateController.text;
                    int cvv = int.tryParse(cvvController.text ?? "");
                    DateFormat df = DateFormat("MM/yyyy");
                    DateTime expiryDate = df.parse(expiryDateString);

                    _channel.invokeMethod('generateCreditCardToken', {
                      "creditCard": CreditCardDetail(creditCard, expiryDate.month, expiryDate.year, cvv, widget.price).toMap()
                    }).then((result) {
                      print("result = $result!");
                      setState(() {
                        if (result.substring(0, 5) == "error") {
                          _creditCardResult = result;
                        } else {
                          _creditCardResult = "";
                          print("sukses $result!");
                          widget.paymentCallback(PaymentType.creditCard, result: result.replaceAll("ccToken: ", ""));
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
                  visibility: _creditCardResult == "" ? VisibilityFlag.gone : VisibilityFlag.visible,
                ),
              ]));
        },
      ),
      PaymentMethodItem(
          paymentType: PaymentType.bankTransfer,
          builder: (BuildContext context) {
            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(divider: ColumnDivider(16.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AdvRow(divider: RowDivider(16.0), children: [
                    Container(
                      child: Image.asset(
                        "images/ic_logo_bca.png",
                        width: 90.0,
                        alignment: Alignment.centerLeft,
                        package: "pit_payment",
                      ),
                      padding: EdgeInsets.all(16.0),
                    ),
                    Expanded(
                        child: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(PitPayment.bcaAccountNumber, style: ts.fw600),
                          Text(PitPayment.bcaAccountName, style: ts.fw600),
                          Text(PitPayment.bcaAccountBranch, style: ts.fw600)
                        ]))
                  ]),
                  AdvRow(divider: RowDivider(16.0), children: [
                    Container(
                      child: Image.asset(
                        "images/ic_logo_mandiri.png",
                        width: 90.0,
                        alignment: Alignment.centerLeft,
                        package: "pit_payment",
                      ),
                      padding: EdgeInsets.all(16.0),
                    ),
                    Expanded(
                        child: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(PitPayment.mandiriAccountNumber, style: ts.fw600),
                          Text(PitPayment.mandiriAccountName, style: ts.fw600),
                          Text(PitPayment.mandiriAccountBranch, style: ts.fw600)
                        ]))
                  ]),
                  AdvButton(dict.getString("submit"), width: double.infinity, onPressed: () {
                    widget.paymentCallback(PaymentType.bankTransfer);
                  })
                ]));
          }),
      PaymentMethodItem(
          paymentType: PaymentType.permataVirtualAccount,
          builder: (BuildContext context) {
            List<TextSpan> textSpans =
            Utils.parseStringToTextSpan(dict.getString("permata_va_content_1"), [dict.getString("submit")]);

            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(divider: ColumnDivider(16.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    dict.getString("permata_va_title"),
                    style: ts.fs16.merge(ts.fw700),
                  ),
                  AdvTextWithNumber(
                      Text("1. "),
                      Text.rich(TextSpan(
                          children: textSpans.map((TextSpan textSpan) {
                            return TextSpan(
                                text: textSpan.text,
                                style: TextStyle(
                                    fontWeight: textSpan.text == dict.getString("submit") ? FontWeight.w700 : FontWeight.w400));
                          }).toList()))),
                  AdvTextWithNumber(Text("2. "), Text(dict.getString("permata_va_content_2"))),
                  AdvTextWithNumber(Text("3. "), Text(dict.getString("permata_va_content_3"))),
                  AdvTextWithNumber(Text("4. "), Text(dict.getString("permata_va_content_4"))),
                  AdvButton(dict.getString("submit"), width: double.infinity, onPressed: () {
                    widget.paymentCallback(PaymentType.permataVirtualAccount);
                  })
                ]));
          }),
      PaymentMethodItem(
          paymentType: PaymentType.mandiriClickPay,
          resetCaller: () {
            mandiriDebitController.text = "";
            mandiriTokenController.text = "";
          },
          builder: (BuildContext context) {
            String mandiriDebitNumber = (mandiriDebitController.text ?? "");
            String input1 = mandiriDebitNumber.length >= 6 ? mandiriDebitNumber.substring(6, mandiriDebitNumber.length) : "";

            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(divider: ColumnDivider(16.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  AdvTextWithNumber(Text("Input 3 : "), Text("$randomNumber")),
                  AdvTextField(
                    controller: mandiriTokenController,
                  ),
                  AdvButton(dict.getString("submit"), width: double.infinity, onPressed: () {
                    String mandiriToken = (mandiriTokenController.text ?? "");
                    widget.paymentCallback(PaymentType.mandiriClickPay, result: {
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
          builder: (BuildContext context) {
            return Container(
                color: PitPayment.expansionPanelBackgroundColor,
                padding: EdgeInsets.all(32.0),
                child: AdvColumn(divider: ColumnDivider(16.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(dict.getString("mandiri_bill_title"), style: ts.fs16.merge(ts.fw700)),
                  Text(dict.getString("mandiri_bill_content_1")),
                  Text(dict.getString("mandiri_bill_content_2")),
                  Text(dict.getString("mandiri_bill_content_3")),
                  Text(dict.getString("mandiri_bill_content_4")),
                  AdvButton(dict.getString("submit"), width: double.infinity, onPressed: () {
                    widget.paymentCallback(PaymentType.mandiriBillPay);
                  })
                ]));
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AdvColumn(children: [
          AdvExpansionPanelList.radio(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _paymentMethodItem[index].reset();
                  _paymentMethodItem[index].isExpanded = !isExpanded;
                });
              },
              children: _paymentMethodItem.map<AdvExpansionPanelRadio>((PaymentMethodItem item) {
                return AdvExpansionPanelRadio(
                    value: item.paymentType, headerBuilder: item.headerBuilder, body: item.build(context));
              }).toList()),
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 32.0),
              child: AdvRow(children: [
                Expanded(
                  child: AdvRow(
                    divider: RowDivider(8.0),
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.lightBlueAccent,
                      ),
                      Text("100% Secured Transaction"),
                    ],
                  ),
                ),
                Image.asset(
                  "images/geotrust.png",
                  width: 90.0,
                  alignment: Alignment.centerLeft,
                  package: "pit_payment",
                )
              ]))
        ]),
        padding: widget.padding);
  }

  void onLocaleChange(Locale locale) {
    setState(() {});
  }
}
