import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/components/adv_text_field_plain.dart';

class AdvSingleDigitInputter extends StatefulWidget {
  final AdvSingleDigitInputterController controller;
  final int digitCount;
  final bool releaseFocusWhenDone;
  final TextInputType keyboardType;

  @override
  State<StatefulWidget> createState() => _AdvSingleDigitInputter();

  AdvSingleDigitInputter(
      {String text,
      this.digitCount,
      AdvSingleDigitInputterController controller,
      bool releaseFocusWhenDone,
      TextInputType keyboardType})
      : assert(text == null || controller == null),
        this.controller =
            controller ?? AdvSingleDigitInputterController(text: text),
        this.releaseFocusWhenDone = releaseFocusWhenDone ?? false,
        this.keyboardType = keyboardType ?? TextInputType.number;
}

class _AdvSingleDigitInputter extends State<AdvSingleDigitInputter> {
  List<FocusNode> focusNodes;
  List<AdvTextFieldController> controllers;

  List<String> values;

  @override
  void initState() {
    super.initState();
    focusNodes =
        List.generate(widget.digitCount, (index) => FocusNode()).toList();
    controllers = List.generate(
            widget.digitCount,
            (index) =>
                AdvTextFieldController(hint: "-", alignment: TextAlign.center))
        .toList();
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
        focusNode: focusNodes[index],
        controller: controllers[index],
        keyboardType: widget.keyboardType,
        measureText: "@",
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        textChangeListener: (String oldValue, String newValue) {
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
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          }

          values[index] = newValue;

          widget.controller.text = values.join();
        },
      );
    }).toList();

    return Container(
        child: AdvRow(
            divider: RowDivider(16.0),
            mainAxisSize: MainAxisSize.min,
            children: children));
  }
}

class AdvSingleDigitInputterController
    extends ValueNotifier<AdvSingleDigitInputterEditingValue> {
  String get text => value.text;

  set text(String newText) {
    value = value.copyWith(text: newText);
  }

  AdvSingleDigitInputterController({String text})
      : super(text == null
            ? AdvSingleDigitInputterEditingValue.empty
            : new AdvSingleDigitInputterEditingValue(text: text));

  AdvSingleDigitInputterController.fromValue(
      AdvSingleDigitInputterEditingValue value)
      : super(value ?? AdvSingleDigitInputterEditingValue.empty);

  void clear() {
    value = AdvSingleDigitInputterEditingValue.empty;
  }
}

@immutable
class AdvSingleDigitInputterEditingValue {
  const AdvSingleDigitInputterEditingValue({this.text = ''});

  final String text;

  static const AdvSingleDigitInputterEditingValue empty =
      const AdvSingleDigitInputterEditingValue();

  AdvSingleDigitInputterEditingValue copyWith({String text}) {
    return new AdvSingleDigitInputterEditingValue(text: text ?? this.text);
  }

  AdvSingleDigitInputterEditingValue.fromValue(
      AdvSingleDigitInputterEditingValue copy)
      : this.text = copy.text;

  @override
  String toString() => '$runtimeType(text: \u2524$text\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvSingleDigitInputterEditingValue) return false;
    final AdvSingleDigitInputterEditingValue typedOther = other;
    return typedOther.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}
