import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_date_picker.dart';

class AdvDatePickerController extends ValueNotifier<AdvDatePickerEditingValue> {
  DateTime get initialValue => value.initialValue;

  set initialValue(DateTime newInitialValue) {
    value = value.copyWith(
        initialValue: newInitialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  List<DateTime> get dates => value.dates;

  set dates(List<DateTime> newDates) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: newDates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  List<MarkedDate> get markedDates => value.markedDates;

  set markedDates(List<MarkedDate> newMarkedDates) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: newMarkedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  DateTime get minDate => value.minDate;

  set minDate(DateTime newMinDate) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: newMinDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  DateTime get maxDate => value.maxDate;

  set maxDate(DateTime newMaxDate) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: newMaxDate,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: newHint,
        label: this.label,
        error: this.error,
        enable: this.enable);
  }

  String get label => value.label;

  set label(String newLabel) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: newLabel,
        error: this.error,
        enable: this.enable);
  }

  String get error => value.error;

  set error(String newError) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        minDate: this.minDate,
        maxDate: this.maxDate,
        hint: this.hint,
        label: this.label,
        error: newError,
        enable: this.enable);
  }

  bool get enable => value.enable;

  set enable(bool newEnable) {
    value = value.copyWith(
        initialValue: this.initialValue,
        dates: this.dates,
        markedDates: this.markedDates,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: newEnable,
        minDate: this.minDate,
        maxDate: this.maxDate);
  }

  AdvDatePickerController(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
        DateTime minDate,
        DateTime maxDate,
      String hint,
      String label,
      String error,
      bool enable})
      : super(initialValue == null &&
                dates == null &&
                markedDates == null &&
                minDate == null &&
                maxDate == null &&
                hint == null &&
                label == null &&
                error == null &&
                enable == null
            ? AdvDatePickerEditingValue.empty
            : new AdvDatePickerEditingValue(
                initialValue: initialValue,
                dates: dates,
                markedDates: markedDates,
                minDate: minDate,
                maxDate: maxDate,
                hint: hint,
                label: label,
                error: error,
                enable: enable));

  AdvDatePickerController.fromValue(AdvDatePickerEditingValue value) : super(value ?? AdvDatePickerEditingValue.empty);

  void clear() {
    value = AdvDatePickerEditingValue.empty;
  }
}

@immutable
class AdvDatePickerEditingValue {
  const AdvDatePickerEditingValue(
      {this.initialValue,
      List<DateTime> dates = const [],
      List<MarkedDate> markedDates = const [],
      DateTime minDate,
      DateTime maxDate,
      String hint = '',
      String label = '',
      String error = '',
      bool enable = true})
      : this.dates = dates ?? const [],
        this.markedDates = markedDates ?? const [],
        this.minDate = minDate,
        this.maxDate = maxDate,
        this.hint = hint ?? '',
        this.label = label ?? '',
        this.error = error ?? '',
        this.enable = enable ?? true;

  final DateTime initialValue;
  final List<DateTime> dates;
  final List<MarkedDate> markedDates;
  final DateTime minDate;
  final DateTime maxDate;
  final String hint;
  final String label;
  final String error;
  final bool enable;

  static const AdvDatePickerEditingValue empty = const AdvDatePickerEditingValue();

  AdvDatePickerEditingValue copyWith(
      {DateTime initialValue,
      List<DateTime> dates,
      List<MarkedDate> markedDates,
      DateTime minDate,
      DateTime maxDate,
      String hint,
      String label,
      String error,
      bool enable}) {
    return new AdvDatePickerEditingValue(
        initialValue: initialValue,
        dates: dates,
        markedDates: markedDates,
        minDate: minDate,
        maxDate: maxDate,
        hint: hint,
        label: label,
        error: error,
        enable: enable);
  }

  AdvDatePickerEditingValue.fromValue(AdvDatePickerEditingValue copy)
      : this.initialValue = copy.initialValue,
        this.dates = copy.dates,
        this.markedDates = copy.markedDates,
        this.minDate = copy.minDate,
        this.maxDate = copy.maxDate,
        this.hint = copy.hint,
        this.label = copy.label,
        this.error = copy.error,
        this.enable = copy.enable;

  @override
  String toString() => '$runtimeType(initialValue: \u2524$initialValue\u251C, '
      'dates: \u2524$dates\u251C, '
      'markedDates: \u2524$markedDates\u251C, '
      'minDate: \u2524$minDate\u251C, '
      'maxDate: \u2524$maxDate\u251C, '
      'hint: \u2524$hint\u251C, '
      'label: \u2524$label\u251C, '
      'error: \u2524$error\u251C, '
      'enable: \u2524$enable\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvDatePickerEditingValue) return false;
    final AdvDatePickerEditingValue typedOther = other;
    return typedOther.initialValue == initialValue &&
        typedOther.dates == dates &&
        typedOther.markedDates == markedDates &&
        typedOther.minDate == minDate &&
        typedOther.maxDate == maxDate &&
        typedOther.hint == hint &&
        typedOther.label == label &&
        typedOther.error == error &&
        typedOther.enable == enable;
  }

  @override
  int get hashCode => hashValues(initialValue.hashCode, dates.hashCode, markedDates.hashCode, minDate.hashCode, maxDate.hashCode,
      hint.hashCode, label.hashCode, error.hashCode, enable.hashCode);
}
