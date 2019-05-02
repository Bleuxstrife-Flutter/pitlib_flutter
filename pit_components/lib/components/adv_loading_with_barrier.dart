import 'package:flutter/material.dart';
import 'package:pit_components/pit_components.dart';

class AdvLoadingWithBarrier extends StatelessWidget {
  final Widget content;
  final bool isProcessing;
  final Color barrierColor;
  final double width;
  final double height;

  AdvLoadingWithBarrier(
      {this.content, this.isProcessing, Color barrierColor, double width, double height})
      : this.barrierColor = barrierColor ?? PitComponents.loadingBarrierColor,
        this.width = width ?? PitComponents.loadingWidth,
        this.height = height ?? PitComponents.loadingHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[content, _AdvLoadingWrapper(isProcessing, barrierColor, width, height)],
    );
  }
}

class _AdvLoadingWrapper extends StatefulWidget {
  final bool visible;
  final Color barrierColor;
  final double width;
  final double height;

  _AdvLoadingWrapper(this.visible, this.barrierColor, this.width, this.height);

  @override
  State<StatefulWidget> createState() => _AdvLoadingWrapperState();
}

class _AdvLoadingWrapperState extends State<_AdvLoadingWrapper> with TickerProviderStateMixin {
  AnimationController opacityController;

  @override
  void initState() {
    super.initState();
    if (!this.mounted) return;

    opacityController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    opacityController.addListener(() {
      if (this.mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    opacityController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!opacityController.isAnimating) {
        if (widget.visible && opacityController.value == 0.0) opacityController.forward(from: 0.0);
        if (!widget.visible && opacityController.value == 1.0) opacityController.reverse(from: 1.0);
      }
    });

    return Visibility(
      visible: opacityController.value > 0.0,
      child: Positioned.fill(
          child: Opacity(
              opacity: opacityController.value,
              child: Container(
                  color: widget.barrierColor,
                  child: Center(
                      child: Image.asset(
                    PitComponents.loadingAssetName,
                    height: widget.height,
                    width: widget.width,
                  ))))),
    );
  }
}
