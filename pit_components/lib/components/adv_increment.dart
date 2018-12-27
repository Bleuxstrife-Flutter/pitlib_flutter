import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_input_decorator.dart';
import 'package:pit_components/mods/mod_text_field.dart';
import 'package:pit_components/pit_components.dart';

typedef void OnValueChanged(int oldValue, int newValue);
typedef void OnIconTapped(IconType iconType);

enum IconType { prefix, suffix }

class AdvIncrement extends StatefulWidget {
  final AdvIncrementController controller;
  final TextSpan measureTextSpan;
  final EdgeInsetsGeometry padding;
  final OnValueChanged valueChangeListener;
  final int maxLineExpand;
  final Color hintColor;
  final Color labelColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color errorColor;

  AdvIncrement(
      {int counter,
      String format,
      String hint,
      String label,
      String error,
      int minCounter,
      int maxCounter,
      int maxLines,
      bool enable,
      TextAlign alignment,
      String measureText,
      TextStyle textStyle,
      EdgeInsetsGeometry padding,
      this.valueChangeListener,
      AdvIncrementController controller,
      int maxLineExpand,
      Color hintColor,
      Color labelColor,
      Color backgroundColor,
      Color borderColor,
      Color errorColor})
      : assert(controller == null ||
            (counter == null &&
                format == null &&
                hint == null &&
                label == null &&
                error == null &&
                minCounter == null &&
                maxCounter == null &&
                maxLines == null &&
                enable == null &&
                alignment == null)),
        this.hintColor = hintColor ?? PitComponents.textFieldHintColor,
        this.labelColor = labelColor ?? PitComponents.textFieldLabelColor,
        this.backgroundColor =
            backgroundColor ?? PitComponents.textFieldBackgroundColor,
        this.borderColor = borderColor ?? PitComponents.textFieldBorderColor,
        this.errorColor = errorColor ?? PitComponents.textFieldErrorColor,
        this.controller = controller ??
            new AdvIncrementController(
                counter: counter ?? 0,
                format: format ?? "",
                hint: hint ?? "",
                label: label ?? "",
                error: error ?? "",
                minCounter: minCounter,
                maxCounter: maxCounter,
                maxLines: maxLines ?? 1,
                enable: enable ?? true,
                alignment: alignment ?? TextAlign.center),
        this.measureTextSpan = TextSpan(
            text: measureText, style: textStyle ?? ts.fs16.merge(ts.tcBlack)),
        this.padding = padding ?? new EdgeInsets.all(0.0),
        this.maxLineExpand = maxLineExpand ?? 4;

  @override
  State createState() => new _AdvIncrementState();
}

class _AdvIncrementState extends State<AdvIncrement>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEdittingCtrl = new TextEditingController();
  int initialMaxLines;

  NumberFormat nf;

  @override
  void initState() {
    super.initState();
    nf = NumberFormat("${widget.controller.format}");
    widget.controller.addListener(_update);
    initialMaxLines = widget.controller.maxLines;
    _textEdittingCtrl.text = nf.format(widget.controller.counter ?? 0);
  }

  _update() {
    setState(() {
      var cursorPos = _textEdittingCtrl.selection;
      _textEdittingCtrl.text = nf.format(widget.controller.counter ?? 0);

      if (cursorPos.start > _textEdittingCtrl.text.length) {
        cursorPos = new TextSelection.fromPosition(
            new TextPosition(offset: _textEdittingCtrl.text.length));
      }
      _textEdittingCtrl.selection = cursorPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        return AdvColumn(
          divider: ColumnDivider(2.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildChildren(maxWidth),
        );
      },
    );
  }

  List<Widget> _buildChildren(double maxWidth) {
    List<Widget> children = [];
    final int _defaultWidthAddition = 2;
    final int _defaultHeightAddition = 24;
    final double _defaultInnerPadding = 8.0;

    final Color _backgroundColor = widget.controller.enable
        ? widget.backgroundColor
        : Color.lerp(widget.backgroundColor, PitComponents.lerpColor, 0.6);
    final Color _textColor = widget.controller.enable
        ? widget.measureTextSpan.style.color ?? Colors.black
        : Color.lerp(widget.measureTextSpan.style.color ?? Colors.black,
            PitComponents.lerpColor, 0.6);
    final Color _hintColor = widget.controller.enable
        ? widget.hintColor
        : Color.lerp(widget.hintColor, PitComponents.lerpColor, 0.6);
//    return LayoutBuilder(
//        builder: (context, constraints) {
//      final double maxWidth = constraints.maxWidth;
//
//        },
//    );

    double _iconSize = 24.0 / 16.0 * widget.measureTextSpan.style.fontSize;
    double _paddingSize = 8.0 / 16.0 * widget.measureTextSpan.style.fontSize;

    var tp = new TextPainter(
        text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

    tp.layout();

    double width = tp.size.width == 0
        ? maxWidth
        : tp.size.width +
            _defaultWidthAddition +
            (_defaultInnerPadding * 2) +
            (widget.padding.horizontal);

    TextSpan currentTextSpan = TextSpan(
        text: _textEdittingCtrl.text, style: widget.measureTextSpan.style);

    var tp2 = new TextPainter(
        text: currentTextSpan, textDirection: ui.TextDirection.ltr);
    tp2.layout(maxWidth: width - _iconSize - (_paddingSize * 2));

    if (widget.controller.label != null && widget.controller.label != "") {
      children.add(
        AdvText(
          widget.controller.label,
          style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
          maxLines: 1,
        ),
      );
    }

    Widget leftButton = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0).copyWith(left: 1.0),
      padding: EdgeInsets.symmetric(horizontal: _paddingSize),
      alignment: Alignment.center,
      height: tp.size.height +
          _defaultHeightAddition -
          /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
          8.0 -
          ((8.0 - _paddingSize) * 2),
      child: Material(
          clipBehavior: Clip.antiAlias,
          shape: CircleBorder(),
          type: MaterialType.transparency,
          child: InkWell(
              onTap: () {
                if (widget.controller.minCounter == widget.controller.counter)
                  return;
                widget.controller.counter--;
                if (widget.valueChangeListener != null)
                  widget.valueChangeListener(
                      widget.controller.counter + 1, widget.controller.counter);
              },
              child: Container(child: Icon(Icons.remove, size: _iconSize)))),
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
    );

    Widget mainChild = Container(
      width: width,
      padding: widget.padding,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: tp.size.height +
              _defaultHeightAddition -
              /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
              8.0 -
              ((8.0 - _paddingSize) * 2),
        ),
        child: AbsorbPointer(
          child: new Theme(
            data: new ThemeData(
                cursorColor: Theme.of(context).cursorColor,
                accentColor: _backgroundColor,
                hintColor: widget.borderColor,
                primaryColor: widget.borderColor),
            child: ModTextField(
              controller: _textEdittingCtrl,
              enabled: widget.controller.enable,
              maxLines: widget.controller.maxLines,
              keyboardType: TextInputType.number,
              textAlign: widget.controller.alignment,
              style: widget.measureTextSpan.style.copyWith(color: _textColor),
              decoration: ModInputDecoration(
                  iconSize: _iconSize,
                  filled: true,
                  fillColor: _backgroundColor,
//                border: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                    const Radius.circular(4.0),
                  )),
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: _paddingSize,
                      horizontal: _iconSize + 1.0 + (_paddingSize * 2)),
//                contentPadding: new EdgeInsets.only(
//                    left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                  hintText: widget.controller.hint,
                  hintStyle: TextStyle(color: _hintColor.withOpacity(0.6)),
                  maxLines: widget.controller.maxLines),
            ),
          ),
        ),
      ),
    );

    Widget rightButton = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0).copyWith(right: 1.0),
      padding: EdgeInsets.symmetric(horizontal: _paddingSize),
      alignment: Alignment.center,
      height: tp.size.height +
          _defaultHeightAddition -
          /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
          8.0 -
          ((8.0 - _paddingSize) * 2),
      child: Material(
          clipBehavior: Clip.antiAlias,
          shape: CircleBorder(),
          type: MaterialType.transparency,
          child: InkWell(
              onTap: () {
                if (widget.controller.maxCounter == widget.controller.counter)
                  return;
                widget.controller.counter++;
                if (widget.valueChangeListener != null)
                  widget.valueChangeListener(
                      widget.controller.counter - 1, widget.controller.counter);
              },
              child: Container(child: Icon(Icons.add, size: _iconSize)))),
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
    );

    children.add(Stack(children: [
      mainChild,
      Positioned(top: 0.0, left: 0.0, bottom: 0.0, child: leftButton),
      Positioned(top: 0.0, right: 0.0, bottom: 0.0, child: rightButton),
    ]));

    if (widget.controller.error != null && widget.controller.error != "") {
      TextStyle style = ts.fs11
          .copyWith(color: widget.errorColor, fontWeight: ts.fw600.fontWeight);

      children.add(Container(
          width: maxWidth,
          child: AdvText(
            widget.controller.error,
            textAlign: TextAlign.end,
            style: style,
            maxLines: 1,
          )));
    }

    return children;
  }
}
