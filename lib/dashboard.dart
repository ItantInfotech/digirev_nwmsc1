import 'dart:convert';
import 'dart:io';

import 'package:digirev_nwmsc/Export.dart';
import 'package:digirev_nwmsc/ListVips.dart';
import 'package:digirev_nwmsc/ManageStrip.dart';
import 'package:digirev_nwmsc/Objectbox.g.dart';
import 'package:digirev_nwmsc/WelcomeScreen.dart';
import 'package:digirev_nwmsc/main.dart';
import 'package:digirev_nwmsc/model/model.dart';
import 'package:flutter/material.dart';
import 'package:digirev_nwmsc/createvip.dart';
import 'package:intl/intl.dart';
import 'VipReviews.dart';
import 'guestreviews1.dart';
import 'package:file_picker/file_picker.dart';

class DashBoard extends StatefulWidget {
  @override
  DashBoardState createState() => DashBoardState();
}


class DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isExporting=false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    // TODO: Implement logout logic
    // For example, you can navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  Future<void> export() async{
    try{
      setState(() {
        isExporting=true;
      });
      final data=objectbox.ReviewBox.getAll();
      final List<Map<String, dynamic>> jsonDataList = data.map((entity) => entity.toJson()).toList();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);
      String filename='data$formattedDate';
      final File jsonFile = File('/storage/emulated/0/Download/DigiRevApp/$filename+dddd.json');
      await jsonFile.writeAsString(json.encode(jsonDataList));
      setState(() {
        isExporting=false;
      });
      print('Data Export Succesfully');
    }catch(e){
      print(e);
    }

  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        final File jsonFile = File(filePath!);

        final String jsonString = jsonFile.readAsStringSync();
        print(jsonString);
        final List<Map<String, dynamic>> jsonDataList = json.decode(jsonString).cast<Map<String, dynamic>>();

        for (int i = 0; i < jsonDataList.length; i++) {
          Map<String, dynamic> jsonData = jsonDataList[i];

          // Print each key-value pair in the map
          jsonData.forEach((key, value) {
            print('$key: $value');
          });

          // Add a separator between entries for better readability
          print('-----------------------------');
        }


        for (final jsonMap in jsonDataList) {

          final entity = Review.fromJson(jsonMap);
          // print(entity.name);// Implement fromJson in your entity class
          objectbox.ReviewBox.put(entity);
        }

        // Put entities into the ObjectBox database
        // final destinationStore = await openStore(Directory('path_to_destination_database'));
        // final destinationBox = destinationStore.box<Review>();
        // destinationBox.putMany(entitiesToExport);
        //
        // // Close the ObjectBox stores

        // await destinationStore.close();

        print('Data exported successfully.');
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking or processing the file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.green[800],
        actions: [
          TextButton(onPressed: () async{
          pickFile();
          },
              child: Text('Import Data')),
          TextButton(onPressed: () async{
         export();
          },
              child: Text(isExporting?'Exporting':'Export')),
          TextButton(onPressed: () async{
          _logout(context);
          },
              child: Text('Log Out',style: TextStyle(color: Colors.red),)),



        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.reviews), text: 'Guest Reviews'),
            Tab(icon: Icon(Icons.reviews), text: 'Visitor Reviews'),
            Tab(icon: Icon(Icons.group), text: 'Guest List'),
            Tab(icon: Icon(Icons.add_circle), text: 'Create Guest'),

            // Tab(icon: Icon(Icons.exit_to_app), text: 'Export'),
            Tab(icon: Icon(Icons.wallpaper), text: 'Strip'),



          ],
          indicatorColor: Colors.green,
          labelColor: Colors.green[800],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
         VipReviews(),
         GuestReviews1(),
          ListVips(),
          CreateVip(),

         // Export(),
      ManageStrip(),



        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Operation Successful!'),
        duration: Duration(seconds: 2), // Adjust duration as needed
        backgroundColor: Colors.green, // Optional: Customize the background color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
  