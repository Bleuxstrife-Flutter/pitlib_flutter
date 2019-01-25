import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_badge.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_chooser_plain.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_drop_down.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_image_preview.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_infinity_list_view.dart';
import 'package:pit_components/components/adv_list_view_with_bottom.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_range_slider.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_scrollable_bottom_sheet.dart';
import 'package:pit_components/components/adv_single_digit_inputter.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/adv_text_field_plain.dart';
import 'package:pit_components/components/adv_text_field_with_button.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/utils/utils.dart';

const String loremIpsum =
    "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. Nature is lethal but it doesn't hold a candle to man.";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIT Components Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PIT Components Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _date;
  String _radioButtonValue = "";
  List<String> possibleValue = [];

  double _lowerValue = 0.0;
  double _upperValue = 100.0;

  @override
  void initState() {
    super.initState();
    possibleValue.add("Possible Value 1");
    possibleValue.add("Possible Value 2");
    incController = AdvIncrementController(
      label: "Increment",
      hint: "Increment",
//      format: "#,### Hari",
      alignment: TextAlign.center,
      minCounter: 0,
      counter: 1,
      /* maxLines: 1 ,
        text: "00\\00\\0000 ~ 00(00)00®000"*/
    );
  }

  Widget _buildRadioButton(Widget icon, String value) {
    return AdvRow(divider: RowDivider(12.0), children: [
      icon,
      Text(value,
          style: ts.fw700.merge(ts.fs12).copyWith(
              color:
                  _radioButtonValue == value ? Colors.black87 : Colors.black38))
    ]);
  }

  AdvIncrementController incController;
  bool _lalala = false;

  bool _first = true;
  @override
  Widget build(BuildContext context) {
    AdvTextFieldController specialController = AdvTextFieldController(
      label: "With Button",
      hint: "Dengan Tombol",
      error: "asdasdasd"
      /* maxLines: 1 ,
        text: "00\\00\\0000 ~ 00(00)00®000"*/
    );
    AdvTextFieldController controller = AdvTextFieldController(
        label: "Just",
        hint: "TextField MaxLines 1 Example",
//        enable: false,
        prefixIcon: Icon(Icons.arrow_back),
        suffixIcon: Icon(Icons.arrow_forward),
        maxLines: 1 /*,
        text: "00\\00\\0000 ~ 00(00)00®000"*/
        );
    AdvTextFieldController controller2 = AdvTextFieldController(
        label: "Just TextField MaxLines 1",
        hint: "TextField MaxLines 1 Example",
        prefixIcon: Container(height: 35.0, width: 35.0, color: Colors.blue),
        suffixIcon: Icon(Icons.arrow_forward),
        maxLines: 1 /*,
        text: "00\\00\\0000 ~ 00(00)00®000"*/
        );
//    AdvTextFieldController plainController = AdvTextFieldController(
//        enable: false,
//        hint: "Plain TextField Example",
//        label: "Plain TextField");

    AdvRadioGroupController radioButtonController = new AdvRadioGroupController(
        checkedValue: _radioButtonValue,
        itemList: possibleValue.map((value) {
          IconData activeIconData;
          IconData inactiveIconData;

          if (value == possibleValue[0]) {
            activeIconData = Icons.cloud;
            inactiveIconData = Icons.cloud_off;
          } else {
            activeIconData = Icons.alarm;
            inactiveIconData = Icons.alarm_off;
          }

          return RadioGroupItem(value,
              activeItem: _buildRadioButton(Icon(activeIconData), value),
              inactiveItem: _buildRadioButton(Icon(inactiveIconData), value));
        }).toList());

    AdvRangeSliderController sliderController = AdvRangeSliderController(
        lowerValue: _lowerValue,
        upperValue: _upperValue,
        min: 0.0,
        max: 100.0,
        divisions: 10,
        hint: "Advanced Slider");

    AdvGroupCheckController groupCheckController = AdvGroupCheckController(
        checkedValue: "",
        itemList: [
          GroupCheckItem('Image', 'Image'),
          GroupCheckItem('Document', 'Document')
        ]);
    controller.error = "asdasd";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffffedd8),
          child: AdvColumn(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            onlyInner: false,
            divider: ColumnDivider(16.0),
            children: [
              AnimatedCrossFade(
                duration: const Duration(seconds: 1),
                firstChild: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
                secondChild: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
                crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              AdvTextField(controller : controller,
              ),
//              PositionedTransition(rect: null, child: null,),
              AdvTextFieldPlain(
//                prefixIcon:
//                Container(child: Icon(Icons.place), color: Colors.green),
//                suffixIcon:
//                Container(child: Icon(Icons.fast_forward), color: Colors.green),
                  ),
              AdvRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  divider: RowDivider(8.0),
                  children: [
                    Expanded(
                      child: AdvDatePicker(
                        textStyle: ts.fs16.copyWith(color: Colors.black),
                        selectionType: SelectionType.multi,
                        onChanged: (List value) {
                          if (value == null || value.length == 0) return;

                          setState(() {
                            _date = value[0];
                          });
                        },
//                markedDates: [
//                  MarkedDate(DateTime(2018, 11, 20),
//                      "20th November - Maulid Nabi Muhammad")
//                ],
                        controller: AdvDatePickerController(
//                    enable: false,
                            label: "Just TextField MaxLines 1",
                            hint: "test",
                            initialValue: _date ?? DateTime.now(),
                            markedDates: [
                              MarkedDate(DateTime.now(), "lalala")
                            ],
                            dates: [
                              _date ?? DateTime.now(),
                              _date ?? DateTime.now()
                            ]),
                      ),
                    ),
                    Expanded(
                      child: AdvIncrement(
                        textStyle: ts.fs16,
                        controller: incController,
                        valueChangeListener: (before, after) {
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: AdvTextFieldWithButton(
                        textStyle: ts.fs16,
                        controller: specialController,
                        buttonName: "Btn",
                        onButtonTapped: () {
                          setState(() {
                            _first = !_first;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
//                Expanded(
//                    child: AdvTextFieldPlain(
//                  controller: plainController,
//                )),
                  ]),
              Container(
                padding: EdgeInsets.all(8.0),
                child: AdvTextFieldWithButton(
//                  textStyle: ts.fs12,
                  controller: specialController,
                  buttonName: "Button",
                  onButtonTapped: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryView()));
                  },
                ),
              ),
//              AdvButton(
//                "Pick From Increment",
//                buttonSize: ButtonSize.small,
//                onPressed: () {
//                  Utils.pickFromIncrement(context,
//                      title: "Pick from Increment",
//                      controller: incController,
//                      infoMessage: "Sewa berakhir pada 12/12/2018 12:40:40");
//                },
//              ),
              AdvRow(divider: RowDivider(8.0), children: [
                Expanded(
                    child: AdvTextField(
                  textStyle: ts.fs10,
                  controller: controller,
                  maxLineExpand: 5,
                  onIconTapped: (iconType) {
                    print("iconType => $iconType");
                  },
                )),
                Expanded(
                    child: AdvTextField(
                  controller: controller2,
                      keyboardType: TextInputType.number,
                      textChangeListener: (oldText, newText) {
                        if (double.tryParse(newText) > 75000.0) {
controller2.text = oldText;
                        }
                      },
                )),
              ]),
              AdvRow(divider: RowDivider(8.0), children: [
                Expanded(child: AdvButton("Normal", enable: false)),
                Expanded(
                    child:
                        AdvButton("Outlined", onlyBorder: true, enable: false)),
                Expanded(
                    child: AdvButton("Reverse", reverse: true, enable: false))
              ]),
              AdvButton(
                "Go to List View with Bottom Button",
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                buttonSize: ButtonSize.small,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnotherPage(),
                        settings:
                            RouteSettings(name: widget.runtimeType.toString())),
                  );
                },
              ),
              AdvRow(divider: RowDivider(8.0), children: [
                Expanded(
                  child: AdvButtonWithIcon(
                    "",
                    Icon(Icons.ring_volume),
                    Axis.vertical,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfinityListDemo(),
                            settings: RouteSettings(
                                name: widget.runtimeType.toString())),
                      );
                    },
                  ),
                ),
                Expanded(
                    child: AdvButtonWithIcon(
                        "", Icon(Icons.airline_seat_flat_angled), Axis.vertical,
                        onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersistentBottomSheetDemo(),
                        settings:
                            RouteSettings(name: widget.runtimeType.toString())),
                  );
                }, onlyBorder: true)),
                Expanded(
                    child: AdvButtonWithIcon(
                        "", Icon(Icons.headset), Axis.vertical, onPressed: () {
                  Utils.pickDate(
                    context,
                    selectionType: SelectionType.range,
                  ).then((dates) {
                    print("dates => $dates");
                  });
                }, reverse: true)),
              ]),
              AdvRow(divider: RowDivider(8.0), children: [
                Expanded(
                  child: AdvButtonWithIcon(
                    "",
                    Icon(Icons.ring_volume),
                    Axis.vertical,
                    enable: false,
                  ),
                ),
                Expanded(
                    child: AdvButtonWithIcon(
                        "", Icon(Icons.airline_seat_flat_angled), Axis.vertical,
                        enable: false, onlyBorder: true)),
                Expanded(
                    child: AdvButtonWithIcon(
                        "", Icon(Icons.headset), Axis.vertical,
                        enable: false, reverse: true)),
              ]),
//              Container(child: AdvText(
//                "1. $loremIpsum, 2. $loremIpsum, 3. $loremIpsum, 4. $loremIpsum, 5. $loremIpsum, 6. $loremIpsum, 7. $loremIpsum, 8. $loremIpsum, 9. $loremIpsum, 10. $loremIpsum 11. $loremIpsum, 12. $loremIpsum, 13. $loremIpsum, 14. $loremIpsum, 15. $loremIpsum, 16. $loremIpsum, 17. $loremIpsum, 18. $loremIpsum, 19. $loremIpsum, 20. $loremIpsum",
////                maxLines: 5,
//              ), height: 1250.0, color: Colors.green),
              Visibility(
                  visible: _date != null,
                  child: AdvText("You picked date => $_date")),
              AdvDatePicker(
                selectionType: SelectionType.single,
                onChanged: (List value) {
                  if (value == null || value.length == 0) return;

                  setState(() {
                    _date = value[0];
                  });
                },
//                markedDates: [
//                  MarkedDate(DateTime(2018, 11, 20),
//                      "20th November - Maulid Nabi Muhammad")
//                ],
                controller: AdvDatePickerController(
//                    enable: false,
                    label: "Just TextField MaxLines 1",
                    hint: "test",
                    initialValue: _date ?? DateTime.now(),
                    markedDates: [MarkedDate(DateTime.now(), "lalala")],
                    dates: [_date ?? DateTime.now(), _date ?? DateTime.now()]),
              ),
              AdvDropDown(
                onChanged: (String value) {},
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
              RoundCheckbox(
                onChanged: (bool value) {
                  setState(() {
                    _lalala = !_lalala;
                  });
                },
                value: _lalala,
              ),
              AdvRadioGroup(
                title: "this is radio Group",
                direction: Axis.vertical,
                controller: radioButtonController,
                divider: 8.0,
                callback: _handleRadioValueChange,
              ),
              AdvRangeSlider(
                controller: sliderController,
                onChanged: (low, high) {
                  setState(() {
                    _lowerValue = low;
                    _upperValue = high;
                  });
                },
              ),
              Container(
                  child: AdvImagePreview(
                    imageProviders: [
                      NetworkImage(
                          "https://i.pinimg.com/originals/0c/48/76/0c4876e490e1e4dc925cc09be057a5a5.jpg"),
                    ],
                  ),
                  height: 250.0),
              AdvBadge(
                size: 50.0,
                text: "5,000.00",
              ),
              AdvGroupCheck(
                controller: groupCheckController,
                callback: (itemSelected) async {},
              ),
              Row(children: [
                Expanded(
                    child: AdvChooser(
                      label: "Chooser Example",
                      hint: "This is chooser example",
                      items: {
                        "data 1": "display 1",
                        "data 2": "display 2",
                        "data 3": "display 3",
                        "data 4": "display 4",
                        "data 5": "display 5",
                        "data 6": "display 6",
                        "data 7": "display 7",
                        "data 8": "display 8",
                        "data 9": "display 9",
                        "data 10": "display 10",
                        "data 11": "display 11",
                        "data 12": "display 12",
                        "data 13": "display 13",
                        "data 14": "display 14",
                        "data 15": "display 15",
                        "data 16": "display 16",
                        "data 17": "display 17",
                        "data 18": "display 18",
                        "data 19": "display 19",
                        "data 20": "display 20",
                        "data 21": "display 21",
                        "data 22": "display 22",
                        "data 23": "display 24 ",
                        "data 24": "display 24",
                        "data 25": "display 25"
                      },
                    ))
              ]),
              Row(children: [
                Expanded(
                    child: AdvChooserPlain(
                      label: "Chooser Example",
                      hint: "This is chooser example",
                      items: {
                        "data 1": "display 1",
                        "data 2": "display 2",
                        "data 3": "display 3",
                        "data 4": "display 4",
                        "data 5": "display 5",
                        "data 6": "display 6",
                        "data 7": "display 7",
                        "data 8": "display 8",
                        "data 9": "display 9",
                        "data 10": "display 10",
                        "data 11": "display 11",
                        "data 12": "display 12",
                        "data 13": "display 13",
                        "data 14": "display 14",
                        "data 15": "display 15",
                        "data 16": "display 16",
                        "data 17": "display 17",
                        "data 18": "display 18",
                        "data 19": "display 19",
                        "data 20": "display 20",
                        "data 21": "display 21",
                        "data 22": "display 22",
                        "data 23": "display 24 ",
                        "data 24": "display 24",
                        "data 25": "display 25"
                      },
                    ))
              ])
            ],
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioButtonValue = value;
    });
  }
}

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Another Page"),
      ),
      body: AdvListViewWithBottom(
        divider: ListViewDivider(
          1.0,
          color: Colors.grey,
        ),
        children: List.generate(100, (index) {
          return Text("Text $index");
        }),
        footerItem: Container(
          alignment: Alignment.center,
          child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: InkWell(
                onTap: () {},
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: AdvRow(
                        divider: RowDivider(4.0),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list,
                              size: 16.0, color: Colors.purple),
                          Text("Filter",
                              style: ts.fs12.copyWith(color: Colors.purple))
                        ])),
              ),
              elevation: 4.0),
          margin: EdgeInsets.only(bottom: 20.0),
        ),
      ),
    );
  }
}

class PersistentBottomSheetDemo extends StatefulWidget {
  static const String routeName = '/material/persistent-bottom-sheet';

  @override
  _PersistentBottomSheetDemoState createState() =>
      _PersistentBottomSheetDemoState();
}

class _PersistentBottomSheetDemoState extends State<PersistentBottomSheetDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _bottomSheetActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _showMessage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('You tapped the floating action button.'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Persistent bottom sheet'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showMessage(context);
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(
            Icons.add,
            semanticLabel: 'Add',
          ),
        ),
        body: Builder(
          builder: (BuildContext context) {
            final ThemeData themeData = Theme.of(context);
            return Center(
                child: RaisedButton(
                    onPressed: _bottomSheetActive
                        ? null
                        : () {
                            setState(() {
                              //disable button
                              _bottomSheetActive = true;
                            });
                            showBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AdvScrollableBottomSheet(
                                    initialHeight: 250.0,
                                    child: Container(
                                        color: Colors.green,
                                        child: Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Column(children: [
                                              Text(
                                                  'This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                          themeData.accentColor,
                                                      fontSize: 24.0)),
                                              Column(
                                                  children: List.generate(100,
                                                      (index) {
                                                return Text("Text $index");
                                              }))
                                            ]))),
                                  );
                                }).closed.whenComplete(() {
                              if (mounted) {
                                setState(() {
                                  // re-enable the button
                                  _bottomSheetActive = false;
                                });
                              }
                            });
                          },
                    child: const Text('SHOW BOTTOM SHEET')));
          },
        ));
  }
}

class InfinityListDemo extends StatefulWidget {
  @override
  _InfinityListDemoState createState() => _InfinityListDemoState();
}

class _InfinityListDemoState extends State<InfinityListDemo> {
  List<int> items = [];

  AdvInfiniteListRemote remote = AdvInfiniteListRemote();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Infinite ListView"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              items = [];

              remote.reset();
            },
          )
        ],
      ),
      body: AdvColumn(children: [
        Text(
            "the data will be fetched 50 per pull, and it will randomly return true (keep fetching data) or false (stop fetching data), so if you have reach to false condition, you will have to refresh it again"),
        Expanded(
            child: AdvInfiniteListView(
          widgetBuilder: _widgetBuilder,
          fetcher: _fetcher,
          remote: remote,
        ))
      ]),
    );
  }

  List<Widget> _widgetBuilder(BuildContext context) {
    return List.generate(
      items.length,
      (index) {
        return Text("Number $index");
      },
    );
  }

  Future<bool> _fetcher(BuildContext context, int cursor) {
    return Future.delayed(Duration(seconds: 2), () {
      print("cursor = $cursor");
      bool isThereAnyMoreData = Random().nextBool();

      items.addAll(List.generate(50, (i) => i));

      return isThereAnyMoreData;
    });
  }

  /// from - inclusive, to - exclusive
  Future<List<int>> fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(to - from, (i) => i + from);
    });
  }
}
