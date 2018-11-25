import 'package:flutter/material.dart';
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
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final Color disableBackgroundColor;
  final Color disableTextColor;

  AdvButton(this.data,
      {bool circular = true,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      this.onPressed,
      this.buttonSize = ButtonSize.large,
      Color backgroundColor,
      Color textColor,
      this.width})
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
        this.disableBackgroundColor = Color.lerp(
            backgroundColor ?? PitComponents.buttonBackgroundColor,
            lerpColor,
            0.6),
        this.disableTextColor = Color.lerp(
            backgroundColor ?? PitComponents.buttonTextColor, lerpColor, 0.6);

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
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;

    ShapeBorder border = RoundedRectangleBorder(
        side: BorderSide(
            color: enable ? backgroundColor : disableBackgroundColor,
            width: borderWidth),
        borderRadius: new BorderRadius.circular(this.circular ? 5.0 : 0.0));

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor =
        onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;

    return Container(
        width: width,
        child: FlatButton(
          padding: EdgeInsets.all(8.0 + borderWidthAdditional),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: _color,
          disabledColor: _disableColor,
          disabledTextColor: _disableTextColor,
          highlightColor: Theme.of(context).dividerColor,
          splashColor: Theme.of(context).dividerColor,
          child: new Text(this.data,
              style: ts.fs12
                  .copyWith(color: enable ? _textColor : _disableTextColor)),
          onPressed: enable ? this.onPressed ?? _defaultCallback : null,
          shape: border,
        ));
  }

  Widget _buildLargeButton(BuildContext context) {
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor =
        onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;

    return Container(
        width: width,
        child: FlatButton(
          padding: EdgeInsets.all(14.0 + borderWidthAdditional),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//        borderSide:
//            BorderSide(color: Theme.of(context).primaryColorDark, width: 3.0),
          color: _color,
          disabledColor: _disableColor,
          disabledTextColor: _disableTextColor,
          highlightColor: Theme.of(context).dividerColor,
          splashColor: Theme.of(context).dividerColor,
          child: new Text(this.data,
              style: ts.fs16.merge(ts.fw700
                  .copyWith(color: enable ? _textColor : _disableTextColor))),
          onPressed: enable ? this.onPressed ?? _defaultCallback : null,
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: enable ? backgroundColor : disableBackgroundColor,
                width: borderWidth),
            borderRadius: new BorderRadius.circular(this.circular ? 5.0 : 0.0),
          ),
        ));
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
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final Color disableBackgroundColor;
  final Color disableTextColor;

  AdvButtonWithIcon(this.data, this.image, this.direction,
      {bool circular = true,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      this.onPressed,
      this.buttonSize = ButtonSize.large,
      Color backgroundColor,
      Color textColor,
      this.width})
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
        this.disableBackgroundColor = Color.lerp(
            backgroundColor ?? PitComponents.buttonBackgroundColor,
            lerpColor,
            0.6),
        this.disableTextColor = Color.lerp(
            backgroundColor ?? PitComponents.buttonTextColor, lerpColor, 0.6);

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
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor =
        onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;

    return Container(
      width: width,
      child: FlatButton(
        padding: EdgeInsets.all(8.0 + borderWidthAdditional),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: _color,
        textColor: _textColor,
        disabledColor: _disableColor,
        disabledTextColor: _disableTextColor,
        highlightColor: Theme.of(context).dividerColor,
        splashColor: Theme.of(context).dividerColor,
        child: direction == Axis.vertical
            ? new Column(
                children: [
                  image,
                  Visibility(
                    visible: this.data != "",
                    child: new Container(
                      height: 4.0,
                    ),
                  ),
                  Visibility(
                      visible: this.data != "",
                      child: new Text(this.data,
                          style: ts.fs12.merge(ts.fw700.copyWith(
                              color: enable ? _textColor : _disableTextColor))))
                ],
              )
            : new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image,
                  Visibility(
                    visible: this.data != "",
                    child: new Container(
                      width: 4.0,
                    ),
                  ),
                  Visibility(
                      visible: this.data != "",
                      child: new Text(this.data,
                          style: ts.fs12.merge(ts.fw700.copyWith(
                              color: enable ? _textColor : _disableTextColor))))
                ],
              ),
        onPressed: enable ? this.onPressed ?? _defaultCallback : null,
        shape: new RoundedRectangleBorder(
          side: BorderSide(
              color: enable ? backgroundColor : disableBackgroundColor,
              width: borderWidth),
          borderRadius: new BorderRadius.circular(circular ? 5.0 : 0.0),
        ),
      ),
    );
  }

  Widget _buildLargeButton(BuildContext context) {
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    double borderWidthAdditional = !onlyBorder ? 0.0 : 0.0;

    Color _color = onlyBorder ? textColor : backgroundColor;
    Color _disableColor =
        onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _textColor = !onlyBorder ? textColor : backgroundColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;

    return Container(
      width: width,
      child: FlatButton(
        padding: EdgeInsets.all(14.0 + borderWidthAdditional),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: _color,
        textColor: _textColor,
        disabledColor: _disableColor,
        disabledTextColor: _disableTextColor,
        highlightColor: Theme.of(context).dividerColor,
        splashColor: Theme.of(context).dividerColor,
        child: direction == Axis.vertical
            ? new Column(
                children: [
                  image,
                  Visibility(
                    visible: this.data != "",
                    child: new Container(
                      height: 8.0,
                    ),
                  ),
                  Visibility(
                      visible: this.data != "",
                      child: new Text(this.data,
                          style: ts.fs22.merge(ts.fw700.copyWith(
                              color:
                                  enable ? _textColor : _disableTextColor)))),
                ],
              )
            : new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image,
                  Visibility(
                    visible: this.data != "",
                    child: new Container(
                      width: 8.0,
                    ),
                  ),
                  Visibility(
                      visible: this.data != "",
                      child: new Text(this.data,
                          style: ts.fs22.merge(ts.fw700.copyWith(
                              color:
                                  enable ? _textColor : _disableTextColor)))),
                ],
              ),
        onPressed: enable ? this.onPressed ?? _defaultCallback : null,
        shape: new RoundedRectangleBorder(
          side: BorderSide(
              color: enable ? backgroundColor : disableBackgroundColor,
              width: borderWidth),
          borderRadius: new BorderRadius.circular(circular ? 5.0 : 0.0),
        ),
      ),
    );
  }
}