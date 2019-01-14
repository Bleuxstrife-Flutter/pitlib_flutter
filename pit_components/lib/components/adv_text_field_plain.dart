import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_input_decorator.dart';
import 'package:pit_components/mods/mod_text_field.dart';
import 'package:pit_components/pit_components.dart';

typedef void OnTextChanged(String oldValue, String newValue);
typedef void OnIconTapped(IconType iconType);

enum IconType { prefix, suffix }

class AdvTextFieldPlain extends StatefulWidget {
  final AdvTextFieldController controller;
  final TextSpan measureTextSpan;
  final EdgeInsetsGeometry padding;
  final OnTextChanged textChangeListener;
  final FormFieldValidator<String> validator;
  final bool autoValidate;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final int maxLineExpand;
  final FocusNode focusNode;
  final Color hintColor;
  final Color labelColor;
  final Color lineColor;
  final Color errorColor;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final OnIconTapped onIconTapped;
  final bool needsCounter;

  AdvTextFieldPlain(
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
      Color lineColor,
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
                suffixIcon == null)),
        this.hintColor = hintColor ?? PitComponents.textFieldHintColor,
        this.labelColor = labelColor ?? PitComponents.textFieldLabelColor,
        this.lineColor = lineColor ?? PitComponents.textFieldLineColor,
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
        this.measureTextSpan = new TextSpan(
            text: measureText ?? "",
            style: textStyle ?? ts.fs16.merge(ts.tcBlack)),
        this.inputFormatters = inputFormatters ?? [],
        this.padding = padding ?? new EdgeInsets.all(0.0),
        this.maxLineExpand = maxLineExpand ?? 4;

  @override
  State createState() => new _AdvTextFieldPlainState();
}

class _AdvTextFieldPlainState extends State<AdvTextFieldPlain>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingCtrl = new TextEditingController();
  int initialMaxLines;
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
    initialMaxLines = widget.controller.maxLines;
    _obscureText = widget.controller.obscureText;
    _textEditingCtrl.text = widget.controller.text;
  }

  _update() {
    if (this.mounted) {
      setState(() {
        _updateTextController();
      });
    }
  }

  _updateTextController() {
    var cursorPos = widget.controller.selection;
    _textEditingCtrl.text = widget.controller.text;

    if (cursorPos.start > _textEditingCtrl.text.length) {
      cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: _textEditingCtrl.text.length));
    }
    _textEditingCtrl.selection = cursorPos;
  }

  @override
  void didUpdateWidget(AdvTextFieldPlain oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextController();
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
    final int _defaultHeightAddition = 20;
    final double _defaultInnerPadding = 8.0;

    final Color _textColor = widget.controller.enable
        ? widget.measureTextSpan.style.color
        : Color.lerp(
            widget.measureTextSpan.style.color, PitComponents.lerpColor, 0.6);
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
      children.add(Container(
          child: AdvText(
            widget.controller.label,
            style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
            maxLines: 1,
          ),
          width: width));
    }
    double _paddingSize = 8.0 / 16.0 * widget.measureTextSpan.style.fontSize;

    Widget mainChild = Container(
      width: width,
      padding: widget.padding,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          maxHeight: maxHeightExpand,
          minHeight: tp.size.height +
              _defaultHeightAddition +
              /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
              maxLengthHeight,
        ),
        child: Theme(
          data: new ThemeData(
            cursorColor: Theme.of(context).cursorColor,
            hintColor: widget.lineColor,
            primaryColor: widget.lineColor,
            accentColor: widget.lineColor,
          ),
          child: ModTextField(
            focusNode: widget.focusNode,
            controller: _textEditingCtrl,
            onChanged: (newText) {
              widget.controller.removeListener(_update);
              if (widget.keyboardType == TextInputType.number && newText == "")
                newText = "";
              var newValue =
                  widget.keyboardType == TextInputType.number && newText != ""
                      ? newText.indexOf(".") > 0
                          ? (double.tryParse(newText) ?? widget.controller.text)
                              .toString()
                          : (int.tryParse(newText) ?? widget.controller.text)
                              .toString()
                      : newText;

              String oldValue = widget.controller.text;
              //set ke text yg diketik supaya pas di bawah di-set dengan newvalue akan ketrigger updatenya
              widget.controller.text = newText;
              widget.controller.selection = _textEditingCtrl.selection;
              widget.controller.error = "";

              widget.controller.addListener(_update);

              widget.controller.text = newValue;
              if (widget.textChangeListener != null)
                widget.textChangeListener(oldValue, newValue);
            },
            obscureText: _obscureText,
            enabled: widget.controller.enable,
            maxLines: widget.controller.maxLines,
            maxLength: widget.controller.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: formatters,
            maxLengthEnforced: widget.controller.maxLengthEnforced,
            textAlign: TextAlign.left,
            style: widget.measureTextSpan.style.copyWith(color: _textColor),
            decoration: ModInputDecoration(
                prefixIcon: widget.controller.prefixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.prefix);
                        },
                        child: Container(
                            child: widget.controller.prefixIcon,
                            margin: EdgeInsets.only(right: _paddingSize)))
                    : null,
                suffixIcon: widget.controller.suffixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.suffix);
                        },
                        child: Container(
                            child: widget.controller.suffixIcon,
                            margin: EdgeInsets.only(left: _paddingSize)))
                    : null,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: _paddingSize), //untuk ini padding horizontalnya aneh, leftnya gk ada paddingnya, jadinya pake margin untuk icon aja
                hintText: widget.controller.hint,
                hintStyle: TextStyle(color: _hintColor.withOpacity(0.6)),
                maxLines: widget.controller.maxLines),
          ),
        ),
      ),
    );

    children.add(mainChild);

    if (widget.controller.error != null && widget.controller.error != "") {
      TextStyle style = ts.fs11
          .copyWith(color: widget.errorColor, fontWeight: ts.fw600.fontWeight);

      children.add(Container(
          width: width,
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
