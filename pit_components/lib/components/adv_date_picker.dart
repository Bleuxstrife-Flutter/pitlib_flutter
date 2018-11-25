import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/extras/com_calendar_carousel.dart';
import 'package:pit_components/components/extras/com_date_picker_page.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;

typedef void OnTextChanged(List<DateTime> value);

class MarkedDate {
  final DateTime date;
  final String note;

  MarkedDate(this.date, this.note);
}

class AdvDatePicker extends StatefulWidget {
  final AdvDatePickerController controller;
  final SelectionType selectionType;
  final TextSpan measureTextSpan;
  final EdgeInsetsGeometry padding;
  final FormFieldValidator<String> validator;
  final ValueChanged<List<DateTime>> onChanged;
  final DateFormat format;

  AdvDatePicker(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
      String hint,
      String measureText,
      TextSpan measureTextSpan,
      EdgeInsetsGeometry padding,
      this.validator,
      this.selectionType,
      DateFormat format,
      AdvDatePickerController controller,
      @required this.onChanged})
      : assert(measureText == null || measureTextSpan == null),
        assert(controller == null ||
            (hint == null &&
                dates == null &&
                markedDates == null &&
                hint == null)),
        this.format = format ?? new DateFormat("dd/MM/yyyy"),
        this.controller = controller ??
            new AdvDatePickerController(
                initialValue: initialValue,
                dates: dates ?? [],
                markedDates: markedDates ?? [],
                hint: hint ?? ""),
        this.measureTextSpan =
            measureTextSpan ?? new TextSpan(text: measureText, style: ts.fs16),
        this.padding = padding ?? new EdgeInsets.all(0.0);

  @override
  State createState() => new _AdvDatePickerState();
}

class _AdvDatePickerState extends State<AdvDatePicker>
    with SingleTickerProviderStateMixin {
  AdvDatePickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    widget.controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final int _defaultWidthAddition = 2;
    final int _defaultHeightAddition = 24;
    final double _defaultInnerPadding = 8.0;
    int maxLengthHeight = 0;

    TextEditingController controller = new TextEditingController(
        text: _controller.initialValue == null
            ? ""
            : widget.format.format(_controller.initialValue));

    var tp = new TextPainter(
        text: widget.measureTextSpan, textDirection: ui.TextDirection.ltr);

    tp.layout();

    double width = tp.size.width == 0
        ? null
        : tp.size.width +
            _defaultWidthAddition +
            (_defaultInnerPadding * 2) +
            (widget.padding.horizontal);

    Widget result = new Container(
      width: width,
      padding: widget.padding,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: tp.size.height +
              _defaultHeightAddition +
              /*(widget.padding.vertical) +*/ //I have to comment this out because when you just specify bottom padding, it produce strange result
              maxLengthHeight,
        ),
        child: new Center(
          child: GestureDetector(
            onTap: _handleTap,
            child: AbsorbPointer(
              child: new Stack(
                children: [
                  new Container(
                    child: new TextFormField(
                      controller: controller,
                      validator: widget.validator,
                      textAlign: TextAlign.center,
                      style: widget.measureTextSpan.style,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            )),
                        contentPadding: new EdgeInsets.only(
                            left: _defaultInnerPadding,
                            right: _defaultInnerPadding + 16.0,
                            top: 16.0,
                            bottom: 8.0),
                        labelText: _controller.hint,
                      ),
                    ),
                  ),
                  new Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    right: 8.0,
                    child: new Icon(Icons.calendar_today,
                        size: 18.0,
                        // These colors are not defined in the Material Design spec.
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade700
                            : Colors.white70),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (width == null) {
      result = new Row(children: [new Expanded(child: result)]);
    }

    return result;
  }

  _update() {
    setState(() {});
  }

  void _handleTap() async {
    List<DateTime> result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ComDatePickerPage(
                currentDate: _controller.dates,
                markedDates: _controller.markedDates,
                selectionType: widget.selectionType ?? SelectionType.single,
              ),
          settings: RouteSettings(name: widget.runtimeType.toString())),
    );

    if (widget.onChanged != null) widget.onChanged(result);
    _controller.dates = result;
  }
}

class AdvDatePickerController extends ValueNotifier<AdvDatePickerEditingValue> {
  DateTime get initialValue => value.initialValue;

  set initialValue(DateTime newInitialValue) {
    value = value.copyWith(
        initialValue: newInitialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        hint: this.hint);
  }

  List<DateTime> get dates => value.dates;

  set dates(List<DateTime> newDates) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: newDates,
        markedDates: this.markedDates,
        hint: this.hint);
  }

  List<MarkedDate> get markedDates => value.markedDates;

  set markedDates(List<MarkedDate> newMarkedDates) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: newMarkedDates,
        hint: this.hint);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        hint: newHint);
  }

  AdvDatePickerController(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
      String hint})
      : super(initialValue == null &&
                dates == null &&
                markedDates == null &&
                hint == null
            ? AdvDatePickerEditingValue.empty
            : new AdvDatePickerEditingValue(
                initialValue: initialValue,
                dates: dates,
                markedDates: markedDates,
                hint: hint));

  AdvDatePickerController.fromValue(AdvDatePickerEditingValue value)
      : super(value ?? AdvDatePickerEditingValue.empty);

  void clear() {
    value = AdvDatePickerEditingValue.empty;
  }
}

@immutable
class AdvDatePickerEditingValue {
  const AdvDatePickerEditingValue(
      {this.initialValue,
      this.dates = const [],
      this.markedDates = const [],
      this.hint = ''});

  final DateTime initialValue;
  final List<DateTime> dates;
  final List<MarkedDate> markedDates;
  final String hint;

  static const AdvDatePickerEditingValue empty =
      const AdvDatePickerEditingValue();

  AdvDatePickerEditingValue copyWith(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
      String hint}) {
    return new AdvDatePickerEditingValue(
        initialValue: initialValue ?? this.initialValue,
        dates: dates ?? this.dates,
        markedDates: markedDates ?? this.markedDates,
        hint: hint ?? this.hint);
  }

  AdvDatePickerEditingValue.fromValue(AdvDatePickerEditingValue copy)
      : this.initialValue = copy.initialValue,
        this.dates = copy.dates,
        this.markedDates = copy.markedDates,
        this.hint = copy.hint;

  @override
  String toString() =>
      '$runtimeType(initialValue: \u2524$initialValue\u251C, dates: \u2524$dates\u251C, markedDates: \u2524$markedDates\u251C, hint: \u2524$hint\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvDatePickerEditingValue) return false;
    final AdvDatePickerEditingValue typedOther = other;
    return typedOther.initialValue == initialValue &&
        typedOther.dates == dates &&
        typedOther.markedDates == markedDates &&
        typedOther.hint == hint;
  }

  @override
  int get hashCode => hashValues(initialValue.hashCode, dates.hashCode,
      markedDates.hashCode, hint.hashCode);
}
