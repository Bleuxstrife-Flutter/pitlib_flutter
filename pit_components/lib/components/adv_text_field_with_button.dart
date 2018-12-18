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
  final Color backgroundColor;
  final Color borderColor;
  final Color errorColor;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final OnIconTapped onIconTapped;
  final bool needsCounter;
  final String buttonName;
  final VoidCallback onButtonTapped;

  AdvTextFieldWithButton(
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
                maxLines: maxLines ?? 1,
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
  State createState() => new _AdvTextFieldWithButtonState();
}

class _AdvTextFieldWithButtonState extends State<AdvTextFieldWithButton>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEdittingCtrl = new TextEditingController();
  int initialMaxLines;

  @override
  void initState() {
    super.initState();
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
//    return LayoutBuilder(
//        builder: (context, constraints) {
//      final double maxWidth = constraints.maxWidth;
//
//        },
//    );
    int maxLengthHeight = widget.controller == null
        ? 0
        : widget.controller.maxLength != null && widget.needsCounter ? 22 : 0;

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
    print(
        "currentTextSpan => $currentTextSpan, maxWidth => ${width - _iconSize - (_paddingSize * 2)}");
    print("TextPainter => ${tp2.size.height}");

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

    List<Widget> innerChildren = [];

    Widget mainChild = Container(
      width: width,
      color: Colors.purple,
      padding: widget.padding,
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
            controller: _textEdittingCtrl,
            onChanged: (newText) {
              bool valueShouldChange = false;

              widget.controller.removeListener(_update);
              if (widget.keyboardType == TextInputType.number && newText == "")
                newText = "0";

              var newValue = widget.keyboardType == TextInputType.number
                  ? newText.indexOf(".") > 0
                      ? (double.tryParse(newText) ?? widget.controller.text)
                          .toString()
                      : (int.tryParse(newText) ?? widget.controller.text)
                          .toString()
                  : newText;

              valueShouldChange = widget.keyboardType == TextInputType.number &&
                  newText.indexOf(".") > 0;

              int startIndex = newValue.indexOf("\n");
              int newLineCount = 0;

              while (startIndex != -1) {
                newLineCount++;
                startIndex = newValue.indexOf("\n", startIndex + 1);
              }

              if (initialMaxLines == 1) {
                if (newLineCount > widget.maxLineExpand - 1) {
                  widget.controller.maxLines = widget.maxLineExpand;
                  valueShouldChange = true;
                } else {
                  widget.controller.maxLines = newLineCount + 1;
                  valueShouldChange = true;
                }
              }

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
            style: widget.measureTextSpan.style.copyWith(color: _textColor),
            decoration: ModInputDecoration(
                iconSize: _iconSize,
                prefixIcon: widget.controller.prefixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.prefix);
                        },
                        child: Container(child: widget.controller.prefixIcon))
                    : null,
                suffixIcon: widget.controller.suffixIcon != null
                    ? InkWell(
                        onTap: () {
                          widget.onIconTapped(IconType.suffix);
                        },
                        child: Container(child: widget.controller.suffixIcon))
                    : null,
                filled: true,
                fillColor: _backgroundColor,
                border: InputBorder.none,
                contentPadding: new EdgeInsets.all(_paddingSize),
//                contentPadding: new EdgeInsets.only(
//                    left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                hintText: widget.controller.hint,
                hintStyle: TextStyle(color: _hintColor.withOpacity(0.6)),
                maxLines: widget.controller.maxLines),
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
                    padding: EdgeInsets.symmetric(horizontal: _paddingSize),
                    alignment: Alignment.center,
                    child: Text(widget.buttonName,
                        style: widget.measureTextSpan.style
                            .merge(ts.fw700)
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
