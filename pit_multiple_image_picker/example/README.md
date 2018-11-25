```
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pit_multiple_image_picker/pit_multiple_image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Image Picker Demo',
      home: new MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<File>> _imageFile;
  bool isVideo = false;
  VideoPlayerController _controller;
  VoidCallback listener;

  void _pickImage(ImageSource source) {
    setState(() {
      isVideo = false;

      _imageFile = PitMultipleImagePicker.pickImage(source: source);
    });
  }

  void _pickImages(int maxImages) {
    setState(() {
      isVideo = false;

      _imageFile = PitMultipleImagePicker.pickImages(maxImages: maxImages);
    });
  }

  void _pickVideo(ImageSource source) {
    setState(() {
      isVideo = true;

      if (_controller != null) {
        _controller.setVolume(0.0);
        _controller.removeListener(listener);
      }

      PitMultipleImagePicker.pickVideo(source: source).then((File file) {
        if (file != null && mounted) {
          setState(() {
            _controller = VideoPlayerController.file(file)
              ..addListener(listener)
              ..setVolume(1.0)
              ..initialize()
              ..setLooping(true)
              ..play();
          });
        }
      });
    });
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
  }

  Widget _previewVideo(VideoPlayerController controller) {
    if (controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatioVideo(controller),
      );
    } else {
      return const Text(
        'Error Loading Video',
        textAlign: TextAlign.center,
      );
    }
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
        child: isVideo ? _previewVideo(_controller) : _previewImage(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
            heroTag: 'Pick Image from gallery',
            child: const Icon(Icons.photo),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _pickImages(5);
              },
              heroTag: 'Take a Photo',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              heroTag: 'Take a Photos',
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _pickVideo(ImageSource.gallery);
              },
              heroTag: 'Pick Video from gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _pickVideo(ImageSource.camera);
              },
              heroTag: 'Take a Video',
              child: const Icon(Icons.videocam),
            ),
          ),
        ],
      ),
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AspectRatioVideo(this.controller);

  @override
  AspectRatioVideoState createState() => new AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      final Size size = controller.value.size;
      return new Center(
        child: new AspectRatio(
          aspectRatio: size.width / size.height,
          child: new VideoPlayer(controller),
        ),
      );
    } else {
      return new Container();
    }
  }
}
```