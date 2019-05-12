import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/adv_text_field_plain.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/consts/textstyles.dart';
import 'package:pit_components/pit_components.dart';

class AdvSingleDigitInputter extends StatefulWidget {
  final AdvSingleDigitInputterController controller;
  final int digitCount;
  final bool releaseFocusWhenDone;
  final TextInputType keyboardType;
  final Color labelColor;
  final Color errorColor;
  final EdgeInsets margin;

  @override
  State<StatefulWidget> createState() => _AdvSingleDigitInputter();

  AdvSingleDigitInputter({
    String label,
    String error,
    String text,
    this.digitCount,
    AdvSingleDigitInputterController controller,
    bool releaseFocusWhenDone,
    TextInputType keyboardType,
    Color labelColor,
    Color errorColor,
    EdgeInsetsGeometry margin,
  })  : assert((text == null && label == null && error == null) || controller == null),
        this.controller = controller ?? AdvSingleDigitInputterController(text: text, label: label, error: error),
        this.releaseFocusWhenDone = releaseFocusWhenDone ?? true,
        this.keyboardType = keyboardType ?? TextInputType.text,
        this.errorColor = errorColor ?? PitComponents.textFieldErrorColor,
        this.labelColor = errorColor ?? PitComponents.textFieldLabelColor,
        this.margin = margin ?? PitComponents.editableMargin;
}

class _AdvSingleDigitInputter extends State<AdvSingleDigitInputter> {
  List<FocusNode> focusNodes;
  List<AdvTextFieldController> controllers;

  List<String> values;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(widget.digitCount, (index) => FocusNode()).toList();
    controllers =
        List.generate(widget.digitCount, (index) => AdvTextFieldController(hint: "-", alignment: TextAlign.center)).toList();
    values = List.generate(widget.digitCount, (index) => "").toList();

    widget.controller.addListener(() {
      String text = widget.controller.text;

      for (int i = 0; i < widget.digitCount; i++) {
        if (text.length < i + 1) break;

        values[i] = text.substring(i, i + 1);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = List.generate(widget.digitCount, (index) {
      controllers[index].text = values[index];

      return AdvTextFieldPlain(
        numberAcknowledgeZero: true,
        focusNode: focusNodes[index],
        controller: controllers[index],
        keyboardType: widget.keyboardType,
        measureText: "@",
//        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        textChangeListener: (String oldValue, String newValue) {
          String completeValue = newValue;

          if (newValue.length > 1) {
            newValue = newValue.substring(0, 1);
          }

          if (((newValue != "" && widget.keyboardType == TextInputType.text) ||
                  (newValue != "" && /*int.tryParse(newValue) != 0 &&*/
                      widget.keyboardType == TextInputType.number)) &&
              newValue != null) {
            if (index == focusNodes.length - 1) {
              if (widget.releaseFocusWhenDone) focusNodes[index].unfocus();
            } else {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              controllers[index + 1].selection = TextSelection(baseOffset: 0, extentOffset: 0);
            }
          } else {
            if (oldValue != "" && oldValue != null && index > 0) {
              if (controllers[index - 1].text.isEmpty || controllers[index - 1].text == null) {
                controllers[index - 1].selection = TextSelection(baseOffset: 0, extentOffset: 0);
              } else {
                controllers[index - 1].selection = TextSelection(baseOffset: 1, extentOffset: 1);
              }
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          }

          values[index] = newValue;
          controllers[index].text = newValue;

          //kalo dia copy paste / ketik kecepetan yang mengakibatkan text newvalue itu lebih dr 1 huruf
          if ((oldValue.isEmpty || oldValue == null) && completeValue != newValue && index < focusNodes.length - 1) {
            int remainingNodes = focusNodes.length - 1 - index;
            int remainingCount = remainingNodes.clamp(0, completeValue.length - 1);

            newValue = completeValue.substring(1, remainingCount + 1);

            for (int i = 0; i < newValue.length; i ++) {
              values[index + i + 1] = newValue.substring(i, i+ 1);
              controllers[index + i + 1].text = newValue.substring(i, i+ 1);

              if (i == newValue.length - 1) {
                if (remainingNodes <= completeValue.length - 1) {
                  if (widget.releaseFocusWhenDone) focusNodes[index + 1].unfocus();
                } else {
                  FocusScope.of(context).requestFocus(focusNodes[index + i + 2]);
                  controllers[index + i + 2].selection = TextSelection(baseOffset: 0, extentOffset: 0);
                }
              }
            }
          }

          int count = values.where((s) => s.isEmpty || s == null).length;

          //kalo ada yg blm diisi valuenya, jgn join dulu
          if (count == 0) {
            widget.controller.text = values.join();
          } else {
            widget.controller.text = "";
          }
        },
      );
    }).toList();

    var tp = new TextPainter(text: TextSpan(text: "@mytgL", style: fs11.merge(fw600)), textDirection: ui.TextDirection.ltr);

    tp.layout();

    List<Widget> finalChildren = [
      Container(
          padding: EdgeInsets.only(
              top: widget.controller.label == null ? 0.0 : tp.size.height,
              bottom: widget.controller.error == null ? 0.0 : tp.size.height),
          child: Container(child: AdvRow(divider: RowDivider(16.0), mainAxisSize: MainAxisSize.min, children: children))),
    ];

    if (widget.controller.label != null) {
      finalChildren.add(
        Positioned(
            left: 0.0,
            top: 0.0,
            child: AdvText(
              widget.controller.label,
              style: fs11.merge(TextStyle(color: widget.labelColor)),
              maxLines: 1,
            )),
      );
    }

    if (widget.controller.error != null) {
      finalChildren.add(
        Positioned(
            right: 0.0,
            bottom: 0.0,
            child: AdvText(
              widget.controller.error,
              style: fs11.merge(TextStyle(color: widget.errorColor, fontWeight: fw600.fontWeight)),
              maxLines: 1,
            )),
      );
    }

    return Container(margin: widget.margin, child: Stack(children: finalChildren));
  }
}

class AdvSingleDigitInputterController extends ValueNotifier<AdvSingleDigitInputterEditingValue> {
  String get text => value.text;

  set text(String newText) {
    value = value.copyWith(text: newText, label: this.label, error: this.error);
  }

  String get label => value.label;

  set label(String newLabel) {
    value = value.copyWith(text: this.text, label: newLabel, error: this.error);
  }

  String get error => value.error;

  set error(String newError) {
    value = value.copyWith(text: this.text, label: this.label, error: newError);
  }

  AdvSingleDigitInputterController({String text, String label, String error})
      : super(text == null && label == null && error == null
            ? AdvSingleDigitInputterEditingValue.empty
            : new AdvSingleDigitInputterEditingValue(text: text, label: label, error: error));

  AdvSingleDigitInputterController.fromValue(AdvSingleDigitInputterEditingValue value)
      : super(value ?? AdvSingleDigitInputterEditingValue.empty);

  void clear() {
    value = AdvSingleDigitInputterEditingValue.empty;
  }
}

@immutable
class AdvSingleDigitInputterEditingValue {
  const AdvSingleDigitInputterEditingValue({this.text = '', this.label = '', this.error = ''});

  final String text;
  final String label;
  final String error;

  static const AdvSingleDigitInputterEditingValue empty = const AdvSingleDigitInputterEditingValue();

  AdvSingleDigitInputterEditingValue copyWith({String text, String label, String error}) {
    return new AdvSingleDigitInputterEditingValue(
        text: text, label: label, error: error);
  }

  AdvSingleDigitInputterEditingValue.fromValue(AdvSingleDigitInputterEditingValue copy)
      : this.text = copy.text,
        this.label = copy.label,
        this.error = copy.error;

  @override
  String toString() => '$runtimeType(text: \u2524$text\u251C, label: \u2524$label\u251C, error: \u2524$error\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvSingleDigitInputterEditingValue) return false;
    final AdvSingleDigitInputterEditingValue typedOther = other;
    return typedOther.text == text && typedOther.label == label && typedOther.error == error;
  }

  @override
  int get hashCode => hashValues(text.hashCode, label.hashCode, error.hashCode);
}
