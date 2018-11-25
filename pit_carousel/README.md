# Carousel by PIT

Our custom Carousel

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.

## Installation

First, add `pit_carousel` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_carousel: ^0.0.1
```

## Example
```
class PitCarouselDemo extends StatefulWidget {
  @override
  _PitCarouselDemoState createState() => _PitCarouselDemoState();
}

class _PitCarouselDemoState extends State<PitCarouselDemo> {
  List<Widget> _pages = [
    Image.network(
        "http://androidcut.com/wp-content/uploads/2017/07/Boat-River-View-1920x1080-Portrait.jpg",
        fit: BoxFit.cover),
    Image.network(
        "http://androidcut.com/wp-content/uploads/2017/08/Beach-Top-View-Wallpaper-Portrait-1920x1080.jpg",
        fit: BoxFit.cover),
    Image.network(
        "http://www.sompaisoscatalans.cat/simage/8/85501/wallpaper-portrait-android.jpg",
        fit: BoxFit.cover),
    Image.network(
        "https://c.wallhere.com/photos/dd/c9/architecture_building_skyscraper_blueprints_digital_art_3d_object_render_CGI-88920.jpg!d",
        fit: BoxFit.cover),
    Image.network("https://pbs.twimg.com/media/C2dVR-sWEAAaId7.jpg",
        fit: BoxFit.cover),
    Image.network(
        "https://www.gambar.co.id/wp-content/uploads/2018/04/wallpaper-xiaomi-mi-a1-hd-download-hd-wallpapers-of-digital-art-portrait-display-of-wallpaper-xiaomi-mi-a1-hd.png",
        fit: BoxFit.cover),
    Image.network(
        "http://htc-wallpaper.com/wp-content/uploads/2013/11/Moon1.jpg",
        fit: BoxFit.cover),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: AdvCarousel(
          children: _pages,
          dotAlignment: Alignment.topLeft,
          height: double.infinity,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(milliseconds: 300),
          displayDuration: Duration(seconds: 3),
        ),
      ),
    );
  }
}
```
