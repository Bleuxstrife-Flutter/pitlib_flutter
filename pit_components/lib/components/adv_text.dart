import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pit_components/utils/utils.dart';

class AdvText extends StatelessWidget {
  final String data;
  final Key key;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;

  AdvText(
    this.data, {
    this.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;
        String _text = this.data;
        String _data = "";
        int _maxLines = maxLines;
        if (_maxLines == null) {
          if (maxHeight == null) {
            _data = this.data;
          } else {
            var tpMeasureHeight = new TextPainter(
                text: TextSpan(text: "|", style: this.style),
                textDirection: ui.TextDirection.ltr);
            tpMeasureHeight.layout();

            _maxLines = (maxHeight / tpMeasureHeight.height).floor();

            _data = _getEllipsizedText(_maxLines, maxWidth, _text);
          }
        } else {
          _data = _getEllipsizedText(_maxLines, maxWidth, _text);
        }

        var tp = new TextPainter(
            text: TextSpan(text: _data, style: this.style),
            textDirection: ui.TextDirection.ltr);

        tp.layout(maxWidth: maxWidth);

        if (tp.height > maxHeight) {
          var tpRemeasureHeight = new TextPainter(
              text: TextSpan(text: "|", style: this.style),
              textDirection: ui.TextDirection.ltr);
          tpRemeasureHeight.layout();

          _maxLines = (maxHeight / tpRemeasureHeight.height).floor();
          _data = _getEllipsizedText(_maxLines, maxWidth, _text);
        }

        return Text(
          _data,
          key: this.key,
          style: this.style,
          textAlign: this.textAlign,
          textDirection: this.textDirection,
          locale: this.locale,
          softWrap: this.softWrap,
          overflow: this.overflow,
          textScaleFactor: this.textScaleFactor,
          maxLines: this.maxLines,
          semanticsLabel: this.semanticsLabel,
        );
      },
    );
  }

  _getEllipsizedText(int maxLines, double maxWidth, String text) {
    String _data = "";
    while (maxLines > 0) {
      if (maxLines == 1) {
        String croppedText =
            Utils.getEllipsizedText(text, this.style, maxWidth);
        _data += "$croppedText";

        text = text.substring(croppedText.length);
      } else {
        String croppedText =
            Utils.getEllipsizedText(text, this.style, maxWidth, withDot: false);
        _data += "$croppedText\n";
        text = text.substring(croppedText.length);
      }
      maxLines--;
    }

    return _data;
  }
}
