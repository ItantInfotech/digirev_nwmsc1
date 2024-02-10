import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path_provider/path_provider.dart';

class ManageStrip extends StatefulWidget{
  ManageStripState createState()=>ManageStripState();
}

class ManageStripState extends State<ManageStrip>{


  final String _folderName = 'strip';
  final int _maxImages = 6;
  late File _imageListFile;
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final folderPath = '${appDir.path}/$_folderName';
    final folder = Directory(folderPath);

    if (await folder.exists()) {
      _imageFiles = (await folder.list().toList())
          .where((FileSystemEntity entity) => entity is File)
          .cast<File>()
          .toList();
      setState(() {});
    }
  }

  Future<void> _pickAndCropImage() async {
    if (_imageFiles.length >= _maxImages) {
      // Display a message or alert that the maximum image limit has been reached.
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        _saveImage(croppedFile);
      }
    }
  }



  Future<File?> _cropImage(String imagePath) async {
    File? croppedFile;

    try {
      final cropResult = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        cropStyle: CropStyle.rectangle,
        compressQuality: 30,

      );

      // Check if the user canceled cropping
      if (cropResult != null) {
        croppedFile = File(cropResult.path);
      }
    } catch (e) {
      print('Error cropping image: $e');
    }

    return croppedFile;
  }

  Future<void> _saveImage(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final folderPath = '${appDir.path}/$_folderName';

    // Create the folder if it doesn't exist
    Directory(folderPath).createSync(recursive: true);

    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '$folderPath/$fileName';

    File(filePath).writeAsBytesSync(await imageFile.readAsBytes());
    setState(() {
      _imageFiles.add(File(filePath));
    });
  }
  Future<void> _confirmDeleteImage(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Do you really want to delete this image?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteImage(index);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteImage(int index) async {
    final file = _imageFiles[index];
    await file.delete();
    _imageFiles.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(
        children: [
          Text("Please select 6 images one by one to create a strip that will be visible in VIP and Guest Welcome Screen!"),
          ElevatedButton(
            onPressed: _pickAndCropImage,
            child: Text('Pick and Crop Image'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _confirmDeleteImage(index),
                  child: Image.file(_imageFiles[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
    // TODO: implement build
    return Scaffold();
  }

}