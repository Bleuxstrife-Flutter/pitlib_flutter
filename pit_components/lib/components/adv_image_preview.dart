import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_visibility.dart';
import 'package:pit_components/pit_components.dart';

class AdvImagePreview extends StatefulWidget {
  final AdvImagePreviewController controller;
  final double height;

  AdvImagePreview(
      {double height,
      int currentImage,
      List<ImageProvider> imageProviders,
      AdvImagePreviewController controller})
      : assert(controller == null ||
            (currentImage == null && imageProviders == null)),
        this.height = height ?? 250.0,
        this.controller = controller ??
            AdvImagePreviewController(
                currentImage: currentImage ?? 0,
                imageProviders: imageProviders ?? const []);

  @override
  _AdvImagePreviewState createState() => new _AdvImagePreviewState();
}

class _AdvImagePreviewState extends State<AdvImagePreview> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final AdvImagePreviewController controller = widget.controller;

    children.add(Expanded(
        child: ClipRect(
      child: PhotoView(
        backgroundDecoration: BoxDecoration(
            color: Colors.black.withBlue(60).withGreen(60).withRed(60)),
        imageProvider:
            widget.controller.imageProviders[widget.controller.currentImage],
        maxScale: PhotoViewComputedScale.covered * 2.0,
        minScale: PhotoViewComputedScale.contained * 0.8,
        initialScale: PhotoViewComputedScale.covered,
      ),
    )));

    if (controller.imageProviders.length > 1) {
      List<Widget> thumbnails = [];

      for (int i = 0; i < controller.imageProviders.length; i++) {
        Widget image = Container(
          child: Image(
            image: controller.imageProviders[i],
            fit: BoxFit.cover,
          ),
          color: Colors.black,
          height: widget.height / 5,
          width: widget.height / 5,
        );

        thumbnails.add(InkWell(
            onTap: () {
              controller.currentImage = i;
            },
            child: Stack(children: [
              image,
              AdvVisibility(
                child: Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  height: widget.height / 100,
                  child:
                      Container(color: PitComponents.selectedImagePreviewColor),
                ),
                visibility: i == controller.currentImage
                    ? VisibilityFlag.visible
                    : VisibilityFlag.gone,
              )
            ])));
      }

      Widget rowOfThumbnails = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AdvRow(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              divider: RowDivider(4.0),
              children: thumbnails));

      children.add(rowOfThumbnails);
    }

    return Container(
        width: double.infinity,
        height: widget.height,
        child: Column(
          children: children,
          mainAxisSize: MainAxisSize.max,
        ),
        color: Colors.black.withBlue(30).withGreen(30).withRed(30));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("ImageWithThumbnail didChangeDependencies");
  }
}

class AdvImagePreviewController
    extends ValueNotifier<AdvImagePreviewEditingValue> {
  int get currentImage => value.currentImage;

  set currentImage(int newCurrentImage) {
    value = value.copyWith(
        currentImage: newCurrentImage, imageProviders: this.imageProviders);
  }

  List<ImageProvider> get imageProviders => value.imageProviders;

  set imageProviders(List<ImageProvider> newImageProviders) {
    value = value.copyWith(
        currentImage: this.currentImage, imageProviders: newImageProviders);
  }

  AdvImagePreviewController(
      {int currentImage, List<ImageProvider> imageProviders})
      : super(currentImage == null && imageProviders == null
            ? AdvImagePreviewEditingValue.empty
            : new AdvImagePreviewEditingValue(
                currentImage: currentImage, imageProviders: imageProviders));

  AdvImagePreviewController.fromValue(AdvImagePreviewEditingValue value)
      : super(value ?? AdvImagePreviewEditingValue.empty);

  void clear() {
    value = AdvImagePreviewEditingValue.empty;
  }
}

@immutable
class AdvImagePreviewEditingValue {
  const AdvImagePreviewEditingValue(
      {int currentImage, List<ImageProvider> imageProviders = const []})
      : this.currentImage = currentImage ?? 0,
        this.imageProviders = imageProviders ?? const [];

  final int currentImage;
  final List<ImageProvider> imageProviders;

  static const AdvImagePreviewEditingValue empty =
      const AdvImagePreviewEditingValue();

  AdvImagePreviewEditingValue copyWith(
      {int currentImage, List<ImageProvider> imageProviders}) {
    return new AdvImagePreviewEditingValue(
        currentImage: currentImage ?? this.currentImage,
        imageProviders: imageProviders ?? this.imageProviders);
  }

  AdvImagePreviewEditingValue.fromValue(AdvImagePreviewEditingValue copy)
      : this.currentImage = copy.currentImage,
        this.imageProviders = copy.imageProviders;

  @override
  String toString() => '$runtimeType(currentImage: \u2524$currentImage\u251C, '
      'imageProviders: \u2524$imageProviders\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AdvImagePreviewEditingValue) return false;
    final AdvImagePreviewEditingValue typedOther = other;
    return typedOther.currentImage == currentImage &&
        typedOther.imageProviders == imageProviders;
  }

  @override
  int get hashCode =>
      hashValues(currentImage.hashCode, imageProviders.hashCode);
}
