import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_input_decorator.dart';
import 'package:pit_components/mods/mod_text_field.dart';
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/utils/utils.dart';

typedef void OnItemChanged(String oldValue, String newValue);

class AdvChooser extends StatefulWidget {
  final AdvChooserController controller;
  final TextSpan measureTextSpan;
  final EdgeInsetsGeometry padding;
  final Color hintColor;
  final Color labelColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color errorColor;
  final OnItemChanged itemChangeListener;

  AdvChooser(
      {String text,
      String hint,
      String label,
      String error,
      bool enable,
      TextAlign alignment,
      String measureText,
      TextSpan measureTextSpan,
      EdgeInsetsGeometry padding,
      AdvChooserController controller,
      Map<String, dynamic> items,
      int maxLineExpand,
      Color hintColor,
      Color labelColor,
      Color backgroundColor,
      Color borderColor,
      Color errorColor,
      this.itemChangeListener})
      : assert(measureText == null || measureTextSpan == null),
        assert(controller == null ||
            (text == null &&
                hint == null &&
                label == null &&
                error == null &&
                enable == null &&
                alignment == null &&
                items == null)),
        this.hintColor = hintColor ?? PitComponents.chooserHintColor,
        this.labelColor = labelColor ?? PitComponents.chooserLabelColor,
        this.backgroundColor =
            backgroundColor ?? PitComponents.chooserBackgroundColor,
        this.borderColor = borderColor ?? PitComponents.chooserBorderColor,
        this.errorColor = errorColor ?? PitComponents.chooserErrorColor,
        this.controller = controller ??
            new AdvChooserController(
                text: text ?? "",
                hint: hint ?? "",
                label: label ?? "",
                error: error ?? "",
                enable: enable ?? true,
                alignment: alignment ?? TextAlign.left,
                items: items ?? Map()),
        this.measureTextSpan = measureTextSpan ??
            new TextSpan(text: measureText, style: ts.fs16.merge(ts.tcBlack)),
        this.padding = padding ?? new EdgeInsets.all(0.0);

  @override
  State createState() => new _AdvChooserState();
}

class _AdvChooserState extends State<AdvChooser>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEdittingCtrl = new TextEditingController();
  int initialMaxLines;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
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
    return Container(child: LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        return AdvColumn(
          divider: ColumnDivider(2.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildChildren(maxWidth),
        );
      },
    ));
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
        ? widget.measureTextSpan.style.color
        : Color.lerp(
            widget.measureTextSpan.style.color, PitComponents.lerpColor, 0.6);
    final Color _hintColor = widget.controller.enable
        ? widget.hintColor
        : Color.lerp(widget.hintColor, PitComponents.lerpColor, 0.6);
    final Color _iconColor = widget.controller.enable
        ? Colors.grey.shade700
        : Color.lerp(Colors.grey.shade700, PitComponents.lerpColor, 0.6);

    var tp = new TextPainter(
        text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

    tp.layout();

    double width = tp.size.width == 0
        ? maxWidth
        : tp.size.width +
            _defaultWidthAddition +
            (_defaultInnerPadding * 2) +
            (widget.padding.horizontal);

    if (widget.controller.label != null && widget.controller.label != "") {
      children.add(
        AdvText(
          widget.controller.label,
          style: ts.fs11.merge(TextStyle(color: widget.labelColor)),
          maxLines: 1,
        ),
      );
    }

    TextEditingController controller = new TextEditingController();

    widget.controller.items.forEach((key, value) {
      if (key == widget.controller.text) {
        controller.text = value;
      }
    });

    Widget mainChild = Container(
      width: width,
      height: 60.0,
      padding: widget.padding,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
            minHeight: tp.size.height + _defaultHeightAddition
          /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result,
        ),
        child: new GestureDetector(
      onTap: () {
        if (!widget.controller.enable) return;
        Utils.pickFromChooser(context,
            title: widget.controller.label,
            items: widget.controller.items,
            currentItem: widget.controller.text,
            callback: _handleItemChanged);
      },
      child: AbsorbPointer(
        child: Theme(
              data: new ThemeData(
                cursorColor: Theme.of(context).cursorColor,
                accentColor: _backgroundColor,
                hintColor: widget.borderColor,
                primaryColor: widget.borderColor,
              ),
              child: ModTextField(
                controller: controller,
                onChanged: (newValue) {
                  _handleItemChanged(widget.controller.text, newValue);
                },
                enabled: widget.controller.enable,
                textAlign: widget.controller.alignment,
                style: widget.measureTextSpan.style.copyWith(color: _textColor),
                decoration: ModInputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        size: 24.0,
                        // These colors are not defined in the Material Design spec.
                        color: _iconColor),
                    filled: true,
                    fillColor: _backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(4.0),
                      ),
                      borderSide: new BorderSide(),
                    ),
                    contentPadding: new EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                    hintText: widget.controller.hint,
                    hintStyle: TextStyle(color: _hintColor.withOpacity(0.6))),
              ),
            ),
          ),
        ),
      ),
    );

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

  _handleItemChanged(String oldValue, String newValue) {
    widget.controller.removeListener(_update);

    String oldValue = widget.controller.text;
    widget.controller.text = newValue;
    widget.controller.error = "";

    widget.controller.addListener(_update);

    if (this.mounted) {
      setState(() {
        if (widget.itemChangeListener != null)
          widget.itemChangeListener(oldValue, newValue);
      });
    }
  }
}
