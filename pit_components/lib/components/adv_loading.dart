import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvLoading extends StatelessWidget {
  final Key key;
  final AssetBundle bundle;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final double scale;
  final double width;
  final double height;
  final Color color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String package;
  final FilterQuality filterQuality;

  AdvLoading({
    Key key,
    AssetBundle bundle,
    String semanticLabel,
    bool excludeFromSemantics = false,
    double scale,
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    BoxFit fit,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    String package,
    FilterQuality filterQuality = FilterQuality.low,
  })  : this.key = key,
        this.bundle = bundle,
        this.semanticLabel = semanticLabel,
        this.excludeFromSemantics = excludeFromSemantics,
        this.scale = scale,
        this.width = width,
        this.height = height,
        this.color = color,
        this.colorBlendMode = colorBlendMode,
        this.fit = fit,
        this.alignment = alignment,
        this.repeat = repeat,
        this.centerSlice = centerSlice,
        this.matchTextDirection = matchTextDirection,
        this.gaplessPlayback = gaplessPlayback,
        this.package = package,
        this.filterQuality = filterQuality;

  @override
  Widget build(BuildContext context) {
    return Image.asset("images/nemob_loading.gif",
        key: this.key,
        bundle: this.bundle,
        semanticLabel: this.semanticLabel,
        excludeFromSemantics: this.excludeFromSemantics,
        scale: this.scale,
        width: this.width,
        height: this.height,
        color: this.color,
        colorBlendMode: this.colorBlendMode,
        fit: this.fit,
        alignment: this.alignment,
        repeat: this.repeat,
        centerSlice: this.centerSlice,
        matchTextDirection: this.matchTextDirection,
        gaplessPlayback: this.gaplessPlayback,
        package: this.package,
        filterQuality: this.filterQuality);
  }
}
