import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pit_components/components/adv_visibility.dart';

class AdvListViewWithBottom extends StatefulWidget {
  final List<Widget> children;
  final Widget divider;
  final bool onlyInner;
  final Widget footerItem;

  AdvListViewWithBottom(
      {List<Widget> children,
      Widget divider,
      this.onlyInner = true,
      Widget footerItem})
      : this.divider = divider ?? Container(),
        this.children = children ?? [],
        this.footerItem = footerItem ?? Container();

  @override
  _AdvListViewWithBottomState createState() =>
      new _AdvListViewWithBottomState();
}

class _AdvListViewWithBottomState extends State<AdvListViewWithBottom>
    with SingleTickerProviderStateMixin {
  double _childHeight = 0.0;
  ScrollController _hideButtonController;
  AnimationController _controller;

  double _lastScrollPosition = 0.0;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 300),
        value: (true) ? 1.0 : 0.0,
        vsync: this);

    _hideButtonController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hideButtonController
        .position.isScrollingNotifier
        .addListener(_onScrollListener));
    _hideButtonController.addListener(() {
      double currentScroll = _hideButtonController.position.pixels;

      double factor = (currentScroll - _lastScrollPosition) / _childHeight;
      _controller.value =
          _controller.value - factor < 0.0 ? 0.0 : _controller.value - factor;

      _lastScrollPosition = currentScroll;
    });
  }

  _onScrollListener() {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    if (_hideButtonController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _controller.fling(velocity: -1.0);
    } else if (_hideButtonController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _controller.fling(velocity: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final panelDetailsPosition = Tween<Offset>(
        begin: Offset(0.0, 1.0),
        end: Offset(0.0, 0.0),
      ).animate(_controller.view);
      List<Widget> newChildren = _rebuildChildren();

      return Container(
          child: new Stack(children: [
        CustomScrollView(
          controller: _hideButtonController,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate: new SliverChildListDelegate(newChildren),
            ),
          ],
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
              width: constraints.maxWidth,
              child: SlideTransition(
                position: panelDetailsPosition,
                child: HeightReporter(
                  child: widget.footerItem,
                  callback: (height) => _childHeight = height,
                ),
                textDirection: TextDirection.ltr,
              )),
        ),
      ]));
    });
  }

  List<Widget> _rebuildChildren() {
    if (widget.children.length == 0) return [];
    List<Widget> newChildren = [];

    if (!widget.onlyInner) newChildren.add(widget.divider);

    for (Widget child in widget.children) {
      newChildren.add(child);
      newChildren.add(widget.divider);
    }

    if (widget.onlyInner) newChildren.removeAt(newChildren.length - 1);

    newChildren.add(AdvVisibility(
        visibility: VisibilityFlag.invisible, child: widget.footerItem));

    return newChildren;
  }
}

typedef HeightReporterCallback = void Function(double height);

class HeightReporter extends StatelessWidget {
  final Widget child;
  final HeightReporterCallback callback;

  HeightReporter({this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => this.callback(context.size.height));

    return new Container(child: child);
  }
}

class ListViewDivider extends StatelessWidget {
  final double size;
  final Axis direction;
  final Color color;

  ListViewDivider(double size, {Axis direction, Color color})
      : this.size = size ?? 0.0,
        this.direction = direction ?? Axis.vertical,
        this.color = color ?? Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: direction == Axis.vertical ? size : 0.0,
        width: direction == Axis.horizontal ? size : 0.0,
        color: color);
  }
}

