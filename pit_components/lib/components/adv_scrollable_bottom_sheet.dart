import 'package:flutter/material.dart';

class AdvScrollableBottomSheet extends StatefulWidget {
  final double initialHeight;
  final Widget child;

  AdvScrollableBottomSheet(
      {@required this.initialHeight, @required this.child});

  @override
  State<StatefulWidget> createState() => _AdvScrollableBottomSheetState();
}

class _AdvScrollableBottomSheetState extends State<AdvScrollableBottomSheet>
    with TickerProviderStateMixin {
  double _currentHeight;
  ScrollController scrollController = ScrollController();
  Animation<double> scale;

  String lastScrollDirection = "";

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    scrollController = ScrollController();

    Widget child = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double _maxHeight = constraints.maxHeight;
      return Container(
          height: _currentHeight,
          child: GestureDetector(
              onVerticalDragEnd: (DragEndDetails details) {
                if (_currentHeight <= widget.initialHeight) {
                  AnimationController animationController = AnimationController(
                      duration: const Duration(milliseconds: 200), vsync: this);

                  var animation = CurvedAnimation(
                    parent: animationController,
                    curve: Interval(
                      0.0,
                      1.0,
                      curve: Curves.ease,
                    ),
                  );

                  if (lastScrollDirection == "down") {
                    scale = Tween<double>(begin: _currentHeight, end: 0.0)
                        .animate(animation);

                    animationController.forward();
                  } else {
                    scale = Tween<double>(
                            begin: _currentHeight, end: widget.initialHeight)
                        .animate(animation);

                    animationController.forward();
                  }

                  scale.addListener(() {
                    setState(() {
                      _currentHeight = scale.value;
                      if (scale.value == 0.0) Navigator.pop(context);
                    });
                  });
                }
                lastScrollDirection = "";
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (details.primaryDelta > 0) {
                  // downward
                  lastScrollDirection = "down";
                  if (scrollController.offset > 0.0) {
                    scrollController.jumpTo(
                        scrollController.offset + details.primaryDelta * -1);
                  } else {
                    if (_currentHeight > 0.0) {
                      setState(() {
                        _currentHeight += details.primaryDelta * -1;
                      });
                    }
                  }
                } else {
                  lastScrollDirection = "up";

                  // upward
                  if (_currentHeight <= _maxHeight) {
                    setState(() {
                      _currentHeight += details.primaryDelta * -1;
                    });
                  } else {
                    scrollController.jumpTo(
                        scrollController.offset + details.primaryDelta * -1);
                  }
                }
              },
              child: SingleChildScrollView(
                  controller: scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  child: widget.child)));
    });

    return child;
  }
}
