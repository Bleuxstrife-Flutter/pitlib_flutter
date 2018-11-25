# Components by PIT

A bundle that contains our custom components, mostly just override the default Flutter widgets and custom its style and some of its functional.

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.
- The date picker components inspired by [flutter_calendar_carousel](https://pub.dartlang.org/packages/flutter_calendar_carousel#-readme-tab-), I clone it and override some of its functional and add selection types (single, multi or range)

## Installation

First, add `pit_components` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_components: ^0.0.10
```

## Example
```
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DateTime date;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdvTextFieldController controller =
        AdvTextFieldController(label: "Just TextField MaxLines 1", maxLines: 1);
    AdvTextFieldController plainController =
        AdvTextFieldController(label: "Plain TextField");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Color(0xffFFF1CA),
        child: AdvColumn(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          onlyInner: false,
          divider: ColumnDivider(16.0),
          children: [
            AdvRow(divider: RowDivider(8.0), children: [
              Expanded(child: AdvTextField(controller: controller)),
              Expanded(child: AdvTextFieldPlain(controller: plainController)),
            ]),
            AdvRow(divider: RowDivider(8.0), children: [
              Expanded(child: AdvButton("Normal", enable: false)),
              Expanded(
                  child:
                      AdvButton("Outlined", onlyBorder: true, enable: false)),
              Expanded(
                  child: AdvButton("Reverse", reverse: true, enable: false))
            ]),
            AdvButton("Small",
                width: double.infinity, buttonSize: ButtonSize.small),
            AdvRow(divider: RowDivider(8.0), children: [
              Expanded(
                child: AdvButtonWithIcon(
                    "", Icon(Icons.ring_volume), Axis.vertical),
              ),
              Expanded(
                  child: AdvButtonWithIcon(
                      "", Icon(Icons.airline_seat_flat_angled), Axis.vertical,
                      onPressed: () {}, onlyBorder: true)),
              Expanded(
                  child: AdvButtonWithIcon(
                      "", Icon(Icons.headset), Axis.vertical,
                      onPressed: () {}, reverse: true)),
            ]),
            Visibility(
                visible: date != null,
                child: AdvText("You picked date => $date")),
            AdvDatePicker(
              onChanged: (List value) {
                setState(() {
                  date = value[0];
                });
              },
              markedDates: [
                MarkedDate(DateTime(2018, 11, 20),
                    "20th November - Maulid Nabi Muhammad")
              ],
            ),
            AdvDropDown(
              onChanged: (String value) {
              },
              items: {
                "data 1": "display 1",
                "data 2": "display 2",
                "data 3": "display 3"
              },
            ),
            AdvSingleDigitInputter(
              text: "12345",
              digitCount: 5,
            ),
          ],
        ),
      ),
    );
  }
}
```
