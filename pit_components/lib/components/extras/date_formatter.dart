import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/utils/utils.dart';

class DateTextFormatter extends TextInputFormatter {
  final String format;

  DateTextFormatter(this.format);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    return _getDateTime(oldValue, newValue, format);
  }

  TextEditingValue _getDateTime(
      TextEditingValue oldValue, TextEditingValue newValue, String format) {
    String invalidChars = format.replaceAll(RegExp(r'[dMyhHmsS]'), "");

    String fixedInvalidChars = "";

    for (int i = 0; i < invalidChars.length; i++) {
      fixedInvalidChars += "\\${invalidChars.substring(i, i + 1)}";
    }

    String text =
    newValue.text.replaceAll(RegExp(r'[' + fixedInvalidChars + ']'), "");
    String newValueText = newValue.text;
    String cleanNewValueText =
    newValue.text.replaceAll(RegExp(r'[' + fixedInvalidChars + ']'), "");
    String cleanOldValueText =
    oldValue.text.replaceAll(RegExp(r'[' + fixedInvalidChars + ']'), "");
    TextEditingValue result = newValue.copyWith(text: text);
    String cleanFormat =
    format.replaceAll(RegExp(r'[' + fixedInvalidChars + ']'), "");
    int newSelectionStart = newValue.selection.start;
    int oldSelectionStart = oldValue.selection.start;
    int oldSelectionEnd = oldValue.selection.end;
    int selectionOffset = 0;
    int newCleanSelectionStart = newSelectionStart;

    if (oldSelectionStart < newSelectionStart) {
      int invalidCharIndex =
      format.indexOf(RegExp(r'[' + fixedInvalidChars + ']'), oldSelectionStart);

      while (invalidCharIndex == oldSelectionStart) {
        selectionOffset++;
        oldSelectionStart++;
        invalidCharIndex = format.indexOf(
            RegExp(r'[' + fixedInvalidChars + ']'), oldSelectionStart);
      }
    }

    //at first, i want this if to be called when user block text inside text field and delete it or replace it with new value
    //at first, it should be oldSelectionStart != oldSelectionEnd, but somehow there's a value when oldSelectionStart > oldSelectionEnd, and it's not blocking text
    //if happens when i type `@@12!!34+5678` => `@@12!!346+5678` => `@@12!!34+6678`
    //somehow its oldSelectionStart is 9 and oldSelectionEnd is 8
    //so i change this if to this, to make sure it's for blocking (@@12[!!346+]5678)
    if (oldSelectionStart < oldSelectionEnd) {
      if (cleanNewValueText.length < cleanOldValueText.length) {
        int newSelectionOffset = RegExp(r'[' + fixedInvalidChars + ']')
            .allMatches(newValueText.substring(0, newCleanSelectionStart))
            .toList()
            .length;

        newCleanSelectionStart -= newSelectionOffset;
        int missingCharacters =
            cleanOldValueText.length - cleanNewValueText.length;

        result = result.copyWith(
            text:
            "${cleanNewValueText.substring(0, newCleanSelectionStart)}${Utils.stringRepeat("0", missingCharacters)}${cleanNewValueText.substring(newCleanSelectionStart, cleanNewValueText.length)}");
      }
    } else {
      int newSelectionOffset = RegExp(r'[' + fixedInvalidChars + ']')
          .allMatches(newValueText.substring(0, newCleanSelectionStart))
          .toList()
          .length;

      newCleanSelectionStart -= newSelectionOffset;

      if (cleanNewValueText.length > cleanOldValueText.length) {
        result = result.copyWith(
            text:
            "${text.substring(0, newCleanSelectionStart)}${text.substring(text.length > newCleanSelectionStart + 1 ? newCleanSelectionStart + 1 : text.length, text.length)}");
      } else if (cleanNewValueText.length < cleanOldValueText.length) {
        result = result.copyWith(
            text:
            "${text.substring(0, newCleanSelectionStart)}0${text.substring(newCleanSelectionStart, text.length)}");
      }
    }

    String stringResult = format;
    String cleanValue = result.text;

    int month = _getDatePart("M", cleanValue, cleanFormat);

    if (month > 12 && month % 10 == 0) {
      month = month ~/ 10;

      selectionOffset++;
    } else if (month > 12 && month % 10 != 0) {
      return oldValue;
    }

    stringResult = _replaceDatePart("M", month, cleanFormat, stringResult);

    int year = _getDatePart("y", cleanValue, cleanFormat);
    stringResult = _replaceDatePart("y", year, cleanFormat, stringResult);

    int day = _getDatePart("d", cleanValue, cleanFormat);

    int maxDays = month == 2
        ? year % 4 == 0 ? 29 : 28
        : month == 4 || month == 6 || month == 9 || month == 11 ? 30 : 31;

    if (day > maxDays && day % 10 == 0) {
      day = day ~/ 10;

      selectionOffset++;
    } else if (day > maxDays && day % 10 != 0) {
      return oldValue;
    }

    stringResult = _replaceDatePart("d", day, cleanFormat, stringResult);

    String hourPart = format.indexOf("H") == -1 ? "h" : "H";

    int hour = _getDatePart(hourPart, cleanValue, cleanFormat);

    int maxHour = format.indexOf("H") == -1 ? 12 : 23;

    if (hour > maxHour && hour % 10 == 0) {
      hour = hour ~/ 10;

      selectionOffset++;
    } else if (hour > maxHour && hour % 10 != 0) {
      return oldValue;
    }

    stringResult = _replaceDatePart(hourPart, hour, cleanFormat, stringResult);

    int minute = _getDatePart("m", cleanValue, cleanFormat);

    if (minute > 59 && minute % 10 == 0) {
      minute = minute ~/ 10;

      selectionOffset++;
    } else if (minute > 59 && minute % 10 != 0) {
      return oldValue;
    }

    stringResult = _replaceDatePart("m", minute, cleanFormat, stringResult);

    int second = _getDatePart("s", cleanValue, cleanFormat);

    if (second > 59 && second % 10 == 0) {
      second = second ~/ 10;

      selectionOffset++;
    } else if (second > 59 && second % 10 != 0) {
      return oldValue;
    }

    stringResult = _replaceDatePart("s", second, cleanFormat, stringResult);

    int fractionalSecond = _getDatePart("S", cleanValue, cleanFormat);

    if (fractionalSecond > 999 && fractionalSecond % 10 == 0) {
      fractionalSecond = fractionalSecond ~/ 10;

      selectionOffset++;
    } else if (fractionalSecond > 999 && fractionalSecond % 10 != 0) {
      return oldValue;
    }
    stringResult =
        _replaceDatePart("S", fractionalSecond, cleanFormat, stringResult);

    return result.copyWith(
        text: stringResult,
        selection: TextSelection(
            baseOffset: newValue.selection.start + selectionOffset,
            extentOffset: newValue.selection.end + selectionOffset));
  }

  String _replaceDatePart(
      String part, int partValue, String cleanFormat, String result) {
    int datePartLength = _getDatePartLength(part, cleanFormat);

    if (datePartLength == -1) return result;

    String currentPart = Utils.stringRepeat(part, datePartLength);

    String partValueString = partValue.toString();
    if (partValueString.length < datePartLength)
      partValueString =
      "${Utils.stringRepeat("0", datePartLength - partValueString.length)}$partValueString";

    return result.replaceAll(currentPart, partValueString);
  }

  int _getDatePart(String part, String cleanValue, String cleanFormat) {
    int datePart = 0;
    int datePartIndex = -1;
    int datePartLength = _getDatePartLength(part, cleanFormat);

    if (datePartLength == -1) return datePart;

    String currentPart = Utils.stringRepeat(part, datePartLength);

    if (cleanFormat.indexOf(currentPart) != -1) {
      datePartIndex = cleanFormat.indexOf(currentPart);
    }

    if (datePartIndex != -1) {
      datePart = int.tryParse(cleanValue.substring(
          datePartIndex, datePartIndex + datePartLength)) ??
          0;
    }

    return datePart;
  }

  int _getDatePartLength(String part, String cleanFormat) {
    int datePartLength = -1;
    int partMaxLength = 0;

    switch (part) {
      case "S":
        partMaxLength = 3;
        break;
      case "s":
        partMaxLength = 2;
        break;
      case "m":
        partMaxLength = 2;
        break;
      case "H":
        partMaxLength = 2;
        break;
      case "h":
        partMaxLength = 2;
        break;
      case "y":
        partMaxLength = 4;
        break;
      case "M":
        partMaxLength = 2;
        break;
      case "d":
        partMaxLength = 2;
        break;
    }

    for (int i = partMaxLength; i > 0; i--) {
      String currentPart = Utils.stringRepeat(part, i);

      if (cleanFormat.indexOf(currentPart) != -1) {
        datePartLength = i;
        break;
      }
    }

    return datePartLength;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
