import 'package:flutter/material.dart';
import 'package:pit_payment/pit_payment.dart';

void main() => runApp(PitPaymentDemo());

class PitPaymentDemo extends StatefulWidget {
  @override
  _PitPaymentDemoState createState() => _PitPaymentDemoState();
}

class _PitPaymentDemoState extends State<PitPaymentDemo> {
  @override
  Widget build(BuildContext context) {
    InkWell();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pit Payment Demo'),
        ),
        body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: PitPayment(100000.0, (type, {result}) {
                print("I got payment : $type, $result");
              }, locale: Locale("id"),),
            )),
      ),
    );
  }
}
