import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Strip extends StatefulWidget{
// Add key as a parameter


  StripState createState()=>StripState();
}

class StripState extends State<Strip>{
  void initState() {
    super.initState();
    loadLocalImages();

  }

  List<String> imagePaths = [];
  // ... rest of the code remains the same



  Future<void> loadLocalImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDir.path}/strip'); // Replace with your image folder name

      if (await directory.exists()) {
        final files = directory.listSync();
        imagePaths = files
            .where((file) => file is File)
            .map((file) => file.path)
            .toList();

        setState(() {});
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  List<Widget> _buildImageWidgets() {
    final List<Widget> imageWidgets = [];

    for (int i = 0; i < imagePaths.length; i++) {
      // if (i > 0) {
      //   // Add a spacing widget between images
      //   imageWidgets.add(SizedBox(width: 8.0));
      // }

      imageWidgets.add(
        Image.file(
          File(imagePaths[i]),
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width / 6, // Divide by the number of images in a row
        ),
      );
    }

    return imageWidgets;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: _buildImageWidgets(),
      ),
    );

  }

}