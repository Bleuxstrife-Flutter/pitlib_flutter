import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';

enum ButtonSize { small, large }

final Color lerpColor = Color(0xffD1D1D1);

class AdvButton extends StatelessWidget {
  final String data;
  final bool enable;
  final VoidCallback onPressed;
  final bool circular;
  final ButtonSize buttonSize;
  final bool onlyBorder;
  final bool reverse;
  final bool bold;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final EdgeInsets padding;

  AdvButton(this.data,
      {bool circular = true,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      this.bold,
      this.onPressed,
      this.buttonSize = ButtonSize.large,
      Color backgroundColor,
      Color textColor,
      this.width,
      EdgeInsets padding})
      : this.enable = enable ?? true,
        this.circular = circular ?? true,
        this.onlyBorder = onlyBorder ?? false,
        this.reverse = reverse ?? false,
        this.backgroundColor = !reverse
            ? backgroundColor ?? PitComponents.buttonBackgroundColor
            : textColor ?? PitComponents.buttonTextColor,
        this.textColor = !reverse
            ? textColor ?? PitComponents.buttonTextColor
            : backgroundColor ?? PitComponents.buttonBackgroundColor,
        this.padding = padding ?? EdgeInsets.all(0.0);

  @override
  Widget build(BuildContext context) {
    switch (this.buttonSize) {
      case ButtonSize.small:
        return _buildTinyButton(context);
      default:
        return _buildLargeButton(context);
    }
  }

  _defaultCallback() {}

  Widget _buildTinyButton(BuildContext context) {
    bool _bold = this.bold ?? false;
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableTextColor = Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);

    ShapeBorder border = RoundedRectangleBorder(
        side: BorderSide(
            color: enable ? backgroundColor : disableBackgroundColor, width: borderWidth),
        borderRadius: new BorderRadius.circular(this.circular ? 5.0 : 0.0));

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor = onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor = !onlyBorder ? disableTextColor : disableBackgroundColor;

    return ButtonTheme(
        minWidth: 0.0,
        height: 0.0,
        child: Container(
            width: width,
            child: FlatButton(
              padding: EdgeInsets.only(
                  left: this.padding.left + 8.0 + borderWidthAdditional,
                  top: this.padding.top + 8.0 + borderWidthAdditional,
                  right: this.padding.right + 8.0 + borderWidthAdditional,
                  bottom: this.padding.bottom + 8.0 + borderWidthAdditional),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: _color,
              disabledColor: _disableColor,
              disabledTextColor: _disableTextColor,
              highlightColor: Theme.of(context).dividerColor,
              splashColor: Theme.of(context).dividerColor,
              child: new Text(this.data,
                  style: ts.fs12
                      .merge(_bold ? ts.fw600 : ts.fw)
                      .copyWith(color: enable ? _textColor : _disableTextColor)),
              onPressed: enable ? this.onPressed ?? _defaultCallback : null,
              shape: border,
            )));
  }

  Widget _buildLargeButton(BuildContext context) {
    bool _bold = this.bold ?? true;
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableTextColor = Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor = onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor = !onlyBorder ? disableTextColor : disableBackgroundColor;

    return ButtonTheme(
        minWidth: 0.0,
        height: 0.0,
        child: Container(
            width: width,
            child: FlatButton(
              padding: EdgeInsets.only(
                  left: this.padding.left + 14.0 + borderWidthAdditional,
                  top: this.padding.top + 14.0 + borderWidthAdditional,
                  right: this.padding.right + 14.0 + borderWidthAdditional,
                  bottom: this.padding.bottom + 14.0 + borderWidthAdditional),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//        borderSide:
//            BorderSide(color: Theme.of(context).primaryColorDark, width: 3.0),
              color: _color,
              disabledColor: _disableColor,
              disabledTextColor: _disableTextColor,
              highlightColor: Theme.of(context).dividerColor,
              splashColor: Theme.of(context).dividerColor,
              child: new Text(this.data,
                  style: ts.fs16
                      .merge(_bold ? ts.fw700 : ts.fw)
                      .copyWith(color: enable ? _textColor : _disableTextColor)),
              onPressed: enable ? this.onPressed ?? _defaultCallback : null,
              shape: new RoundedRectangleBorder(
                side: BorderSide(
                    color: enable ? backgroundColor : disableBackgroundColor, width: borderWidth),
                borderRadius: new BorderRadius.circular(this.circular ? 5.0 : 0.0),
              ),
            )));
  }
}

class AdvButtonWithIcon extends StatelessWidget {
  final String data;
  final bool enable;
  final Widget image;
  final Axis direction;
  final VoidCallback onPressed;
  final bool circular;
  final ButtonSize buttonSize;
  final bool onlyBorder;
  final bool reverse;
  final bool bold;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final EdgeInsets padding;

  AdvButtonWithIcon(this.data, this.image, this.direction,
      {bool circular = true,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      this.bold,
      this.onPressed,
      this.buttonSize = ButtonSize.large,
      Color backgroundColor,
      Color textColor,
      this.width,
      EdgeInsets padding})
      : this.enable = enable ?? true,
        this.circular = circular ?? true,
        this.onlyBorder = onlyBorder ?? false,
        this.reverse = reverse ?? false,
        this.backgroundColor = !reverse
            ? backgroundColor ?? PitComponents.buttonBackgroundColor
            : textColor ?? PitComponents.buttonTextColor,
        this.textColor = !reverse
            ? textColor ?? PitComponents.buttonTextColor
            : backgroundColor ?? PitComponents.buttonBackgroundColor,
        this.padding = padding ?? EdgeInsets.all(0.0);

  @override
  Widget build(BuildContext context) {
    switch (this.buttonSize) {
      case ButtonSize.large:
        return _buildLargeButton(context);
      default:
        return _buildSmallButton(context);
    }
  }

  _defaultCallback() {}

  Widget _buildSmallButton(BuildContext context) {
    bool _bold = this.bold ?? false;
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableTextColor = Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor = onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor = !onlyBorder ? disableTextColor : disableBackgroundColor;

    return ButtonTheme(
      minWidth: 0.0,
      height: 0.0,
      child: Container(
        width: width,
        child: FlatButton(
          padding: EdgeInsets.only(
              left: this.padding.left + 8.0 + borderWidthAdditional,
              top: this.padding.top + 8.0 + borderWidthAdditional,
              right: this.padding.right + 8.0 + borderWidthAdditional,
              bottom: this.padding.bottom + 8.0 + borderWidthAdditional),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: _color,
          textColor: _textColor,
          disabledColor: _disableColor,
          disabledTextColor: _disableTextColor,
          highlightColor: Theme.of(context).dividerColor,
          splashColor: Theme.of(context).dividerColor,
          child: direction == Axis.vertical
              ? AdvColumn(
                  divider: ColumnDivider(4.0),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    image,
                    this.data == ""
                        ? null
                        : Text(this.data,
                            style: ts.fs12
                                .merge(_bold ? ts.fw600 : ts.fw)
                                .copyWith(color: enable ? _textColor : _disableTextColor)),
                  ],
                )
              : AdvRow(
                  divider: RowDivider(4.0),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    this.data == ""
                        ? null
                        : Text(this.data,
                            style: ts.fs12
                                .merge(_bold ? ts.fw600 : ts.fw)
                                .copyWith(color: enable ? _textColor : _disableTextColor)),
                    image,
                  ],
                ),
          onPressed: enable ? this.onPressed ?? _defaultCallback : null,
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: enable ? backgroundColor : disableBackgroundColor, width: borderWidth),
            borderRadius: new BorderRadius.circular(circular ? 5.0 : 0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeButton(BuildContext context) {
    bool _bold = this.bold ?? true;
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableTextColor = Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor = onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor = !onlyBorder ? disableTextColor : disableBackgroundColor;

    return ButtonTheme(
      minWidth: 0.0,
      height: 0.0,
      child: Container(
        width: width,
        child: FlatButton(
          padding: EdgeInsets.only(
              left: this.padding.left + 14.0 + borderWidthAdditional,
              top: this.padding.top + 14.0 + borderWidthAdditional,
              right: this.padding.right + 14.0 + borderWidthAdditional,
              bottom: this.padding.bottom + 14.0 + borderWidthAdditional),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: _color,
          textColor: _textColor,
          disabledColor: _disableColor,
          disabledTextColor: _disableTextColor,
          highlightColor: Theme.of(context).dividerColor,
          splashColor: Theme.of(context).dividerColor,
          child: direction == Axis.vertical
              ? AdvColumn(
                  divider: ColumnDivider(4.0),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    image,
                    this.data == ""
                        ? null
                        : Text(this.data,
                            style: ts.fs22
                                .merge(_bold ? ts.fw700 : ts.fw)
                                .copyWith(color: enable ? _textColor : _disableTextColor)),
                  ],
                )
              : AdvRow(
                  divider: RowDivider(4.0),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image,
                    this.data == ""
                        ? null
                        : Text(this.data,
                            style: ts.fs22
                                .merge(_bold ? ts.fw700 : ts.fw)
                                .copyWith(color: enable ? _textColor : _disableTextColor)),
                  ],
                ),
          onPressed: enable ? this.onPressed ?? _defaultCallback : null,
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: enable ? backgroundColor : disableBackgroundColor, width: borderWidth),
            borderRadius: new BorderRadius.circular(circular ? 5.0 : 0.0),
          ),
        ),
      ),
    );
  }
}
