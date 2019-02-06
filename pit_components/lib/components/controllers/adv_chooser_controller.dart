import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_group_check.dart';

class AdvChooserController extends ValueNotifier<AdvChooserEditingValue> {
  String get text => value.text;

  set text(String newText) {
    value = value.copyWith(
        text: newText,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable,
        alignment: this.alignment,
        items: this.items);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        text: this.text,
        hint: newHint,
        label: this.label,
        error: this.error,
        enable: this.enable,
        alignment: this.alignment,
        items: this.items);
  }

  String get label => value.label;

  set label(String newLabel) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: newLabel,
        error: this.error,
        enable: this.enable,
        alignment: this.alignment,
        items: this.items);
  }

  String get error => value.error;

  set error(String newError) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: newError,
        enable: this.enable,
        alignment: this.alignment,
        items: this.items);
  }

  bool get enable => value.enable;

  set enable(bool newEnable) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: newEnable,
        alignment: this.alignment,
        items: this.items);
  }

  TextAlign get alignment => value.alignment;

  set alignment(TextAlign newAlignment) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable,
        alignment: newAlignment,
        items: this.items);
  }

  List<GroupCheckItem> get items => value.items;

  set items(List<GroupCheckItem> newItems) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        enable: this.enable,
        alignment: this.alignment,
        items: newItems);
  }

  AdvChooserController(
      {String text,
      String hint,
      String label,
      String error,
      bool enable,
      TextAlign alignment,
      List<GroupCheckItem> items})
      : super(text == null &&
                hint == null &&
                label == null &&
                error == null &&
                enable == null &&
                alignment == null &&
                items == null
            ? AdvChooserEditingValue.empty
            : new AdvChooserEditingValue(
                text: text,
                hint: hint,
                label: label,
                error: error,
                enable: enable ?? true,
                alignment: alignment ?? TextAlign.left,
                items: items));

  AdvChooserController.fromValue(AdvChooserEditingValue value)
      : super(value ?? AdvChooserEditingValue.empty);

  void clear() {
    value = AdvChooserEditingValue.empty;
  }
}

@immutable
class AdvChooserEditingValue {
  const AdvChooserEditingValue(
      {this.text = '',
      this.hint = '',
      this.label = '',
      this.error = '',
      this.enable = true,
      this.alignment = TextAlign.left,
      this.items});

  final String text;
  final String hint;
  final String label;
  final String error;
  final bool enable;
  final TextAlign alignment;
  final List<GroupCheckItem> items;

  static const AdvChooserEditingValue empty = const AdvChooserEditingValue();

  AdvChooserEditingValue copyWith(
      {String text,
      String hint,
      String label,
      String error,
      bool enable,
      TextAlign alignment,
      List<GroupCheckItem> items}) {
    return new AdvChooserEditingValue(
        text: text ?? this.text,
        hint: hint ?? this.hint,
        label: label ?? this.label,
        error: error ?? this.error,
        enable: enable ?? this.enable,
        alignment: alignment ?? this.alignment,
        items: items ?? this.items);
  }

  AdvChooserEditingValue.fromValue(AdvChooserEditingValue copy)
      : this.text = copy.text,
        this.hint = copy.hint,
        this.label = copy.label,
        this.error = copy.error,
        this.enable = copy.enable,
        this.alignment = copy.alignment,
        this.items = copy.items;

  @override
  String toString() => '$runtimeType(text: \u2524$text\u251C, '
      'hint: $hint, '
      'label: $label, '
      'error: $error, '
      'enable: $enable, '
      'alignment: $alignment, '
      'items: $items)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvChooserEditingValue) return false;
    final AdvChooserEditingValue typedOther = other;
    return typedOther.text == text &&
        typedOther.hint == hint &&
        typedOther.label == label &&
        typedOther.error == error &&
        typedOther.enable == enable &&
        typedOther.alignment == alignment &&
        typedOther.items == items;
  }

  @override
  int get hashCode => hashValues(text.hashCode, hint.hashCode, label.hashCode,
      error.hashCode, enable.hashCode, alignment.hashCode, items.hashCode);
}
