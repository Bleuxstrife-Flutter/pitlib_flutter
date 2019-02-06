import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:intl/intl.dart';

typedef RangeSliderCallback(double lowerValue, double upperValue);

class AdvRangeSlider extends StatefulWidget {
  final AdvRangeSliderController controller;
  final RangeSliderCallback onChanged;
  final NumberFormat numberFormat;

  AdvRangeSlider(
      {double lowerValue,
      double upperValue,
      double min,
      double max,
      int divisions,
      String hint,
      bool enable,
      this.onChanged,
      NumberFormat numberFormat,
      AdvRangeSliderController controller})
      : assert(controller == null ||
            (lowerValue == null &&
                upperValue == null &&
                min == null &&
                max == null &&
                divisions == null &&
                hint == null &&
                enable == null)),
        assert(lowerValue != null || controller.lowerValue != null),
        assert(upperValue != null || controller.upperValue != null),
        assert(min != null || controller.min != null),
        assert(max != null || controller.max != null),
        assert(divisions != null || controller.divisions != null),
        assert((max != null && min != null && max >= min) ||
            controller.max >= controller.min),
        assert((divisions != null && divisions <= 10000) ||
            controller.divisions <= 10000),
        assert(onChanged != null),
        this.controller = controller ??
            new AdvRangeSliderController(
                lowerValue: lowerValue ?? 0.0,
                upperValue: upperValue ?? 100.0,
                min: min ?? 0.0,
                max: max ?? 100.0,
                divisions: divisions ?? 100,
                hint: hint ?? "",
                enable: enable ?? true),
        this.numberFormat = numberFormat ?? new NumberFormat("#,###");

  @override
  State createState() => new _AdvRangeSliderState();
}

class _AdvRangeSliderState extends State<AdvRangeSlider>
    with SingleTickerProviderStateMixin {
  AdvRangeSliderController _initialController;
  AdvRangeSliderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdvRangeSliderController.fromValue(widget.controller.value);
    _initialController =
        AdvRangeSliderController.fromValue(widget.controller.value);
    widget.controller.addListener(_updateFromWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          child: AbsorbPointer(
            child: new TextField(
              controller: new TextEditingController(text: "asd"),
              maxLines: 2,
              style: TextStyle(color: Colors.transparent),
              decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(4.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    )),
                contentPadding: new EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                labelText: _controller.hint,
              ),
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 12.0),
//                  padding: const EdgeInsets.all(4.0),
          child: new Container(
            height: 20.0,
            child: new RangeSlider(
              min: _controller.min,
              max: _controller.max,
              lowerValue: _controller.lowerValue,
              upperValue: _controller.upperValue,
              divisions: _controller.divisions,
              valueIndicatorMaxDecimals: 1,
              onChanged: (double newLowerValue, double newUpperValue) {
                setState(() {
                  _controller.lowerValue = newLowerValue;
                  _controller.upperValue = newUpperValue;
                });
              },
              onChangeStart:
                  (double startLowerValue, double startUpperValue) {},
              onChangeEnd: (double newLowerValue, double newUpperValue) {
                widget.onChanged(newLowerValue, newUpperValue);
              },
            ),
          ),
        ),
        new Positioned(
          top: 30.0,
          left: 12.0,
          right: 12.0,
          child: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double equalWidth = constraints.maxWidth / 2;
            return new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Container(
                  width: equalWidth,
//                            color: Colors.blue,
                  padding: EdgeInsets.only(
                      left: 4.0, top: 4.0, bottom: 4.0, right: 4.0),
                  child: new Text(
                    "${widget.numberFormat.format(_controller.lowerValue)}",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
//                          style: TextStyle(fontSize: 12.0),
                  ),
                ),
                new Container(
                  width: equalWidth,
//                            color: Colors.red,
                  padding: EdgeInsets.only(
                      left: 4.0, top: 4.0, bottom: 4.0, right: 4.0),
                  child: new Text(
                    "${widget.numberFormat.format(_controller.upperValue)}",
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            );
          }),
        ),
      ],
    );
  }

  _updateFromWidget() {
    if (widget.controller.lowerValue != _initialController.lowerValue)
      _controller.lowerValue = widget.controller.lowerValue;

    if (widget.controller.upperValue != _initialController.upperValue)
      _controller.upperValue = widget.controller.upperValue;

    if (widget.controller.min != _initialController.min)
      _controller.min = widget.controller.min;

    if (widget.controller.max != _initialController.max)
      _controller.max = widget.controller.max;

    if (widget.controller.divisions != _initialController.divisions)
      _controller.divisions = widget.controller.divisions;

    if (widget.controller.hint != _initialController.hint)
      _controller.hint = widget.controller.hint;

    if (widget.controller.enable != _initialController.enable)
      _controller.enable = widget.controller.enable;

    _initialController =
        AdvRangeSliderController.fromValue(widget.controller.value);
    setState(() {});
  }

  @override
  void didUpdateWidget(AdvRangeSlider oldWidget) {
    _initialController =
        AdvRangeSliderController.fromValue(widget.controller.value);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_updateFromWidget);
      widget.controller.addListener(_updateFromWidget);
    }
    if (oldWidget.controller != null && widget.controller == null) {
      widget.controller.value =
          AdvRangeSliderEditingValue.fromValue(oldWidget.controller.value);
    }

    if (oldWidget.controller.value != widget.controller.value) {
      _controller.value =
          AdvRangeSliderEditingValue.fromValue(widget.controller.value);
    }
    super.didUpdateWidget(oldWidget);
  }
}

class AdvRangeSliderController
    extends ValueNotifier<AdvRangeSliderEditingValue> {
  double get lowerValue => value.lowerValue;

  set lowerValue(double newLowerValue) {
    value = value.copyWith(
        lowerValue: newLowerValue,
        upperValue: this.upperValue,
        min: this.min,
        max: this.max,
        divisions: this.divisions,
        hint: this.hint,
        enable: this.enable);
  }

  double get upperValue => value.upperValue;

  set upperValue(double newUpperValue) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: newUpperValue,
        min: this.min,
        max: this.max,
        divisions: this.divisions,
        hint: this.hint,
        enable: this.enable);
  }

  double get min => value.min;

  set min(double newMin) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: this.upperValue,
        min: newMin,
        max: this.max,
        divisions: this.divisions,
        hint: this.hint,
        enable: this.enable);
  }

  double get max => value.max;

  set max(double newMax) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: this.upperValue,
        min: this.min,
        max: newMax,
        divisions: this.divisions,
        hint: this.hint,
        enable: this.enable);
  }

  int get divisions => value.divisions;

  set divisions(int newDivisions) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: this.upperValue,
        min: this.min,
        max: this.max,
        divisions: newDivisions,
        hint: this.hint,
        enable: this.enable);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: this.upperValue,
        min: this.min,
        max: this.max,
        divisions: this.divisions,
        hint: newHint,
        enable: this.enable);
  }

  bool get enable => value.enable;

  set enable(bool newEnable) {
    value = value.copyWith(
        lowerValue: this.lowerValue,
        upperValue: this.upperValue,
        min: this.min,
        max: this.max,
        divisions: this.divisions,
        hint: this.hint,
        enable: newEnable);
  }

  AdvRangeSliderController(
      {double lowerValue,
      double upperValue,
      double min,
      double max,
      int divisions,
      String hint,
      bool enable})
      : assert(lowerValue != null),
        assert(upperValue != null),
        assert(min != null),
        assert(max != null),
        assert(divisions != null),
        assert(max > min),
        assert(divisions <= 10000),
        super(new AdvRangeSliderEditingValue(
            lowerValue: lowerValue,
            upperValue: upperValue,
            min: min,
            max: max,
            divisions: divisions,
            hint: hint ?? "",
            enable: enable ?? true));

  AdvRangeSliderController.fromValue(AdvRangeSliderEditingValue value)
      : super(value ?? AdvRangeSliderEditingValue.empty);

  void clear() {
    value = AdvRangeSliderEditingValue.empty;
  }
}

@immutable
class AdvRangeSliderEditingValue {
  const AdvRangeSliderEditingValue(
      {this.lowerValue = 0.0,
      this.upperValue = 100.0,
      this.min = 0.0,
      this.max = 100.0,
      this.divisions = 100,
      this.hint = "",
      this.enable = true});

  final double lowerValue;
  final double upperValue;
  final double min;
  final double max;
  final int divisions;
  final String hint;
  final bool enable;

  static const AdvRangeSliderEditingValue empty =
      const AdvRangeSliderEditingValue();

  AdvRangeSliderEditingValue copyWith(
      {double lowerValue,
      double upperValue,
      double min,
      double max,
      int divisions,
      String hint,
      bool enable}) {
    return new AdvRangeSliderEditingValue(
        lowerValue: lowerValue ?? this.lowerValue,
        upperValue: upperValue ?? this.upperValue,
        min: min ?? this.min,
        max: max ?? this.max,
        divisions: divisions ?? this.divisions,
        hint: hint ?? this.hint,
        enable: enable ?? this.enable);
  }

  AdvRangeSliderEditingValue.fromValue(AdvRangeSliderEditingValue copy)
      : this.lowerValue = copy.lowerValue,
        this.upperValue = copy.upperValue,
        this.min = copy.min,
        this.max = copy.max,
        this.divisions = copy.divisions,
        this.hint = copy.hint,
        this.enable = copy.enable;

  @override
  String toString() => '$runtimeType(lowerValue: \u2524$lowerValue\u251C, '
      'upperValue: \u2524$upperValue\u251C, '
      'min: \u2524$min\u251C, '
      'max: \u2524$max\u251C, '
      'divisions: \u2524$divisions\u251C, '
      'hint: \u2524$hint\u251C, '
      'enable: \u2524$enable\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvRangeSliderEditingValue) return false;
    final AdvRangeSliderEditingValue typedOther = other;
    return typedOther.lowerValue == lowerValue &&
        typedOther.upperValue == upperValue &&
        typedOther.min == min &&
        typedOther.max == max &&
        typedOther.divisions == divisions &&
        typedOther.hint == hint &&
        typedOther.enable == enable;
  }

  @override
  int get hashCode => hashValues(
      lowerValue.hashCode,
      upperValue.hashCode,
      min.hashCode,
      max.hashCode,
      divisions.hashCode,
      hint.hashCode,
      enable.hashCode);
}
