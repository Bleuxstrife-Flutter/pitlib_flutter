import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_row.dart';

class AdvTextWithNumber extends StatelessWidget {
  final Text number;
  final Text text;
  final double dividerWidth;

  AdvTextWithNumber(this.number, this.text, {this.dividerWidth = 0.0});

  @override
  Widget build(BuildContext context) {
    return AdvRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      divider: RowDivider(dividerWidth),
      children: [number, Expanded(child: text)],
    );
  }
}
