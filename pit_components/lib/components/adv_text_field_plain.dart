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
  final EdgeInsets padding;
  final EdgeInsets margin;
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
  final String text;
  final String hint;
  final String label;
  final String error;
  final int maxLength;
  final int maxLines;
  final bool maxLengthEnforced;
  final bool enable;
  final TextAlign alignment;
  final bool obscureText;

  AdvTextFieldPlain(
      {this.text,
      this.hint,
      this.label,
      this.error,
      this.maxLength,
      int maxLines,
      this.maxLengthEnforced,
      this.needsCounter = false,
      this.enable,
      this.alignment,
      this.obscureText,
      String measureText,
      TextStyle textStyle,
        EdgeInsets padding,
        EdgeInsets margin,
      this.textChangeListener,
      this.validator,
      this.autoValidate = false,
      List<TextInputFormatter> inputFormatters,
      this.keyboardType = TextInputType.text,
      this.controller,
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
        this.maxLines = maxLines ?? 1,
        this.hintColor = hintColor ?? PitComponents.textFieldHintColor,
        this.labelColor = labelColor ?? PitComponents.textFieldLabelColor,
        this.lineColor = lineColor ?? PitComponents.textFieldLineColor,
        this.errorColor = errorColor ?? PitComponents.textFieldErrorColor,
        this.measureTextSpan = new TextSpan(
            text: measureText ?? "",
            style: textStyle ?? ts.fs16.merge(ts.tcBlack)),
        this.inputFormatters = inputFormatters ?? [],
        this.padding = padding ?? new EdgeInsets.all(0.0),
        this.margin = margin ?? PitComponents.editableMargin,
        this.maxLineExpand = maxLineExpand ?? 4;

  @override
  State createState() => new _AdvTextFieldPlainState();
}

class _AdvTextFieldPlainState extends State<AdvTextFieldPlain>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingCtrl = new TextEditingController();
  int initialMaxLines;
  bool _obscureText;

  AdvTextFieldController get _effectiveController => widget.controller ?? _ctrl;

  AdvTextFieldController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = _effectiveController == null
        ? AdvTextFieldController(
            text: widget.text ?? "",
            hint: widget.hint ?? "",
            label: widget.label ?? "",
            error: widget.error ?? "",
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            maxLengthEnforced: widget.maxLengthEnforced ?? false,
            enable: widget.enable ?? true,
            alignment: widget.alignment ?? TextAlign.left,
            obscureText: widget.obscureText ?? false,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon)
        : null;

    _effectiveController.addListener(_update);
    initialMaxLines = _effectiveController.maxLines;
    _obscureText = _effectiveController.obscureText;
    _textEditingCtrl.text = _effectiveController.text ?? "";
    _textEditingCtrl.addListener(_updateEffectiveSelection);
  }

  _updateEffectiveSelection() {
    if (_textEditingCtrl.selection != _effectiveController.selection &&
        _textEditingCtrl.selection.start <=
            (_effectiveController.text?.length ?? 0) &&
        _textEditingCtrl.selection.end <=
            (_effectiveController.text?.length ?? 0)) {
      _effectiveController.removeListener(_update);
      _effectiveController.selection = _textEditingCtrl.selection;
      _effectiveController.addListener(_update);
    }
  }

  _update() {
    if (this.mounted) {
      setState(() {
        _updateTextController();
      });
    }
  }

  _updateTextController() {
    var cursorPos = _effectiveController.selection;
    _textEditingCtrl.removeListener(_updateEffectiveSelection);
    _textEditingCtrl.text = _effectiveController.text;

    if (cursorPos.start > _textEditingCtrl.text.length) {
      cursorPos = new TextSelection.fromPosition(
          new TextPosition(offset: _textEditingCtrl.text.length));
    }
    _textEditingCtrl.selection = cursorPos;
    _textEditingCtrl.addListener(_updateEffectiveSelection);
  }

  @override
  void didUpdateWidget(AdvTextFieldPlain oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateTextController();
    _updateEffectiveSelection();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        return AdvColumn(
          margin: widget.margin,
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

    final Color _textColor = _effectiveController.enable
        ? widget.measureTextSpan.style.color ?? Colors.black
        : Color.lerp(widget.measureTextSpan.style.color ?? Colors.black, Colors.white, 0.57);
    final Color _hintColor = _effectiveController.enable
        ? widget.hintColor
        : Color.lerp(widget.hintColor, Colors.white, 0.39);

    int maxLengthHeight = _effectiveController == null
        ? 0
        : _effectiveController.maxLength != null && widget.needsCounter
            ? 22
            : 0;

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
      if (_effectiveController.maxLength == null) {
        formatters.add(LengthLimitingTextInputFormatter(18));
      } else {
        if (_effectiveController.maxLength > 18)
          _effectiveController.maxLength = 18;
      }
    }

    if (_effectiveController.label != null &&
        _effectiveController.label != "") {
      children.add(Container(
          child: AdvText(
            _effectiveController.label,
            style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
            maxLines: 1,
          ),
          width: width));
    }

    double _paddingSize = 8.0 / 16.0 * widget.measureTextSpan.style.fontSize;
    double _currentHeight =
        tp.size.height > maxHeightExpand ? maxHeightExpand : tp.size.height;

    Widget mainChild = Container(
      width: width,
      padding: widget.padding,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: _currentHeight +
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
            maxHeight: maxHeightExpand + 2.0,
            focusNode: widget.focusNode,
            controller: _textEditingCtrl,
            onChanged: (newText) {
              _effectiveController.removeListener(_update);
              if (widget.keyboardType == TextInputType.number && newText == "")
                newText = "";
              var newValue = widget.keyboardType == TextInputType.number &&
                      newText != ""
                  ? newText.indexOf(".") > 0
                      ? (double.tryParse(newText) ?? _effectiveController.text)
                          .toString()
                      : (int.tryParse(newText) ?? _effectiveController.text)
                          .toString()
                  : newText;

              String oldValue = _effectiveController.text;
              //set ke text yg diketik supaya pas di bawah di-set dengan newvalue akan ketrigger updatenya
              _effectiveController.text = newText;
              _effectiveController.selection = _textEditingCtrl.selection;
              _effectiveController.error = "";

              _effectiveController.addListener(_update);

              _effectiveController.text = newValue;
              if (widget.textChangeListener != null)
                widget.textChangeListener(oldValue, newValue);
            },
            obscureText: _obscureText,
            enabled: _effectiveController.enable,
            maxLines: _effectiveController.maxLines,
            maxLength: _effectiveController.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: formatters,
            maxLengthEnforced: _effectiveController.maxLengthEnforced,
            textAlign: TextAlign.left,
            style: widget.measureTextSpan.style.copyWith(color: _textColor),
            decoration: ModInputDecoration(
                prefixIcon: _effectiveController.prefixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.prefix);
                        },
                        child: Container(
                            child: _effectiveController.prefixIcon,
                            margin: EdgeInsets.only(right: _paddingSize)))
                    : null,
                suffixIcon: _effectiveController.suffixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.suffix);
                        },
                        child: Container(
                            child: _effectiveController.suffixIcon,
                            margin: EdgeInsets.only(left: _paddingSize)))
                    : null,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: _paddingSize),
                //untuk ini padding horizontalnya aneh, leftnya gk ada paddingnya, jadinya pake margin untuk icon aja
                hintText: _effectiveController.hint,
                hintStyle: TextStyle(color: _hintColor),
                maxLines: _effectiveController.maxLines),
          ),
        ),
      ),
    );

    children.add(mainChild);

    if (_effectiveController.error != null &&
        _effectiveController.error != "") {
      TextStyle style = ts.fs11
          .copyWith(color: widget.errorColor, fontWeight: ts.fw600.fontWeight);

      children.add(Container(
          width: width,
          child: AdvText(
            _effectiveController.error,
            textAlign: TextAlign.end,
            style: style,
            maxLines: 1,
          )));
    }

    return children;
  }
}
