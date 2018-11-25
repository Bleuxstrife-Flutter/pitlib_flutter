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
        String _data = Utils.getEllipsizedText(this.data, this.style, maxWidth);

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
}
