import 'package:flutter/material.dart';
import 'dart:async';

class Position {
  final double top;
  final double bottom;
  final double left;
  final double right;

  const Position(
      {double top = 8.0,
        double bottom = 8.0,
        double left = 8.0,
        double right = 8.0})
      : this.top = top,
        this.bottom = bottom,
        this.left = left,
        this.right = right;
}

class AdvCarousel extends StatefulWidget {
  final AdvCarouselController carouselController;
  final List<Widget> children;

  final double height;
  final EdgeInsetsGeometry margin;

  ///Returns [children]`s [lenght].
  int get childrenCount => children.length;

  ///The transition animation timing curve. Default is [Curves.ease]
  final Curve animationCurve;

  ///The transition animation duration. Default is 250ms.
  final Duration animationDuration;

  ///The amount of time each frame is displayed. Default is 2s.
  final Duration displayDuration;

  final bool autoPlay;
  final bool repeat;

  final Alignment dotAlignment;
  final Position dotPosition;
  final Widget placeholder;

  AdvCarousel({
    double height,
    EdgeInsetsGeometry margin,
    AdvCarouselController carouselController,
    this.children,
    this.animationCurve = Curves.bounceOut,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.displayDuration = const Duration(seconds: 7),
    bool autoPlay = true,
    bool repeat = true,
    this.dotAlignment = Alignment.bottomCenter,
    this.dotPosition = const Position(),
    Widget placeholder,
  })  : assert(height == null || height > 0),
        assert(children == null || carouselController == null),
        assert(animationCurve != null),
        assert(animationDuration != null),
        assert(displayDuration != null),
        this.carouselController =
            carouselController ?? new AdvCarouselController(widgets: children),
        this.height = height ?? 210.0,
        this.margin = margin ?? new EdgeInsets.all(0.0),
        this.autoPlay = autoPlay ?? true,
        this.repeat = repeat ?? true,
        this.placeholder = placeholder ?? Container();

  @override
  State createState() => new _AdvCarouselState();
}

class _AdvCarouselState extends State<AdvCarousel>
    with SingleTickerProviderStateMixin {
  PageController _pageController = new PageController();

  Timer _timer;

  double dotSize = 8.0;
  double dotIncreaseSize = 1.4;

  double get dotSpacing => dotSize * (dotIncreaseSize + 1);

  ///Actual index of the displaying Widget
  int get actualIndex =>
      !_pageController.hasClients ? 0 : _pageController.page.round();

  ///Returns the calculated value of the next index.
  int get nextIndex {
    var nextIndexValue = actualIndex;

    if (widget.carouselController.widgets != null &&
        nextIndexValue < widget.carouselController.widgets.length - 1)
      nextIndexValue++;
    else
      nextIndexValue = 0;

    return nextIndexValue;
  }

  @override
  void initState() {
    super.initState();
    widget.carouselController.addListener(_updateFromWidget);
  }

  _updateFromWidget() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer?.cancel();
  }

  Widget createCarouselPlaceHolder() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          width: constraints.maxWidth,
          height: widget.height, child: widget.placeholder);
    },);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.carouselController.widgets == null ||
        widget.carouselController.widgets.isEmpty)
      return createCarouselPlaceHolder();

    if (widget.autoPlay) startAnimating();

    _pageController.addListener(() => setState(() {}));

    return new Container(
        height: widget.height,
        margin: widget.margin,
        child: new Stack(children: [
          new PageView(
            controller: this._pageController,
            physics: new AlwaysScrollableScrollPhysics(),
            children: widget.carouselController.widgets
                .map((widget) => new Container(
              child: widget,
            ))
                .toList(),
          ),
          new Positioned(
              top: widget.dotPosition.top,
              bottom: widget.dotPosition.bottom,
              left: widget.dotPosition.left,
              right: widget.dotPosition.right,
              child: Container(
                alignment: widget.dotAlignment,
                child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: new List<Widget>.generate(
                        widget.carouselController.widgets.length, _buildDot)),
              )),
        ]));
  }

  Widget _buildDot(int index) {
    double currentPage =
    !_pageController.hasClients ? 0.0 : _pageController.page ?? 0.0;
    double zoom = (currentPage).floor() == index
        ? ((1.0 - (currentPage - index)) * (dotIncreaseSize - 1)) + 1
        : (currentPage + 1).floor() == index
        ? ((currentPage + 1.0 - index) * (dotIncreaseSize - 1)) + 1
        : 1.0;

    return new Container(
      width: dotSpacing,
      child: new Stack(
        alignment: Alignment.center,
        children: [
          new Material(
            color: Colors.grey,
            type: MaterialType.circle,
            child: new Container(
              width: dotSize * (zoom + 0.2),
              height: dotSize * (zoom + 0.2),
            ),
          ),
          new Material(
            color: Colors.white,
            type: MaterialType.circle,
            child: new Container(
              width: dotSize * zoom,
              height: dotSize * zoom,
              child: new InkWell(
                onTap: () => onPageSelected(index),
              ),
            ),
          )
        ],
      ),
    );
  }

  void startAnimating() {
    _timer?.cancel();

    //Every widget.displayDuration (time) the tabbar controller will animate to the next index.
    _timer = new Timer.periodic(
      widget.displayDuration,
          (_) {
        if (!widget.repeat) {
          if (this.nextIndex == 0) _timer.cancel();

          if (!_timer.isActive) return;
        }

        this._pageController.animateToPage(this.nextIndex,
            curve: widget.animationCurve, duration: widget.animationDuration);
      },
    );
  }

  onPageSelected(int index) {
    _pageController.animateToPage(index,
        duration: widget.animationDuration, curve: widget.animationCurve);
  }
}

class AdvCarouselController extends ValueNotifier<AdvCarouselEditingValue> {
  List<Widget> get widgets => value.widgets;

  set widgets(List<Widget> newWidgets) {
    value = value.copyWith(widgets: newWidgets);
  }

  AdvCarouselController({List<Widget> widgets})
      : super(widgets == null
      ? AdvCarouselEditingValue.empty
      : new AdvCarouselEditingValue(widgets: widgets));

  AdvCarouselController.fromValue(AdvCarouselEditingValue value)
      : super(value ?? AdvCarouselEditingValue.empty);

  void clear() {
    value = AdvCarouselEditingValue.empty;
  }
}

@immutable
class AdvCarouselEditingValue {
  const AdvCarouselEditingValue({this.widgets});

  final List<Widget> widgets;

  static const AdvCarouselEditingValue empty = const AdvCarouselEditingValue();

  AdvCarouselEditingValue copyWith({List<Widget> widgets}) {
    return new AdvCarouselEditingValue(widgets: widgets ?? this.widgets);
  }

  AdvCarouselEditingValue.fromValue(AdvCarouselEditingValue copy)
      : this.widgets = copy.widgets;

  @override
  String toString() => '$runtimeType(widgets: \u2524$widgets\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvCarouselEditingValue) return false;
    final AdvCarouselEditingValue typedOther = other;
    return typedOther.widgets == widgets;
  }

  @override
  int get hashCode => hashValues(widgets.hashCode, widgets.hashCode);
}
