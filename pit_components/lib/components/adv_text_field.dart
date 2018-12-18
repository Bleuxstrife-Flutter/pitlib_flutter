import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_input_decorator.dart';
import 'package:pit_components/mods/mod_text_field.dart';
import 'package:pit_components/pit_components.dart';

typedef void OnTextChanged(String oldValue, String newValue);
typedef void OnIconTapped(IconType iconType);

enum IconType { prefix, suffix }

class AdvTextField extends StatefulWidget {
  final AdvTextFieldController controller;
  final TextSpan measureTextSpan;
  final EdgeInsets padding;
  final OnTextChanged textChangeListener;
  final FormFieldValidator<String> validator;
  final bool autoValidate;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final int maxLineExpand;
  final FocusNode focusNode;
  final Color hintColor;
  final Color labelColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color errorColor;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final OnIconTapped onIconTapped;
  final bool needsCounter;

  AdvTextField(
      {String text,
      String hint,
      String label,
      String error,
      int maxLength,
      int maxLines,
      bool maxLengthEnforced,
      this.needsCounter = false,
      bool enable,
      TextAlign alignment,
      bool obscureText,
      String measureText,
      TextStyle textStyle,
      EdgeInsetsGeometry padding,
      this.textChangeListener,
      this.validator,
      this.autoValidate = false,
      List<TextInputFormatter> inputFormatters,
      this.keyboardType = TextInputType.text,
      AdvTextFieldController controller,
      int maxLineExpand,
      this.focusNode,
      Color hintColor,
      Color labelColor,
      Color backgroundColor,
      Color borderColor,
      Color errorColor,
      this.prefixIcon,
      this.suffixIcon,
      this.onIconTapped})
      : assert(controller == null ||
            (text == null &&
                hint == null &&
                label == null &&
                error == null &&
                maxLength == null &&
                maxLines == null &&
                maxLengthEnforced == null &&
                enable == null &&
                alignment == null &&
                obscureText == null &&
                prefixIcon == null &&
                suffixIcon == null)),
        this.hintColor = hintColor ?? PitComponents.textFieldHintColor,
        this.labelColor = labelColor ?? PitComponents.textFieldLabelColor,
        this.backgroundColor =
            backgroundColor ?? PitComponents.textFieldBackgroundColor,
        this.borderColor = borderColor ?? PitComponents.textFieldBorderColor,
        this.errorColor = errorColor ?? PitComponents.textFieldErrorColor,
        this.controller = controller ??
            new AdvTextFieldController(
                text: text ?? "",
                hint: hint ?? "",
                label: label ?? "",
                error: error ?? "",
                maxLength: maxLength,
                maxLines: maxLines,
                maxLengthEnforced: maxLengthEnforced ?? false,
                enable: enable ?? true,
                alignment: alignment ?? TextAlign.left,
                obscureText: obscureText ?? false,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon),
        this.measureTextSpan = TextSpan(
            text: measureText, style: textStyle ?? ts.fs16.merge(ts.tcBlack)),
        this.inputFormatters = inputFormatters ?? [],
        this.padding = padding ?? new EdgeInsets.all(0.0),
        this.maxLineExpand = maxLineExpand ?? 4;

  @override
  State createState() => new _AdvTextFieldState();
}

class _AdvTextFieldState extends State<AdvTextField>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEdittingCtrl = new TextEditingController();
  int initialMaxLines;

  @override
  void initState() {
    super.initState();

    print("controller textfield => ${widget.controller}");
    widget.controller.addListener(_update);
    initialMaxLines = widget.controller.maxLines;
    _textEdittingCtrl.text = widget.controller.text ?? "";
  }

  _update() {
    setState(() {
      var cursorPos = _textEdittingCtrl.selection;
      _textEdittingCtrl.text = widget.controller.text;

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

    int maxLengthHeight = widget.controller == null
        ? 0
        : widget.controller.maxLength != null && widget.needsCounter ? 22 : 0;

    var tp = new TextPainter(
        text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

    tp.layout();

    var tpMaxLineExpand = new TextPainter(
        text: TextSpan(text: "|", style: widget.measureTextSpan.style),
        textDirection: ui.TextDirection.ltr);

    tpMaxLineExpand.layout(maxWidth: maxWidth);
    double maxHeightExpand = tpMaxLineExpand.height * widget.maxLineExpand;

    double width = tp.size.width == 0
        ? maxWidth
        : tp.size.width +
            _defaultWidthAddition +
            (_defaultInnerPadding * 2) +
            (widget.padding.horizontal);

    final List<TextInputFormatter> formatters =
        widget.inputFormatters ?? <TextInputFormatter>[];

    if (widget.keyboardType == TextInputType.number) {
      if (widget.controller.maxLength == null) {
        formatters.add(LengthLimitingTextInputFormatter(18));
      } else {
        if (widget.controller.maxLength > 18) widget.controller.maxLength = 18;
      }
    }

    if (widget.controller.label != null && widget.controller.label != "") {
      children.add(
        AdvText(
          widget.controller.label,
          style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
          maxLines: 1,
        ),
      );
    }

    double _paddingSize = 8.0 / 14.0 * widget.measureTextSpan.style.fontSize;

    Widget mainChild = Container(
        width: width,
        constraints: BoxConstraints(
          minHeight: tp.size.height +
              _defaultHeightAddition +
              maxLengthHeight -
              8.0 -
              ((8.0 - _paddingSize) * 2),
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(width: 1.0, color: widget.borderColor),
          borderRadius: const BorderRadius.all(
            const Radius.circular(4.0),
          ),
        ),
        padding: EdgeInsets.only(
            top: widget.padding.top + _paddingSize,
            left: widget.padding.left + _paddingSize,
            bottom: widget.padding.bottom + _paddingSize,
            right: widget.padding.right + _paddingSize),
        child: AdvRow(children: [
          InkWell(
            onTap: () {
              widget.onIconTapped(IconType.prefix);
            },
            child: widget.controller.prefixIcon,
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: maxHeightExpand,
              ),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                reverse: true,
                child: new Theme(
                  data: new ThemeData(
                    hintColor: Colors.white,
                    primaryColor: Colors.white,
                  ),
                  child: ModTextField(
                    focusNode: widget.focusNode,
                    controller: _textEdittingCtrl,
                    onChanged: (newText) {
                      bool valueShouldChange = false;

                      widget.controller.removeListener(_update);
                      if (widget.keyboardType == TextInputType.number &&
                          newText == "") newText = "0";

                      var newValue = widget.keyboardType == TextInputType.number
                          ? newText.indexOf(".") > 0
                              ? (double.tryParse(newText) ??
                                      widget.controller.text)
                                  .toString()
                              : (int.tryParse(newText) ??
                                      widget.controller.text)
                                  .toString()
                          : newText;

                      valueShouldChange =
                          widget.keyboardType == TextInputType.number &&
                              newText.indexOf(".") > 0;

                      String oldValue = widget.controller.text;
                      widget.controller.text = newValue;
                      widget.controller.error = "";

                      widget.controller.addListener(_update);
                      if (valueShouldChange) {
                        newValue = "(setstate) $newValue";
                        if (this.mounted) {
                          setState(() {
                            if (widget.textChangeListener != null)
                              widget.textChangeListener(oldValue, newValue);
                          });
                        }
                      } else {
                        if (widget.textChangeListener != null)
                          widget.textChangeListener(oldValue, newValue);
                      }
                    },
                    obscureText: widget.controller.obscureText,
                    enabled: widget.controller.enable,
                    maxLines: widget.controller.maxLines,
                    maxLength: widget.controller.maxLength,
                    keyboardType: widget.keyboardType,
                    inputFormatters: formatters,
                    maxLengthEnforced: widget.controller.maxLengthEnforced,
                    textAlign: widget.controller.alignment,
                    style: widget.measureTextSpan.style
                        .copyWith(color: _textColor),
                    decoration: ModInputDecoration(
                        contentPadding: new EdgeInsets.all(0.0),
                        hintText: widget.controller.hint,
                        hintStyle:
                            TextStyle(color: _hintColor.withOpacity(0.6)),
                        maxLines: widget.controller.maxLines),
                  ),
                ),
              ),
            ),
          )),
          InkWell(
              onTap: () {
                widget.onIconTapped(IconType.suffix);
              },
              child: widget.controller.suffixIcon)
        ]));

    children.add(mainChild);

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
