import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/extras/com_date_picker_page.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';

typedef String InfoMessageGenerator(int counter);

class Utils {
  static String getEllipsizedText(String text, TextStyle textStyle, double maxWidth,
      {bool withDot = true, bool wholeWord = true}) {
    if (maxWidth == null) return text;

    var tp = new TextPainter(
        text: TextSpan(text: text, style: textStyle), textDirection: ui.TextDirection.ltr);
    tp.layout();

    double wholeWidth = tp.width;

    if (wholeWidth <= maxWidth) return text;

    int startPositionPercentage = (maxWidth / wholeWidth * 100).ceil().clamp(0, 100);
    int startPosition = (startPositionPercentage * text.length / 100).ceil().clamp(0, text.length);

    tp.text = TextSpan(
        text: "${text.substring(0, startPosition)}${withDot ? "\u2026" : ""}", style: textStyle);

    tp.layout();

    int i = 0;

    if (tp.width > maxWidth) {
      for (i = startPosition; i > 0; i--) {
        tp.text =
            TextSpan(text: "${text.substring(0, i)}${withDot ? "\u2026" : ""}", style: textStyle);

        tp.layout();

        if (tp.width <= maxWidth) break;
      }
    } else if (tp.width < maxWidth) {
      for (i = startPosition; i < text.length; i++) {
        tp.text =
            TextSpan(text: "${text.substring(0, i)}${withDot ? "\u2026" : ""}", style: textStyle);

        tp.layout();

        if (tp.width <= maxWidth) break;
      }
    } else {
      i = startPosition;
    }

    if (wholeWord) {
      String croppedText = text.substring(0, i);

      int lastIndex = croppedText.lastIndexOf(" ");
      i = lastIndex == -1 ? i : lastIndex;
    }

    return "${text.substring(0, i)}${i == text.length ? "" : "${withDot ? "\u2026" : ""}"}";
  }

  static String stringRepeat(String text, int count) {
    return List.filled(count, text).join();
  }

  static String leadingZeroInt(int value, int count) {
    String stringInt = value.toString();

    return stringInt.length > count
        ? stringInt
        : "${stringRepeat("0", count - stringInt.length)}$stringInt";
  }

  static parseStringToTextSpan(String fullString, List<String> findString) {
    String stringWithSmallestIndex =
        findWordWithSmallestIndex(fullString, findString, startFindFrom: 0);
    int index = fullString.indexOf(stringWithSmallestIndex);
    int startCropFrom = 0;
    List<TextSpan> textSpans = [];

    while (index != -1) {
      String croppedString = fullString.substring(startCropFrom, index);
      startCropFrom = index + stringWithSmallestIndex.length;

      textSpans.add(TextSpan(text: croppedString));
      textSpans.add(TextSpan(text: stringWithSmallestIndex));

      index++;

      if (index > fullString.length) break;

      stringWithSmallestIndex =
          findWordWithSmallestIndex(fullString, findString, startFindFrom: index);

      index = fullString.indexOf(stringWithSmallestIndex, index);
    }

    String croppedString = fullString.substring(startCropFrom, fullString.length);
    textSpans.add(TextSpan(text: croppedString));

    return textSpans;
  }

  static findWordWithSmallestIndex(String fullString, List<String> findString,
      {int startFindFrom}) {
    int tempSmallestIndex;
    int tempIndex;
    String wordWithSmallestIndex;
    int i = 0;

    while (i < findString.length) {
      tempIndex = fullString.indexOf(findString[i], startFindFrom);
      if (tempIndex == -1) {
        i++;
        continue;
      }
      wordWithSmallestIndex = tempSmallestIndex == null
          ? findString[i]
          : tempSmallestIndex < tempIndex ? wordWithSmallestIndex : findString[i];
      tempSmallestIndex = tempSmallestIndex == null
          ? tempIndex
          : tempSmallestIndex < tempIndex ? tempSmallestIndex : tempIndex;
      i++;
    }
    return wordWithSmallestIndex ?? findString[0];
  }

  static Future<List<DateTime>> pickDate(
    BuildContext context, {
    String title,
    List<DateTime> dates,
    List<MarkedDate> markedDates,
    SelectionType selectionType,
    DateTime minDate,
    DateTime maxDate,
  }) async {
    List<DateTime> result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return ComDatePickerPage(
            title: title,
            currentDate: dates ?? const [],
            markedDates: markedDates ?? const [],
            selectionType: selectionType ?? SelectionType.single,
            minDate: minDate,
            maxDate: maxDate,
          );
        },
        transitionsBuilder: (context, animation1, animation2, child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation1),
            child: child,
          );
        },
        settings: RouteSettings(name: "ComDatePickerPage"),
      ),
    );

    return result;
  }

  static pickFromChooser(BuildContext context,
      {String title = "",
      List<GroupCheckItem> items,
      String currentItem = "",
      OnItemChanged callback}) {
    assert(items != null);

//    List<GroupCheckItem> itemList = items.keys.map((key) {
//      return GroupCheckItem(key, items[key]);
//    }).toList();

    AdvGroupCheckController controller =
        AdvGroupCheckController(checkedValue: currentItem, itemList: items);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdvListTile(
                padding: EdgeInsets.all(16.0),
                start: Icon(Icons.close),
                expanded: Text(title, style: ts.fs18.merge(ts.fw700)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(height: 2.0, color: Theme.of(context).dividerColor),
              Flexible(
                  child: SingleChildScrollView(
                      child: AdvGroupCheck(
                controller: controller,
                callback: (itemSelected) async {
                  Navigator.of(context).pop();
                  callback(context, currentItem, itemSelected);
                },
              )))
            ],
          );
        });
  }

  static pickFromIncrement(BuildContext context,
      {AdvIncrementController controller,
      InfoMessageGenerator infoMessageGenerator,
      OnValueChanged callback}) async {
    int firstValue = controller.counter;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {},
              child: AdvColumn(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdvListTile(
                    padding: EdgeInsets.all(16.0),
                    start: Icon(Icons.close),
                    expanded: Text(controller.label ?? "", style: ts.fs18.merge(ts.fw700)),
                    onTap: () {
//                  Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: 2.0,
                    color: Theme.of(context).dividerColor,
                    margin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: AdvColumn(
                        children: <Widget>[
                          IncrementWithText(
                            controller: controller,
                            infoMessageGenerator: infoMessageGenerator,
                          ),
                          Container(
                            margin: EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width,
                            child: AdvButton(
                              PitComponents.incrementPickerButtonName,
                              onPressed: () async {
//                                controller.error = "lalala";
                                if (callback != null) {
                                  bool valid = callback(firstValue, controller.counter) ?? true;

                                  if (valid) Navigator.of(context).pop();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}

class IncrementWithText extends StatefulWidget {
  final AdvIncrementController controller;
  final InfoMessageGenerator infoMessageGenerator;

  IncrementWithText({this.controller, this.infoMessageGenerator});

  @override
  _IncrementWithTextState createState() => _IncrementWithTextState();
}

class _IncrementWithTextState extends State<IncrementWithText> {
  String infoMessage;

  @override
  void initState() {
    super.initState();
    infoMessage = widget.infoMessageGenerator(widget.controller.counter ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return AdvColumn(
      divider: ColumnDivider(4.0),
      margin: EdgeInsets.all(16.0),
      children: <Widget>[
        Center(
          child: AdvIncrement(
            controller: widget.controller,
            valueChangeListener: (before, after) {
              after = after;
              setState(() {
                infoMessage = widget.infoMessageGenerator(after ?? 0);
              });
            },
          ),
        ),
        widget.infoMessageGenerator == null
            ? null
            : Text(
                infoMessage,
                textAlign: TextAlign.center,
                style: ts.fs14.merge(ts.tcBlack54),
              ),
      ],
    );
  }
}
