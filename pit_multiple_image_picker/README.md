# Multiple Image Picker by PIT

A Flutter plugin for iOS and Android for picking multiple images from the image library,
and taking new pictures with the camera.

*Note*: This plugin is still under development, and some APIs might not be available yet. This plugin is inspired from  [image picker](https://pub.dartlang.org/packages/image_picker#-readme-tab). The iOS version is okay (using [ELCImagePickerController](https://github.com/B-Sides/ELCImagePickerController)), but the android version is still on progress on its Custom Gallery

## Installation

First, add `pit_multiple_image_picker` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_multiple_image_picker: ^0.0.3
```

## Android
Add these to your app `AndroidManifest.xml` file.

```
        <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
        <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
        <uses-permission android:name="android.permission.CAMERA"/>
        <activity
            android:name=".CustomPhotoGalleryActivity"
            android:screenOrientation="portrait">
        </activity>
```

## iOS
Since we are using *pit_multiple_image_picker* as a dependency from this plugin to load paths from gallery and camera, we need the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

## Example
```
import 'package:pit_multiple_image_picker/pit_multiple_image_picker.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<File>> _imageFile;
  VoidCallback listener;

  void _pickImages(int maxImages) {
    setState(() {
      _imageFile = PitMultipleImagePicker.pickImages(maxImages: maxImages);
    });
  }

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
  }

  Widget _previewImage() {
    return FutureBuilder<List<File>>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List<File> files = snapshot.data;
            return (files.length == 1)
                ? //for pickImage case (1 image)
            files[0] == null ? Container() : new Image.file(files[0])
                : ListView(
                children: files.map((file) {
                  if (file != null) {
                    return Image.file(file);
                  }
                }).toList());
          } else if (snapshot.error != null) {
            return const Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _previewImage(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _pickImages(5); //pick 5 images max
            },
            heroTag: 'Pick Image from gallery',
            child: const Icon(Icons.photo),
          ),
        ],
      ),
    );
  }
}

```
