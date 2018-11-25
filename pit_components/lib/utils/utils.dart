import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Utils {
  static String getEllipsizedText(String text, TextStyle textStyle, double maxWidth) {
    var tp = new TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: ui.TextDirection.ltr);

    int i = 0;

    for (i = text.length; i > 0; i--) {
      tp.text = TextSpan(text: "${text.substring(0, i)}...", style: textStyle);

      tp.layout();

      if (tp.width <= maxWidth) break;
    }

    return "${text.substring(0, i)}${i == text.length ? "" : "..."}";
  }

  static String stringRepeat(String text, int count) {
    return List.filled(count, text).join();
  }

  static String leadingZeroInt(int value, int count) {
    String stringInt = value.toString();

    return stringInt.length > count ? stringInt : "${stringRepeat("0", count - stringInt.length)}$stringInt";
  }
}