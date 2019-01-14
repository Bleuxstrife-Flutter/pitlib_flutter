import 'package:flutter/material.dart';

class AdvLoadingWithBarrier extends StatelessWidget {
  final String loadingImage;
  final Widget content;
  final bool isOnLoading;

  AdvLoadingWithBarrier(this.loadingImage, this.content, this.isOnLoading);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[content, _AdvLoadingWrapper(loadingImage, isOnLoading)],
    );
  }
}

class _AdvLoadingWrapper extends StatefulWidget {
  final String loadingImage;
  final bool visible;

  _AdvLoadingWrapper(this.loadingImage, this.visible);

  @override
  State<StatefulWidget> createState() => _AdvLoadingWrapperState();
}

class _AdvLoadingWrapperState extends State<_AdvLoadingWrapper> with TickerProviderStateMixin {
  AnimationController opacityController;

  @override
  void initState() {
    super.initState();
    opacityController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    opacityController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    opacityController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!opacityController.isAnimating) {
        if (widget.visible && opacityController.value == 0.0)
          opacityController.forward(from: 0.0);
        if (!widget.visible && opacityController.value == 1.0)
          opacityController.reverse(from: 1.0);
      }
    });

    return Visibility(
      visible: opacityController.value > 0.0,
      child: Positioned.fill(
          child: Opacity(
              opacity: opacityController.value,
              child: Container(
                  color: const Color(0x10000000),
                  child: Center(
                      child: Image.asset(
                        widget.loadingImage,
                        height: 30.0,
                      ))))),
    );
  }
}