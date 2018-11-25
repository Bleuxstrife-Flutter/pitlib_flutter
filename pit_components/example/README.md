```
   import 'package:flutter/material.dart';
   import 'package:pit_components/components/adv_badge.dart';
   import 'package:pit_components/components/adv_button.dart';
   import 'package:pit_components/components/adv_column.dart';
   import 'package:pit_components/components/adv_date_picker.dart';
   import 'package:pit_components/components/adv_drop_down.dart';
   import 'package:pit_components/components/adv_group_check.dart';
   import 'package:pit_components/components/adv_list_view_with_bottom.dart';
   import 'package:pit_components/components/adv_radio_button.dart';
   import 'package:pit_components/components/adv_range_slider.dart';
   import 'package:pit_components/components/adv_row.dart';
   import 'package:pit_components/components/adv_single_digit_inputter.dart';
   import 'package:pit_components/components/adv_text.dart';
   import 'package:pit_components/components/adv_text_field.dart';
   import 'package:pit_components/components/adv_text_field_controller.dart';
   import 'package:pit_components/components/adv_text_field_plain.dart';
   import 'package:pit_components/components/extras/date_formatter.dart';
   import 'package:pit_components/components/extras/number_thousand_formatter.dart';
   import 'package:pit_components/consts/textstyles.dart' as ts;
   
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
   
     @override
     Widget build(BuildContext context) {
       AdvTextFieldController controller = AdvTextFieldController(
           label: "Just TextField MaxLines 1",
           maxLines: 1,
           text: "00\\00\\0000 ~ 00(00)00®000");
       AdvTextFieldController plainController =
           AdvTextFieldController(label: "Plain TextField");
   
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
   
       return Scaffold(
         appBar: AppBar(
           title: Text(widget.title),
         ),
         body: SingleChildScrollView(
           child: Container(
             color: Color(0xffFFF1CA),
             child: AdvColumn(
               padding: EdgeInsets.symmetric(horizontal: 16.0),
               onlyInner: false,
               divider: ColumnDivider(16.0),
               children: [
                 AdvRow(divider: RowDivider(8.0), children: [
                   Expanded(
                       child: AdvTextField(
                         controller: controller,
                         inputFormatters: [
                           DateTextFormatter("dd\\MM\\yyyy ~ HH(mm)ss®SSS")
                         ],
                       )),
                   Expanded(
                       child: AdvTextFieldPlain(
                         controller: plainController,
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
                   "Go to Another Page",
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
                     visible: _date != null,
                     child: AdvText("You picked date => $_date")),
                 AdvDatePicker(
                   onChanged: (List value) {
                     setState(() {
                       _date = value[0];
                     });
                   },
                   markedDates: [
                     MarkedDate(DateTime(2018, 11, 20),
                         "20th November - Maulid Nabi Muhammad")
                   ],
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
                 AdvRadioGroup(
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
                 AdvBadge(
                   size: 50.0,
                   text: "5,000.00",
                 ),
                 AdvGroupCheck(
                   controller: groupCheckController,
                   callback: (itemSelected) async {},
                 ),
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
```