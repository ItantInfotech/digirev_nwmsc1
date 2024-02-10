import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class audioplay extends StatefulWidget{
  audioplaystate createState()=>audioplaystate();
}

class audioplaystate extends State<audioplay>{

  List<File> files = [];

  @override
  void initState() {
    super.initState();
    _getFilesInDirectory();
  }


  // void play() async{
  //   await player.play(DeviceFileSource('/data/user/0/com.example.digi_rev/app_flutter/1703584714010.m4a'));
  // }

  Future<void> _getFilesInDirectory() async {
    try {
      // Get the application documents directory
      Directory appDir = await getApplicationDocumentsDirectory();

      // List all files in the directory
      List<FileSystemEntity> dirContents = appDir.listSync();

      // Filter only files (excluding directories)
      files = dirContents.whereType<File>().toList();

      setState(() {
        // Update the state with the files found in the directory
        // You can use this 'files' list to display the file names or perform actions
        // For example, you can display the file names in a ListView
      });
    } catch (e) {
      print('Error retrieving files: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File List'),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(files[index].path), // Display file path or name
            // You can add onTap to perform actions when a file is tapped
            onTap: () {
              // Add your logic here when a file is tapped
              print('File tapped: ${files[index].path}');
            },
          );
        },
      ),
    );
  }

}