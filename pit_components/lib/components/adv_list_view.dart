import 'package:flutter/material.dart';

class AdvListView extends StatelessWidget {
  final Widget divider;
  final bool onlyInner;
  final Key key;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double cacheExtent;
  final List<Widget> children;

  AdvListView({
    Widget divider,
    Key key,
    this.onlyInner = true,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    double itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
  })  : this.divider = divider ?? Container(),
        this.key = key,
        this.scrollDirection = scrollDirection,
        this.reverse = reverse,
        this.controller = controller,
        this.primary = primary,
        this.physics = physics,
        this.shrinkWrap = shrinkWrap,
        this.padding = padding,
        this.itemExtent = itemExtent,
        this.addAutomaticKeepAlives = addAutomaticKeepAlives,
        this.addRepaintBoundaries = addRepaintBoundaries,
        this.cacheExtent = cacheExtent,
        this.children = children;

  @override
  Widget build(BuildContext context) {
    List<Widget> newChildren = _rebuildChildren();

    return ListView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      cacheExtent: cacheExtent,
      children: newChildren,
    );
  }

  List<Widget> _rebuildChildren() {
    if (children.length == 0) return [];
    List<Widget> newChildren = [];

    if (!this.onlyInner) newChildren.add(divider);

    for (Widget child in children) {
      newChildren.add(child);
      newChildren.add(divider);
    }

    if (this.onlyInner) newChildren.removeAt(newChildren.length - 1);

    return newChildren;
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
