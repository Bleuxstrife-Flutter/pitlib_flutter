import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:pit_components/pit_components.dart';

typedef void OnTextChanged(String value);

const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = 48.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsets _kAlignedMenuMargin = EdgeInsets.zero;
const EdgeInsetsGeometry _kUnalignedMenuMargin =
    EdgeInsetsDirectional.only(start: 16.0, end: 24.0);

class AdvDropDown extends StatefulWidget {
  final AdvDropDownController controller;
  final TextSpan measureTextSpan;
  final EdgeInsetsGeometry padding;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final Color backgroundColor;

  AdvDropDown(
      {String selectedItem,
      String hint,
      TextAlign alignment,
      Map<String, dynamic> items,
      String measureText,
      TextSpan measureTextSpan,
      EdgeInsetsGeometry padding,
      this.validator,
      AdvDropDownController controller,
      Color backgroundColor,
      @required this.onChanged})
      : assert(measureText == null || measureTextSpan == null),
        assert(controller == null ||
            (selectedItem == null && hint == null && alignment == null)),
        this.controller = controller ??
            new AdvDropDownController(
                text: selectedItem ?? "",
                hint: hint ?? "",
                alignment: alignment ?? TextAlign.left,
                items: items ?? Map()),
        this.backgroundColor =
            backgroundColor ?? PitComponents.dropDownBackgroundColor,
        this.measureTextSpan = measureTextSpan ??
            new TextSpan(
                text: measureText,
                style: new TextStyle(fontSize: 16.0, color: Colors.black)),
        this.padding = padding ?? new EdgeInsets.all(0.0);

  @override
  State createState() => new _AdvDropDownState();
}

class _AdvDropDownState extends State<AdvDropDown>
    with SingleTickerProviderStateMixin {
  AdvDropDownController _initialController;
  AdvDropDownController _controller;
  _DropdownRoute<DropdownMenuItem<String>> _dropdownRoute;
  List<DropdownMenuItem<String>> _items = [];

  @override
  void initState() {
    super.initState();
    _controller = AdvDropDownController.fromValue(widget.controller.value);
    _initialController =
        AdvDropDownController.fromValue(widget.controller.value);
    widget.controller.addListener(_updateFromWidget);
  }

  @override
  Widget build(BuildContext context) {
    final int _defaultWidthAddition = 2;
    final int _defaultHeightAddition = 24;
    final double _defaultInnerPadding = 8.0;
    int maxLengthHeight = 0;

    _items.clear();
    _controller.items.forEach((key, value) {
      _items.add(new DropdownMenuItem(child: new Text(value), value: key));
    });

    TextEditingController controller = new TextEditingController();

    _controller.items.forEach((key, value) {
      if (key == _controller.text) {
        controller.text = value;
      }
    });

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
//        child: new Center(
//          child: new Container(
//            padding:
//                EdgeInsets.only(top: 8.0, left: 8.0, bottom: 9.0, right: 8.0),
//            decoration: BoxDecoration(
//              border: new Border.all(color: Colors.black54, width: 1.0),
//              borderRadius: const BorderRadius.all(
//                const Radius.circular(4.0),
//              ),
//            ),
//            child: new Stack(
//              children: [
//                new DropdownButton(
//                  isDense: true,
//                  elevation: 2,
//                  items: [
//                    new DropdownMenuItem(child: Text("a"), value: "a"),
//                    new DropdownMenuItem(child: Text("b"), value: "b"),
//                    new DropdownMenuItem(child: Text("c"), value: "c"),
//                  ],
//                  onChanged: (value) {},
//                  value: "a",
//                  style: widget.measureTextSpan.style,
//                  hint: Text("asdasd"),
//                ),
//                new AdvTextField()
//              ],
//            ),
//          ),
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
                      textAlign: _controller.alignment,
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
                        filled: true,
                        fillColor: widget.backgroundColor,
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
                    right: 2.0,
                    child: new Icon(Icons.arrow_drop_down,
                        size: 24.0,
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

  void _handleTap() {
    final RenderBox itemBox = context.findRenderObject();
    final Rect itemRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsetsGeometry menuMargin =
        ButtonTheme.of(context).alignedDropdown
            ? _kAlignedMenuMargin
            : _kUnalignedMenuMargin;

    assert(_dropdownRoute == null);
    _dropdownRoute = _DropdownRoute<DropdownMenuItem<String>>(
      items: _items,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: _kMenuItemPadding.resolve(textDirection),
      selectedIndex: 1 ?? 0,
      elevation: 4,
      theme: Theme.of(context, shadowThemeOnly: true),
      style: widget.measureTextSpan.style,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    );

    Navigator.push(context, _dropdownRoute)
        .then<void>((_DropdownRouteResult<DropdownMenuItem<String>> newValue) {
      _dropdownRoute = null;
      if (!mounted || newValue == null) return;
//      if (widget.onChanged != null)
//        widget.onChanged(newValue.result);
//
      _controller.text = newValue.result.value;
      widget.controller.text = newValue.result.value;

      if (widget.onChanged != null) widget.onChanged(newValue.result.value);

      _update();
    });
  }

  _update() {
    setState(() {});
  }

  _updateFromWidget() {
    if (widget.controller.text != _initialController.text)
      _controller.text = widget.controller.text;
    if (widget.controller.hint != _initialController.hint)
      _controller.hint = widget.controller.hint;
    if (widget.controller.alignment != _initialController.alignment)
      _controller.alignment = widget.controller.alignment;
    if (widget.controller.items != _initialController.items)
      _controller.items = widget.controller.items;
    _initialController =
        AdvDropDownController.fromValue(widget.controller.value);
    setState(() {});
  }

  @override
  void didUpdateWidget(AdvDropDown oldWidget) {
    _initialController =
        AdvDropDownController.fromValue(widget.controller.value);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_updateFromWidget);
      widget.controller.addListener(_updateFromWidget);
    }
    if (oldWidget.controller != null && widget.controller == null) {
      widget.controller.value =
          AdvDropDownEditingValue.fromValue(oldWidget.controller.value);
    }

    if (oldWidget.controller.value != widget.controller.value) {
      _controller.value =
          AdvDropDownEditingValue.fromValue(widget.controller.value);
    }
    super.didUpdateWidget(oldWidget);
  }
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    this.items,
    this.padding,
    this.buttonRect,
    this.selectedIndex,
    this.elevation = 8,
    this.theme,
    @required this.style,
    this.barrierLabel,
  }) : assert(style != null);

  final List<DropdownMenuItem<String>> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final ThemeData theme;
  final TextStyle style;

  ScrollController scrollController;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    assert(debugCheckHasDirectionality(context));
    final double screenHeight = MediaQuery.of(context).size.height;
    final double maxMenuHeight = screenHeight - 2.0 * _kMenuItemHeight;
    final double preferredMenuHeight =
        (items.length * _kMenuItemHeight) + kMaterialListPadding.vertical;
    final double menuHeight = math.min(maxMenuHeight, preferredMenuHeight);

    final double buttonTop = buttonRect.top;
    final double selectedItemOffset =
        selectedIndex * _kMenuItemHeight + kMaterialListPadding.top;
    double menuTop = (buttonTop - selectedItemOffset) -
        (_kMenuItemHeight - buttonRect.height) / 2.0;
    const double topPreferredLimit = _kMenuItemHeight;
    if (menuTop < topPreferredLimit)
      menuTop = math.min(buttonTop, topPreferredLimit);
    double bottom = menuTop + menuHeight;
    final double bottomPreferredLimit = screenHeight - _kMenuItemHeight;
    if (bottom > bottomPreferredLimit) {
      bottom = math.max(buttonTop + _kMenuItemHeight, bottomPreferredLimit);
      menuTop = bottom - menuHeight;
    }

    if (scrollController == null) {
      final double scrollOffset = (preferredMenuHeight > maxMenuHeight)
          ? math.max(0.0, selectedItemOffset - (buttonTop - menuTop))
          : 0.0;
      scrollController = ScrollController(initialScrollOffset: scrollOffset);
    }

    final TextDirection textDirection = Directionality.of(context);
    Widget menu = _DropdownMenu<T>(
      route: this,
      padding: padding.resolve(textDirection),
    );

    if (theme != null) menu = Theme(data: theme, child: menu);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _DropdownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              menuTop: menuTop,
              menuHeight: menuHeight,
              textDirection: textDirection,
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    @required this.buttonRect,
    @required this.menuTop,
    @required this.menuHeight,
    @required this.textDirection,
  });

  final Rect buttonRect;
  final double menuTop;
  final double menuHeight;
  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than
    // the view height. This ensures a tappable area outside of the simple menu
    // with which to dismiss the menu.
    //   -- https://material.google.com/components/menus.html#menus-simple-menus
    final double maxHeight =
        math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // If the button was entirely on-screen, then verify
        // that the menu is also on-screen.
        // If the button was a bit off-screen, then, oh well.
        assert(menuTop >= 0.0);
        assert(menuTop + menuHeight <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    double left;
    switch (textDirection) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }
    return Offset(left, menuTop);
  }

  @override
  bool shouldRelayout(
      _DropdownMenuRouteLayout<DropdownMenuItem<String>> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        menuTop != oldDelegate.menuTop ||
        menuHeight != oldDelegate.menuHeight ||
        textDirection != oldDelegate.textDirection;
  }
}

class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T result;

  @override
  bool operator ==(dynamic other) {
    if (other is! _DropdownRouteResult<T>) return false;
    final _DropdownRouteResult<T> typedOther = other;
    return result == typedOther.result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    Key key,
    this.padding,
    this.route,
  }) : super(key: key);

  final _DropdownRoute<T> route;
  final EdgeInsets padding;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  CurvedAnimation _fadeOpacity;
  CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve
    // direction. When the route's animation reverses, if we were to recreate
    // the CurvedAnimation objects in build, we'd lose
    // CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The menu is shown in three stages (unit timing in brackets):
    // [0s - 0.25s] - Fade in a rect-sized menu container with the selected item.
    // [0.25s - 0.5s] - Grow the otherwise empty menu container from the center
    //   until it's big enough for as many items as we're going to show.
    // [0.5s - 1.0s] Fade in the remaining visible items from top to bottom.
    //
    // When the menu is dismissed we just fade the entire thing out
    // in the first 0.25s.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route;
    final double unit = 0.5 / (route.items.length + 1.5);
    final List<Widget> children = <Widget>[];
    for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex) {
      CurvedAnimation opacity;
      if (itemIndex == route.selectedIndex) {
        opacity = CurvedAnimation(
            parent: route.animation, curve: const Threshold(0.0));
      } else {
        final double start = (0.5 + (itemIndex + 1) * unit).clamp(0.0, 1.0);
        final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
        opacity = CurvedAnimation(
            parent: route.animation, curve: Interval(start, end));
      }
      children.add(
        FadeTransition(
          opacity: opacity,
          child: Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InkWell(
              child: Container(
                padding: widget.padding,
                child: route.items[itemIndex],
              ),
              onTap: () => Navigator.pop(
                    context,
                    _DropdownRouteResult<DropdownMenuItem<String>>(
                        route.items[itemIndex]),
                  ),
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: Theme.of(context).canvasColor,
          elevation: route.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: Material(
            type: MaterialType.transparency,
            textStyle: route.style,
            child: ScrollConfiguration(
              behavior: const _DropdownScrollBehavior(),
              child: Scrollbar(
                child: ListView(
                  controller: widget.route.scrollController,
                  padding: kMaterialListPadding,
                  itemExtent: _kMenuItemHeight,
                  shrinkWrap: true,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    this.color,
    this.elevation,
    this.selectedIndex,
    this.resize,
  })  : _painter = BoxDecoration(
                // If you add an image here, you must provide a real
                // configuration in the paint() function and you must provide some sort
                // of onChanged callback here.
                color: color,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: kElevationToShadow[elevation])
            .createBoxPainter(),
        super(repaint: resize);

  final Color color;
  final int elevation;
  final int selectedIndex;
  final Animation<double> resize;

  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final double selectedItemOffset =
        selectedIndex * _kMenuItemHeight + kMaterialListPadding.top;
    final Tween<double> top = Tween<double>(
      begin: selectedItemOffset.clamp(0.0, size.height - _kMenuItemHeight),
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin:
          (top.begin + _kMenuItemHeight).clamp(_kMenuItemHeight, size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(
        8.0, top.evaluate(resize), size.width - 8.0, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.selectedIndex != selectedIndex ||
        oldPainter.resize != resize;
  }
}

class _DropdownScrollBehavior extends ScrollBehavior {
  const _DropdownScrollBehavior();

  @override
  TargetPlatform getPlatform(BuildContext context) =>
      Theme.of(context).platform;

  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

class AdvDropDownController extends ValueNotifier<AdvDropDownEditingValue> {
  String get text => value.text;

  set text(String newText) {
    value = value.copyWith(
        text: newText,
        hint: this.hint,
        alignment: this.alignment,
        items: this.items);
  }

  String get hint => value.hint;

  set hint(String newHint) {
    value = value.copyWith(
        text: this.text,
        hint: newHint,
        alignment: this.alignment,
        items: this.items);
  }

  TextAlign get alignment => value.alignment;

  set alignment(TextAlign newAlignment) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        alignment: newAlignment,
        items: this.items);
  }

  Map<String, dynamic> get items => value.items;

  set items(Map<String, dynamic> newItems) {
    value = value.copyWith(
        text: this.text,
        hint: this.hint,
        alignment: this.alignment,
        items: newItems);
  }

  AdvDropDownController(
      {String text,
      String hint,
      TextAlign alignment,
      Map<String, dynamic> items})
      : super(text == null && hint == null && alignment == null && items == null
            ? AdvDropDownEditingValue.empty
            : new AdvDropDownEditingValue(
                text: text,
                hint: hint,
                alignment: alignment ?? TextAlign.left,
                items: items ?? Map()));

  AdvDropDownController.fromValue(AdvDropDownEditingValue value)
      : super(value ?? AdvDropDownEditingValue.empty);

  void clear() {
    value = AdvDropDownEditingValue.empty;
  }
}

@immutable
class AdvDropDownEditingValue {
  const AdvDropDownEditingValue(
      {this.text = '',
      this.hint = '',
      this.alignment = TextAlign.left,
      this.items});

  final String text;
  final String hint;
  final TextAlign alignment;
  final Map<String, dynamic> items;

  static const AdvDropDownEditingValue empty = const AdvDropDownEditingValue();

  AdvDropDownEditingValue copyWith(
      {String text,
      String hint,
      int maxLength,
      bool maxLengthEnforced,
      int maxLines,
      bool enable,
      TextAlign alignment,
      Map<String, dynamic> items}) {
    return new AdvDropDownEditingValue(
        text: text ?? this.text,
        hint: hint ?? this.hint,
        alignment: alignment ?? this.alignment,
        items: items ?? Map());
  }

  AdvDropDownEditingValue.fromValue(AdvDropDownEditingValue copy)
      : this.text = copy.text,
        this.hint = copy.hint,
        this.alignment = copy.alignment,
        this.items = copy.items;

  @override
  String toString() =>
      '$runtimeType(text: \u2524$text\u251C, \u2524$hint\u251C, alignment: $alignment, items: $items)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvDropDownEditingValue) return false;
    final AdvDropDownEditingValue typedOther = other;
    return typedOther.text == text &&
        typedOther.hint == hint &&
        typedOther.alignment == alignment &&
        typedOther.items == items;
  }

  @override
  int get hashCode => hashValues(
      text.hashCode, hint.hashCode, alignment.hashCode, items.hashCode);
}
