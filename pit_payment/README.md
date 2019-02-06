# Payment Interface by PIT

Our custom Payment Interface

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.
- This Interface is supported by one of Indonesia's Payment Gateway vendor [Midtrans](midtrans github)

## Installation

First, add `pit_payment` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_payment: ^0.1.0
```

## Example
```
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
        appBar: AppBar(
          title: const Text('Pit Payment Demo'),
        ),
        body: SingleChildScrollView(
          child: PitPayment(100000.0, (type, {result}) {
            print("I got payment : $type, $result");
          }),
        ),
      ),
    );
  }
}
```
