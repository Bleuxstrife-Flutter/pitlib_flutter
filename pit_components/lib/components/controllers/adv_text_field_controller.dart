import 'package:flutter/material.dart';

class AdvTextFieldController extends ValueNotifier<AdvTextFieldEditingValue> {
  String get text => value.text;

  set text(String newText) {
    value = value.copyWith(
        text: newText,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        text: this.text,
        hint: newHint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  String get label => value.label;

  set label(String newLabel) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: newLabel,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  String get error => value.error;

  set error(String newError) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: newError,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  int get maxLength => value.maxLength;

  set maxLength(int newMaxLength) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: newMaxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  bool get maxLengthEnforced => value.maxLengthEnforced;

  set maxLengthEnforced(bool newMaxLengthEnforced) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: newMaxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  int get maxLines => value.maxLines;

  set maxLines(int newLines) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: newLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  bool get enable => value.enable;

  set enable(bool newEnable) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: newEnable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  TextAlign get alignment => value.alignment;

  set alignment(TextAlign newAlignment) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: newAlignment,
        obscureText: this.obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  bool get obscureText => value.obscureText;

  set obscureText(bool newObscureText) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: newObscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: this.suffixIcon);
  }

  Widget get prefixIcon => value.prefixIcon;

  set prefixIcon(Widget newPrefixIcon) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: this.obscureText,
        prefixIcon: newPrefixIcon,
        suffixIcon: this.suffixIcon);
  }

  Widget get suffixIcon => value.suffixIcon;

  set suffixIcon(Widget newSuffixIcon) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        label: this.label,
        error: this.error,
        maxLength: this.maxLength,
        maxLengthEnforced: this.maxLengthEnforced,
        maxLines: this.maxLines,
        enable: this.enable,
        alignment: this.alignment,
        obscureText: obscureText,
        prefixIcon: this.prefixIcon,
        suffixIcon: newSuffixIcon);
  }

  AdvTextFieldController(
      {String text,
        String hint,
        String label,
        String error,
        int maxLength,
        bool maxLengthEnforced,
        int maxLines,
        bool enable,
        TextAlign alignment,
        bool obscureText,
        Widget prefixIcon,
        Widget suffixIcon})
      : super(text == null &&
      hint == null &&
      label == null &&
      error == null &&
      maxLength == null &&
      maxLengthEnforced == null &&
      maxLines == null &&
      enable == null &&
      alignment == null &&
      obscureText == null &&
      prefixIcon == null &&
      suffixIcon == null
      ? AdvTextFieldEditingValue.empty
      : new AdvTextFieldEditingValue(
      text: text,
      hint: hint,
      label: label,
      error: error,
      maxLength: maxLength,
      maxLengthEnforced: maxLengthEnforced ?? false,
      maxLines: maxLines,
      enable: enable ?? true,
      alignment: alignment ?? TextAlign.left,
      obscureText: obscureText ?? false,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon));

  AdvTextFieldController.fromValue(AdvTextFieldEditingValue value)
      : super(value ?? AdvTextFieldEditingValue.empty);

  void clear() {
    value = AdvTextFieldEditingValue.empty;
  }
}

@immutable
class AdvTextFieldEditingValue {
  const AdvTextFieldEditingValue(
      {this.text = '',
        this.hint = '',
        this.label = '',
        this.error = '',
        this.maxLength,
        this.maxLengthEnforced = false,
        this.maxLines,
        this.enable = true,
        this.alignment = TextAlign.left,
        this.obscureText = false,
        this.prefixIcon,
        this.suffixIcon});

  final String text;
  final String hint;
  final String label;
  final String error;
  final int maxLength;
  final bool maxLengthEnforced;
  final int maxLines;
  final bool enable;
  final TextAlign alignment;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget suffixIcon;

  static const AdvTextFieldEditingValue empty =
  const AdvTextFieldEditingValue();

  AdvTextFieldEditingValue copyWith(
      {String text,
        String hint,
        String label,
        String error,
        int maxLength,
        bool maxLengthEnforced,
        int maxLines,
        bool enable,
        TextAlign alignment,
        bool obscureText,
        Widget prefixIcon,
        Widget suffixIcon}) {
    return new AdvTextFieldEditingValue(
        text: text ?? this.text,
        hint: hint ?? this.hint,
        label: label ?? this.label,
        error: error ?? this.error,
        maxLength: maxLength ?? this.maxLength,
        maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced,
        maxLines: maxLines ?? this.maxLines,
        enable: enable ?? this.enable,
        alignment: alignment ?? this.alignment,
        obscureText: obscureText ?? this.obscureText,
        prefixIcon: prefixIcon ?? this.prefixIcon,
        suffixIcon: suffixIcon ?? this.suffixIcon);
  }

  AdvTextFieldEditingValue.fromValue(AdvTextFieldEditingValue copy)
      : this.text = copy.text,
        this.hint = copy.hint,
        this.label = copy.label,
        this.error = copy.error,
        this.maxLength = copy.maxLength,
        this.maxLengthEnforced = copy.maxLengthEnforced,
        this.maxLines = copy.maxLines,
        this.enable = copy.enable,
        this.alignment = copy.alignment,
        this.obscureText = copy.obscureText,
        this.prefixIcon = copy.prefixIcon,
        this.suffixIcon = copy.suffixIcon;

  @override
  String toString() =>
      '$runtimeType(text: \u2524$text\u251C, \u2524$hint\u251C, \u2524$label\u251C, \u2524$error\u251C, maxLength: $maxLength, maxLengthEnforced: $maxLengthEnforced, maxLines: $maxLines, enable: $enable, alignment: $alignment, obscureText: $obscureText, prefixIcon: $prefixIcon, suffixIcon: $suffixIcon)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvTextFieldEditingValue) return false;
    final AdvTextFieldEditingValue typedOther = other;
    return typedOther.text == text &&
        typedOther.hint == hint &&
        typedOther.label == label &&
        typedOther.error == error &&
        typedOther.maxLength == maxLength &&
        typedOther.maxLengthEnforced == maxLengthEnforced &&
        typedOther.maxLines == maxLines &&
        typedOther.enable == enable &&
        typedOther.alignment == alignment &&
        typedOther.obscureText == obscureText &&
        typedOther.prefixIcon == prefixIcon &&
        typedOther.suffixIcon == suffixIcon;
  }

  @override
  int get hashCode => hashValues(
      text.hashCode,
      hint.hashCode,
      label.hashCode,
      error.hashCode,
      maxLength.hashCode,
      maxLengthEnforced.hashCode,
      maxLines.hashCode,
      enable.hashCode,
      alignment.hashCode,
      obscureText.hashCode,
      prefixIcon.hashCode,
      suffixIcon.hashCode);
}
