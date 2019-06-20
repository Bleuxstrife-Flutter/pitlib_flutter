import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_loading.dart';

typedef void ResetFunction();
typedef List<Widget> WidgetBuilder(BuildContext context);
typedef Future<bool> Fetcher(BuildContext context, int cursor);

class AdvInfiniteListRemote {
  ResetFunction reset;
}

class AdvInfiniteListView extends StatefulWidget {
  final AdvInfiniteListRemote remote;
  final WidgetBuilder widgetBuilder;
  final Fetcher fetcher;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget divider;
  final bool onlyInner;
  final Key key;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline textBaseline;
  final List<Widget> children;

  AdvInfiniteListView({
    this.remote,
    this.widgetBuilder,
    this.fetcher,
    this.padding,
    this.margin,
    Widget divider,
    bool onlyInner,
    Key key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline textBaseline,
    List<Widget> children = const <Widget>[],
  })  : assert(widgetBuilder != null),
        assert(fetcher != null),
        this.divider = divider ?? Container(),
        this.onlyInner = onlyInner ?? true,
        this.key = key,
        this.mainAxisAlignment = mainAxisAlignment,
        this.mainAxisSize = mainAxisSize,
        this.crossAxisAlignment = crossAxisAlignment,
        this.textDirection = textDirection,
        this.verticalDirection = verticalDirection,
        this.textBaseline = textBaseline,
        this.children = children;

  @override
  _AdvInfiniteListViewState createState() => _AdvInfiniteListViewState();
}

class _AdvInfiniteListViewState extends State<AdvInfiniteListView> {
  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: false, initialScrollOffset: 0.0);
  bool isPerformingRequest = false;
  int _cursor = 0;
  bool _noMoreData = false;
  bool enableOverScroll = true;

  @override
  void initState() {
    super.initState();
  }

  _reset(BuildContext context) {
    setState(() {
      _noMoreData = false;
      _cursor = 0;
      _tryFetchMore(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _tryFetchMore(BuildContext context) async {
    if (!isPerformingRequest && !_noMoreData) {
      setState(() {
        isPerformingRequest = true;
      });

      bool hasData = await widget.fetcher(context, _cursor);

      setState(() {
        if (!hasData) {
          _noMoreData = true;
        } else {
          _cursor++;
        }
        isPerformingRequest = false;
      });
    }
  }

  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isPerformingRequest && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    });

    if (firstBuild) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _tryFetchMore(context);
        }
      });

      if (widget.remote != null)
        widget.remote.reset = () {
          _reset(context);
        };

      _tryFetchMore(context);
      firstBuild = false;
    }

    List<Widget> children = widget.widgetBuilder(context);

    if (isPerformingRequest) children.add(_buildProgressIndicator());

    return SingleChildScrollView(
      child: AdvColumn(
          padding: widget.padding,
          margin: widget.margin,
          divider: widget.divider,
          onlyInner: widget.onlyInner,
          key: widget.key,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          crossAxisAlignment: widget.crossAxisAlignment,
          textDirection: widget.textDirection,
          verticalDirection: widget.verticalDirection,
          textBaseline: widget.textBaseline,
          children: children),
      controller: _scrollController,
    );
  }

  Widget _buildProgressIndicator() {
    return isPerformingRequest
        ? new Center(
            child: new AdvLoading(
              height: 30.0,
            ),
          )
        : Container();
  }
}
