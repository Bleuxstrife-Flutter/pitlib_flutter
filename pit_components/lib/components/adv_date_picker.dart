import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_text.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/mods/mod_input_decorator.dart';
import 'package:pit_components/mods/mod_text_field.dart';
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/utils/utils.dart';

typedef void OnTextChanged(List<DateTime> value);

enum SelectionType { single, multi, range }

class MarkedDate {
  final DateTime date;
  final String note;

  MarkedDate(this.date, this.note);
}

class AdvDatePicker extends StatefulWidget {
  final AdvDatePickerController controller;
  final SelectionType selectionType;
  final TextSpan measureTextSpan;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final ValueChanged<List<DateTime>> onChanged;
  final DateFormat format;
  final Color backgroundColor;
  final Color borderColor;
  final Color hintColor;
  final Color labelColor;
  final Color errorColor;
  final bool withSwitcher;
  final bool withIcon;
  final ValueChanged<bool> onToggled;

  AdvDatePicker(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
      DateTime minDate,
      DateTime maxDate,
      String label,
      String hint,
      String error,
      bool enable,
      TextStyle textStyle,
      EdgeInsets padding,
      EdgeInsets margin,
      this.selectionType,
      DateFormat format,
      AdvDatePickerController controller,
      Color hintColor,
      Color labelColor,
      Color backgroundColor,
      Color borderColor,
      Color errorColor,
      bool withSwitcher,
      bool withIcon,
      this.onToggled,
      @required this.onChanged})
      : assert(controller == null ||
            (initialValue == null &&
                hint == null &&
                dates == null &&
                markedDates == null &&
                minDate == null &&
                maxDate == null &&
                error == null &&
                label == null &&
                enable == null)),
        this.format = format ?? new DateFormat("dd/MM/yyyy"),
        this.hintColor = hintColor ?? PitComponents.datePickerHintColor,
        this.labelColor = labelColor ?? PitComponents.datePickerLabelColor,
        this.backgroundColor = backgroundColor ?? PitComponents.datePickerBackgroundColor,
        this.borderColor = borderColor ?? PitComponents.datePickerBorderColor,
        this.errorColor = errorColor ?? PitComponents.datePickerErrorColor,
        this.controller = controller ??
            new AdvDatePickerController(
                initialValue: initialValue,
                dates: dates ?? [],
                markedDates: markedDates ?? [],
                minDate: minDate,
                maxDate: maxDate,
                hint: hint ?? "",
                error: error ?? "",
                label: label ?? "",
                enable: enable ?? true),
        this.measureTextSpan =
            TextSpan(text: "", style: textStyle ?? ts.fs16.copyWith(color: Colors.black87)),
        this.padding = padding ?? new EdgeInsets.all(0.0),
        this.margin = margin ?? PitComponents.editableMargin,
        this.withSwitcher = withSwitcher ?? false,
        this.withIcon = withIcon ?? true;

  @override
  State createState() => new _AdvDatePickerState();
}

class _AdvDatePickerState extends State<AdvDatePicker> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        return AdvColumn(
          margin: widget.margin,
          mainAxisSize: MainAxisSize.min,
          divider: ColumnDivider(2.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildChildren(context, maxWidth),
        );
      },
    );
  }

  List<Widget> _buildChildren(BuildContext context, double maxWidth) {
    final int _defaultWidthAddition = 2;
    final int _defaultHeightAddition = 24;
    final double _defaultInnerPadding = 8.0;

    final Color _backgroundColor = widget.controller.enable
        ? widget.backgroundColor
        : Color.lerp(widget.backgroundColor, PitComponents.lerpColor, 0.6);
    final Color _textColor = widget.controller.enable
        ? widget.measureTextSpan.style.color
        : Color.lerp(widget.measureTextSpan.style.color, PitComponents.lerpColor, 0.6);
    final Color _hintColor = widget.controller.enable
        ? widget.hintColor
        : Color.lerp(widget.hintColor, PitComponents.lerpColor, 0.6);
    final Color _iconColor = widget.controller.enable
        ? Colors.grey.shade700
        : Color.lerp(Colors.grey.shade700, PitComponents.lerpColor, 0.6);

    List<Widget> children = [];

    TextEditingController controller = new TextEditingController(
        text: widget.controller.initialValue == null
            ? ""
            : widget.format.format(widget.controller.initialValue));

    var tp = new TextPainter(text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

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

    double _iconSize = 18.0 / 16.0 * widget.measureTextSpan.style.fontSize;
    double _paddingSize = 8.0 / 16.0 * widget.measureTextSpan.style.fontSize;
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
//          minHeight: tp.size.height + _defaultHeightAddition,
        ),
        child: GestureDetector(
          onTap: () {
            _handleTap(context);
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
                textAlign: TextAlign.center,
                style: widget.measureTextSpan.style.copyWith(color: _textColor),
                decoration: ModInputDecoration(
                  suffixIcon: widget.withIcon
                      ? Container(
                          margin: EdgeInsets.only(right: widget.withSwitcher ? 34.0 : 0.0),
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.calendar_today,
                              size: _iconSize,
                              // These colors are not defined in the Material Design spec.
                              color: _iconColor))
                      : null,
                  filled: true,
                  fillColor: _backgroundColor,
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                    const Radius.circular(4.0),
                  ) /*,
                            borderSide: new BorderSide(
                              color: Colors.amber,
                              width: 1111.0,
                            )*/
                      ),
                  contentPadding: new EdgeInsets.all(_paddingSize),
                  hintText: widget.controller.hint,
                  hintStyle: TextStyle(color: _hintColor.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    List<Widget> stackChildren = [mainChild];

    if (widget.withSwitcher) {
      stackChildren.add(Positioned(
          child: Container(
            alignment: Alignment.center,
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: widget.controller.enable,
              onChanged: (v) {
                setState(() {
                  widget.controller.enable = v;
                });

                widget.onToggled(v);
              },
            ),
            width: 50.0,
            height: 20.0,
          ),
          right: 0.0,
          bottom: 0.0,
          top: 0.0));
    }

    children.add(Stack(children: stackChildren));

    if (widget.controller.error != null && widget.controller.error != "") {
      TextStyle style = ts.fs11.copyWith(color: widget.errorColor, fontWeight: ts.fw600.fontWeight);

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

  _update() {
    if (this.mounted) setState(() {});
  }

  void _handleTap(BuildContext context) async {
    if (!widget.controller.enable) return;

    List<DateTime> result = await Utils.pickDate(
      context,
      title: widget.controller.label,
      dates: widget.controller.dates,
      markedDates: widget.controller.markedDates,
      selectionType: widget.selectionType,
      minDate: widget.controller.minDate,
      maxDate: widget.controller.maxDate,
    );

    if (widget.onChanged != null) widget.onChanged(result);
    if (result != null && result.length > 0) widget.controller.dates = result;
  }
}
