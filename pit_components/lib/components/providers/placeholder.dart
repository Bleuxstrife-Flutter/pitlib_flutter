import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _kAssetManifestFileName = 'AssetManifest.json';

class PlaceholderImage extends AssetBundleImageProvider {
  final String assetName = "images/placeholder.png";
  static const double _naturalResolution = 1.0;
  static final RegExp _extractRatioRegExp = RegExp(r'/?(\d+(\.\d*)?)x$');
  String get keyName => assetName;

  @override
  Future<AssetBundleImageKey> obtainKey(ImageConfiguration configuration) {
    // This function tries to return a SynchronousFuture if possible. We do this
    // because otherwise showing an image would always take at least one frame,
    // which would be sad. (This code is called from inside build/layout/paint,
    // which all happens in one call frame; using native Futures would guarantee
    // that we resolve each future in a new call frame, and thus not in this
    // build/layout/paint sequence.)
    final AssetBundle chosenBundle = rootBundle;
    Completer<AssetBundleImageKey> completer;
    Future<AssetBundleImageKey> result;

    chosenBundle.loadStructuredData<Map<String, List<String>>>(_kAssetManifestFileName, _manifestParser).then<void>(
            (Map<String, List<String>> manifest) {
          final String chosenName = _chooseVariant(
              keyName,
              configuration,
              manifest == null ? null : manifest[keyName]
          );
          final double chosenScale = _parseScale(chosenName);
          final AssetBundleImageKey key = AssetBundleImageKey(
              bundle: chosenBundle,
              name: chosenName,
              scale: chosenScale
          );
          if (completer != null) {
            // We already returned from this function, which means we are in the
            // asynchronous mode. Pass the value to the completer. The completer's
            // future is what we returned.
            completer.complete(key);
          } else {
            // We haven't yet returned, so we must have been called synchronously
            // just after loadStructuredData returned (which means it provided us
            // with a SynchronousFuture). Let's return a SynchronousFuture
            // ourselves.
            result = SynchronousFuture<AssetBundleImageKey>(key);
          }
        }
    ).catchError((dynamic error, StackTrace stack) {
      // We had an error. (This guarantees we weren't called synchronously.)
      // Forward the error to the caller.
      assert(completer != null);
      assert(result == null);
      completer.completeError(error, stack);
    });
    if (result != null) {
      // The code above ran synchronously, and came up with an answer.
      // Return the SynchronousFuture that we created above.
      return result;
    }
    // The code above hasn't yet run its "then" handler yet. Let's prepare a
    // completer for it to use when it does run.
    completer = Completer<AssetBundleImageKey>();
    return completer.future;
  }

  static Future<Map<String, List<String>>> _manifestParser(String jsonData) {
    if (jsonData == null)
      return SynchronousFuture<Map<String, List<String>>>(null);
    // TODO(ianh): JSON decoding really shouldn't be on the main thread.
    final Map<String, dynamic> parsedJson = json.decode(jsonData);
    final Iterable<String> keys = parsedJson.keys;
    final Map<String, List<String>> parsedManifest =
        Map<String, List<String>>.fromIterables(keys,
    keys.map<List<String>>((String key) => List<String>.from(parsedJson[key])));
    // TODO(ianh): convert that data structure to the right types.
    return SynchronousFuture<Map<String, List<String>>>(parsedManifest);
  }

  String _chooseVariant(String main, ImageConfiguration config, List<String> candidates) {
    if (config.devicePixelRatio == null || candidates == null || candidates.isEmpty)
      return main;
    // TODO(ianh): Consider moving this parsing logic into _manifestParser.
    final SplayTreeMap<double, String> mapping = SplayTreeMap<double, String>();
    for (String candidate in candidates)
      mapping[_parseScale(candidate)] = candidate;
    // TODO(ianh): implement support for config.locale, config.textDirection,
    // config.size, config.platform (then document this over in the Image.asset
    // docs)
    return _findNearest(mapping, config.devicePixelRatio);
  }

  // Return the value for the key in a [SplayTreeMap] nearest the provided key.
  String _findNearest(SplayTreeMap<double, String> candidates, double value) {
    if (candidates.containsKey(value))
      return candidates[value];
    final double lower = candidates.lastKeyBefore(value);
    final double upper = candidates.firstKeyAfter(value);
    if (lower == null)
      return candidates[upper];
    if (upper == null)
      return candidates[lower];
    if (value > (lower + upper) / 2)
      return candidates[upper];
    else
      return candidates[lower];
  }

  double _parseScale(String key) {

    if ( key == assetName){
      return _naturalResolution;
    }

    final File assetPath = File(key);
    final Directory assetDir = assetPath.parent;

    final Match match = _extractRatioRegExp.firstMatch(assetDir.path);
    if (match != null && match.groupCount > 0)
      return double.parse(match.group(1));
    return _naturalResolution; // i.e. default to 1.0x
  }
}