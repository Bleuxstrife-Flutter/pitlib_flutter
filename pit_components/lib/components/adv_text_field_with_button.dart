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

class AdvTextFieldWithButton extends StatefulWidget {
  final AdvTextFieldController controller;
  final TextSpan measureTextSpan;
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
  final Color backgroundColor;
  final Color borderColor;
  final Color errorColor;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final OnIconTapped onIconTapped;
  final bool needsCounter;
  final String buttonName;
  final VoidCallback onButtonTapped;
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

  AdvTextFieldWithButton(
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
      Color backgroundColor,
      Color borderColor,
      Color errorColor,
      this.prefixIcon,
      this.suffixIcon,
      this.onIconTapped,
      this.buttonName,
      this.onButtonTapped})
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
        this.maxLines = maxLines ?? 1,
        this.hintColor = hintColor ?? PitComponents.textFieldHintColor,
        this.labelColor = labelColor ?? PitComponents.textFieldLabelColor,
        this.backgroundColor =
            backgroundColor ?? PitComponents.textFieldBackgroundColor,
        this.borderColor = borderColor ?? PitComponents.textFieldBorderColor,
        this.errorColor = errorColor ?? PitComponents.textFieldErrorColor,
        this.measureTextSpan = TextSpan(
            text: measureText, style: textStyle ?? ts.fs16.merge(ts.tcBlack)),
        this.inputFormatters = inputFormatters ?? [],
        this.margin = margin ?? PitComponents.editableMargin,
        this.maxLineExpand = maxLineExpand ?? 1;

  @override
  State createState() => new _AdvTextFieldWithButtonState();
}

class _AdvTextFieldWithButtonState extends State<AdvTextFieldWithButton>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingCtrl = new TextEditingController();
  int initialMaxLines;

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
    _textEditingCtrl.text = _effectiveController.text ?? "";
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
  void didUpdateWidget(AdvTextFieldWithButton oldWidget) {
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
    final int _defaultHeightAddition = 24;
    final double _defaultInnerPadding = 8.0;

    final Color _backgroundColor = _effectiveController.enable
        ? widget.backgroundColor
        : Color.lerp(Colors.black, Colors.white, 0.97);
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

    double _iconSize = 24.0 / 16.0 * widget.measureTextSpan.style.fontSize;
    double _paddingSize = 8.0 / 16.0 * widget.measureTextSpan.style.fontSize;

    var tp = new TextPainter(
        text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

    tp.layout();

    double width = tp.size.width == 0
        ? maxWidth
        : tp.size.width + _defaultWidthAddition + (_defaultInnerPadding * 2);

    TextSpan currentTextSpan = TextSpan(
        text: _textEditingCtrl.text, style: widget.measureTextSpan.style);

    var tp2 = new TextPainter(
        text: currentTextSpan, textDirection: ui.TextDirection.ltr);
    tp2.layout(maxWidth: width - _iconSize - (_paddingSize * 2));

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
      children.add(
        Container(
          width: width,
          child: AdvText(
            _effectiveController.label,
            style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
            maxLines: 1,
          ),
        ),
      );
    }

    List<Widget> innerChildren = [];

    Widget mainChild = Container(
      width: width,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: tp.size.height +
              _defaultHeightAddition +
              /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
              maxLengthHeight -
              8.0 -
              ((8.0 - _paddingSize) * 2),
        ),
        child: new Theme(
          data: new ThemeData(
              cursorColor: Theme.of(context).cursorColor,
              accentColor: _backgroundColor,
              hintColor: widget.borderColor,
              primaryColor: widget.borderColor),
          child: ModTextField(
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
            obscureText: _effectiveController.obscureText,
            enabled: _effectiveController.enable,
            maxLines: 1,
            //untuk ini harus 1 line maxnya, karena nanti kalo bs 2 line, harus ganti ukuran tombol
            maxLength: _effectiveController.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: formatters,
            maxLengthEnforced: _effectiveController.maxLengthEnforced,
            textAlign: _effectiveController.alignment,
            style: widget.measureTextSpan.style.copyWith(color: _textColor),
            decoration: ModInputDecoration(
                iconSize: _iconSize,
                prefixIcon: _effectiveController.prefixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.prefix);
                        },
                        child:
                            Container(child: _effectiveController.prefixIcon))
                    : null,
                suffixIcon: _effectiveController.suffixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.suffix);
                        },
                        child:
                            Container(child: _effectiveController.suffixIcon))
                    : null,
                filled: true,
                fillColor: _backgroundColor,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(_paddingSize),
//                contentPadding: new EdgeInsets.only(
//                    left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                hintText: _effectiveController.hint,
                hintStyle: TextStyle(color: _hintColor.withOpacity(0.6)),
                maxLines: _effectiveController.maxLines),
          ),
        ),
      ),
    );

    innerChildren.add(Expanded(child: mainChild));

    if (widget.buttonName != null) {
      Widget rightButton = Container(
        height: tp.size.height +
            _defaultHeightAddition +
            /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
            maxLengthHeight -
            8.0 -
            ((8.0 - _paddingSize) * 2),
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
                onTap: () {
                  if (widget.onButtonTapped != null) widget.onButtonTapped();
                },
                child: Container(
                    padding: EdgeInsets.all(_paddingSize),
                    alignment: Alignment.center,
                    child: Text(widget.buttonName,
                        style: widget.measureTextSpan.style
                            .merge(ts.fw500)
                            .copyWith(color: _backgroundColor))))),
        decoration: BoxDecoration(
          color: PitComponents.textFieldButtonColor,
        ),
      );
      innerChildren.add(rightButton);
    }
    children.add(ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: innerChildren)));

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
