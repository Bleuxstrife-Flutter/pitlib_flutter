import 'package:flutter/material.dart';

class AdvIncrementController extends ValueNotifier<AdvIncrementEditingValue> {
  int get counter => value.counter;

  set counter(int newCounter) {
    value = value.copyWith(
        counter: newCounter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  String get format => value.format;

  set format(String newFormat) {
    value = value.copyWith(
        counter: this.counter,
        format: newFormat,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: newHint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  String get label => value.label;

  set label(String newLabel) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: newLabel,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  String get error => value.error;

  set error(String newError) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: newError,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  int get minCounter => value.minCounter;

  set minCounter(int newMinCounter) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: newMinCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  int get maxCounter => value.maxCounter;

  set maxCounter(int newMaxCounter) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: newMaxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  int get maxLines => value.maxLines;

  set maxLines(int newLines) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: newLines,
        enable: this.enable,
        alignment: this.alignment);
  }

  bool get enable => value.enable;

  set enable(bool newEnable) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: newEnable,
        alignment: this.alignment);
  }

  TextAlign get alignment => value.alignment;

  set alignment(TextAlign newAlignment) {
    value = value.copyWith(
        counter: this.counter,
        format: this.format,
        hint: this.hint,
        label: this.label,
        error: this.error,
        minCounter: this.minCounter,
        maxCounter: this.maxCounter,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: newAlignment);
  }

  AdvIncrementController(
      {int counter,
      String format,
      String hint,
      String label,
      String error,
      int minCounter,
      int maxCounter,
      int maxLines,
      bool enable,
      TextAlign alignment})
      : super(counter == null &&
                hint == null &&
                format == null &&
                label == null &&
                error == null &&
                minCounter == null &&
                maxCounter == null &&
                maxLines == null &&
                enable == null &&
                alignment == null
            ? AdvIncrementEditingValue.empty
            : new AdvIncrementEditingValue(
                counter: counter ?? 0,
                format: format ?? "",
                hint: hint,
                label: label,
                error: error,
                minCounter: minCounter,
                maxCounter: maxCounter,
                maxLines: maxLines,
                enable: enable ?? true,
                alignment: alignment ?? TextAlign.center));

  AdvIncrementController.fromValue(AdvIncrementEditingValue value)
      : super(value ?? AdvIncrementEditingValue.empty);

  void clear() {
    value = AdvIncrementEditingValue.empty;
  }
}

@immutable
class AdvIncrementEditingValue {
  const AdvIncrementEditingValue(
      {this.counter = 0,
      this.format = '',
      this.hint = '',
      this.label = '',
      this.error = '',
      this.minCounter,
      this.maxCounter,
      this.maxLines = 1,
      this.enable = true,
      this.alignment = TextAlign.left});

  final int counter;
  final String format;
  final String hint;
  final String label;
  final String error;
  final int minCounter;
  final int maxCounter;
  final int maxLines;
  final bool enable;
  final TextAlign alignment;

  static const AdvIncrementEditingValue empty =
      const AdvIncrementEditingValue();

  AdvIncrementEditingValue copyWith(
      {int counter,
      String format,
      String hint,
      String label,
      String error,
      int minCounter,
      int maxCounter,
      int maxLines,
      bool enable,
      TextAlign alignment}) {
    return new AdvIncrementEditingValue(
        counter: counter,
        format: format,
        hint: hint,
        label: label,
        error: error,
        minCounter: minCounter,
        maxCounter: maxCounter,
        maxLines: maxLines,
        enable: enable,
        alignment: alignment);
  }

  AdvIncrementEditingValue.fromValue(AdvIncrementEditingValue copy)
      : this.counter = copy.counter,
        this.format = copy.format,
        this.hint = copy.hint,
        this.label = copy.label,
        this.error = copy.error,
        this.minCounter = copy.minCounter,
        this.maxCounter = copy.maxCounter,
        this.maxLines = copy.maxLines,
        this.enable = copy.enable,
        this.alignment = copy.alignment;

  @override
  String toString() =>
      '$runtimeType(counter: \u2524$counter\u251C, \u2524$format\u251C, \u2524$hint\u251C, \u2524$label\u251C, \u2524$error\u251C, minCounter: $minCounter, maxCounter: $maxCounter, maxLines: $maxLines, enable: $enable, alignment: $alignment)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvIncrementEditingValue) return false;
    final AdvIncrementEditingValue typedOther = other;
    return typedOther.counter == counter &&
        typedOther.format == format &&
        typedOther.hint == hint &&
        typedOther.label == label &&
        typedOther.error == error &&
        typedOther.minCounter == minCounter &&
        typedOther.maxCounter == maxCounter &&
        typedOther.maxLines == maxLines &&
        typedOther.enable == enable &&
        typedOther.alignment == alignment;
  }

  @override
  int get hashCode => hashValues(
      counter.hashCode,
      format.hashCode,
      hint.hashCode,
      label.hashCode,
      error.hashCode,
      minCounter.hashCode,
      maxCounter.hashCode,
      maxLines.hashCode,
      enable.hashCode,
      alignment.hashCode);
}
