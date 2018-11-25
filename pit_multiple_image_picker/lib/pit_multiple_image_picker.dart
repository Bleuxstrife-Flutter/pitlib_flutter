import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Specifies the source where the picked image should come from.
enum ImageSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

class PitMultipleImagePicker {
  static const MethodChannel _channel =
  const MethodChannel('pit_multiple_image_picker');

  /// Returns a [List<File>] object pointing to the image that was picked.
  ///
  /// The [source] argument controls where the image comes from. This can
  /// be either [ImageSource.camera] or [ImageSource.gallery].
  ///
  /// If specified, the image will be at most [maxWidth] wide and
  /// [maxHeight] tall. Otherwise the image will be returned at it's
  /// original width and height.
  static Future<List<File>> pickImage({
    @required ImageSource source,
    double maxWidth,
    double maxHeight,
  }) async {
    assert(source != null);

    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    final String path = await _channel.invokeMethod(
      'pickImage',
      <String, dynamic>{
        'source': source.index,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );

    return [path == null ? null : new File(path)];
  }

  /// Returns a [List<File>] object pointing to the images that was picked.
  ///
  /// If specified, the image will be at most [maxWidth] wide and
  /// [maxHeight] tall. Otherwise the image will be returned at it's
  /// original width and height.
  ///
  /// [maxImages] argument is used to determine maximum images that is able to be picked
  static Future<List<File>> pickImages({
    double maxWidth,
    double maxHeight,
    int maxImages = 5,
  }) async {
    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    final List<dynamic> paths = await _channel.invokeMethod(
      'pickImages',
      <String, dynamic>{
        'maxImages': maxImages ?? 5,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );

    print("paths = $paths");

    List<File> files = [];

    files = paths.map((path) {
      return path == null ? null : new File(path);
    }).toList();

    return files;
  }

  static Future<File> pickVideo({
    @required ImageSource source,
  }) async {
    assert(source != null);

    final String path = await _channel.invokeMethod(
      'pickVideo',
      <String, dynamic>{
        'source': source.index,
      },
    );
    return path == null ? null : new File(path);
  }
}
