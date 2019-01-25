import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberThousandFormatter extends TextInputFormatter {
  final String thousandSeparator;
  final String decimalSeparator;

  NumberThousandFormatter(this.thousandSeparator, this.decimalSeparator);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _format(oldValue, newValue);
  }

  TextEditingValue _format(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueText = newValue.text.replaceAll(",", "");
    String oldValueText = oldValue.text;
    String nonDecimalOldText = "";

    if (oldValueText.indexOf(".") != -1) {
      nonDecimalOldText = oldValueText.substring(0, oldValueText.indexOf("."));
    } else {
      nonDecimalOldText = (int.tryParse(oldValueText.substring(0, oldValueText.length)) ?? 0 ~/ 100).toString();
    }

    String nonDecimalNewText = "";
    String decimalNewText = "00";

    if (newValueText.indexOf(".") != -1) {
      nonDecimalNewText = newValueText.substring(0, newValueText.indexOf("."));
      decimalNewText = newValueText.substring(newValueText.indexOf("."), newValueText.length).replaceAll(".", "");
    } else {
      nonDecimalNewText = newValueText.substring(0, newValueText.length);
    }

    newValueText = "$nonDecimalNewText.$decimalNewText";

    if (nonDecimalNewText.length > 16) return oldValue;

    num value = double.tryParse(newValueText) ?? 0;

    NumberFormat nf = NumberFormat("#,###.00");

    newValueText = nf.format(value);


    if (newValueText.indexOf(".") != -1) {
      nonDecimalNewText = newValueText.substring(0, newValueText.indexOf("."));
    } else {
      nonDecimalNewText = newValueText.substring(0, newValueText.length);
    }

    int commaMatchesOnNew =
        RegExp(r'[' + "\," + ']').allMatches(nonDecimalNewText).toList().length;

    int commaMatchesOnOld =
        RegExp(r'[' + "\," + ']').allMatches(nonDecimalOldText).toList().length;

    int selectionOffset = commaMatchesOnNew - commaMatchesOnOld;

    TextSelection newSelection = newValue.selection;

    if (newSelection.start == newSelection.end && selectionOffset != 0) {
      newSelection = TextSelection(
          baseOffset: newValue.selection.start + selectionOffset,
          extentOffset: newValue.selection.end + selectionOffset);
    }


    return newValue.copyWith(
        text: newValueText,
        selection: newSelection);
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
