import 'package:flutter/material.dart';
import 'package:pit_components/pit_components.dart';

class AdvRatingBar extends StatefulWidget {
  final double size;
  final int starCount;
  final bool enableHalfStar;
  final bool enable;
  final AdvRatingBarController controller;

  AdvRatingBar(
      {this.size = 50.0,
      this.starCount = 5,
      this.enableHalfStar = true,
      double rating,
      this.enable = true,
      AdvRatingBarController controller})
      : assert(controller == null || (rating == null)),
        this.controller =
            controller ?? new AdvRatingBarController(rating: rating ?? 0.0);

  @override
  State<StatefulWidget> createState() => _AdvRatingBarState();
}

class _AdvRatingBarState extends State<AdvRatingBar> {
  @override
  void initState() {
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          widget.starCount,
          (i) => _buildStar(widget.size, i + 1),
        ));
  }

  _buildStar(double size, int value) {
    double decValue = value.toDouble();

    return Stack(children: [
      Icon(
          widget.controller.rating >= decValue
              ? Icons.star
              : widget.controller.rating == decValue - 0.5 &&
                      widget.enableHalfStar
                  ? Icons.star_half
                  : widget.controller.rating == decValue - 0.5 &&
                          !widget.enableHalfStar
                      ? Icons.star
                      : Icons.star_border,
          size: size,
          color: PitComponents.ratingBarColor),
      Container(
        width: size,
        height: size,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => widget.enable
                      ? widget.controller.rating = decValue - 0.5
                      : {},
                  child: Container(
                    constraints: BoxConstraints.expand(),
                  ))),
          Expanded(
              child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () =>
                      widget.enable ? widget.controller.rating = decValue : {},
                  child: Container(
                    constraints: BoxConstraints.expand(),
                  )))
        ]),
      ),
    ]);
  }
}

class AdvRatingBarController extends ValueNotifier<AdvRatingBarValue> {
  double get rating => value.rating;

  set rating(double newRating) {
    value = value.copyWith(rating: newRating);
  }

  AdvRatingBarController({double rating})
      : super(rating == null
            ? AdvRatingBarValue.empty
            : new AdvRatingBarValue(rating: rating));

  AdvRatingBarController.fromValue(AdvRatingBarValue value)
      : super(value ?? AdvRatingBarValue.empty);

  void clear() {
    value = AdvRatingBarValue.empty;
  }
}

@immutable
class AdvRatingBarValue {
  const AdvRatingBarValue({this.rating = 0.0});

  final double rating;

  static const AdvRatingBarValue empty = const AdvRatingBarValue();

  AdvRatingBarValue copyWith({double rating}) {
    return new AdvRatingBarValue(rating: rating ?? this.rating);
  }

  AdvRatingBarValue.fromValue(AdvRatingBarValue copy)
      : this.rating = copy.rating;

  @override
  String toString() => '$runtimeType(rating: \u2524$rating\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvRatingBarValue) return false;
    final AdvRatingBarValue typedOther = other;
    return typedOther.rating == rating;
  }

  @override
  int get hashCode => rating.hashCode;
}
