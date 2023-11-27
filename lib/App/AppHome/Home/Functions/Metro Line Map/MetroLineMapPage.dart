import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:photo_view/photo_view.dart';

class MetroLineMapPage extends StatefulWidget {
  const MetroLineMapPage({super.key});

  @override
  State<MetroLineMapPage> createState() => _MetroLineMapPageState();
}

class _MetroLineMapPageState extends State<MetroLineMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metro Line Map"),
        backgroundColor: c1,
      ),
      body: Container(
        color: Colors.transparent,
        child: PhotoView(
          initialScale: PhotoViewComputedScale.covered,
          basePosition: Alignment.center,
          minScale: PhotoViewComputedScale.covered,
          imageProvider:
          AssetImage("assets/Maps/${selectedCity}MetroMap.png"),
        ),
      ),
    );
  }
}
