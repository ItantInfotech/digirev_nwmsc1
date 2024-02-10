import 'dart:convert';

import 'package:digirev_nwmsc/WelcomeScreen.dart';
import 'package:digirev_nwmsc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'model/model.dart';


class  FirstScreen extends StatefulWidget {

  @override
  _FirstScreen createState()  => _FirstScreen();

}

class _FirstScreen extends State<FirstScreen>{


  void initState(){
    // TODO: implement initState

    createBackupFolder('/storage/emulated/0/Download/DigiRevApp');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Guest');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Visitor');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Guest/Certificates');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Guest/Reviews');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Visitor/Certificates');
    createBackupFolder('/storage/emulated/0/Download/DigiRevApp/Visitor/Reviews');

    navigateToNextScreen();
    // getAssetData();


copyFiles('/data/user/0/com.example.digirev_nwmsc/app_flutter/objectbox','/storage/emulated/0/Download/DigiRevApp');
    super.initState();
  }


  Future<void> createBackupFolder(String folderPath) async {
    try {


      Directory backupFolder = Directory(folderPath);

      if (!(await backupFolder.exists())) {
        await backupFolder.create(recursive: true);
        print('Backup folder created: $folderPath');
      } else {
        print('Backup folder already exists: $folderPath');
      }
    } catch (e) {
      print('Error creating backup folder: $e');
    }
  }
  Future<void> copyFiles(String sourceDirectory, String destinationDirectory) async {
    try {
      final data=objectbox.ReviewBox.getAll();
      final List<Map<String, dynamic>> jsonDataList = data.map((entity) => entity.toJson()).toList();

      final File jsonFile = File('/storage/emulated/0/Download/DigiRevApp/data.json');
      await jsonFile.writeAsString(json.encode(jsonDataList));
      

      final appDocumentDirectory = await path.getApplicationDocumentsDirectory();
      final defaultDbPath = appDocumentDirectory.path + '/objectbox';
      // print('Default ObjectBox Database Path: $defaultDbPath');
      Directory sourceDir = Directory(defaultDbPath);
      List<FileSystemEntity> files = await sourceDir.list().toList();

      for (FileSystemEntity file in files) {
        if (file is File) {
          String fileName = file.uri.pathSegments.last;
          String destinationPath = '$destinationDirectory/$fileName';

          await file.copy(destinationPath);
          print('Copied: $destinationPath');
        }
      }
    } catch (e) {
      print('Error copying files: $e');
    }
  }

  Future<void> copyAssetToApplicationDirectory(String assetPath, String destinationPath) async {
    // print(assetPath);
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    await File(destinationPath).writeAsBytes(bytes);
  }


//   Future<void> getAssetData() async{
// if(objectbox.check()){
//   final applicationDirectory = await path.getApplicationDocumentsDirectory();
//
//   final assetsData = [
//     {
//       'name': 'Vipul Shinghal',
//       'rank': 'Lt Gen',
//       'appointment':'',
//       'address': 'GOC 21 Corps',
//       'profilePic': 'vipulprofile.jpg',
//       'hReview': 'vipulreview.png',
//       'signature': 'vipulsign.png',
//
//     },
//     {
//       'name': 'Sanmeet Singh',
//       'rank': 'Col',
//       'appointment':'Col MS',
//       'address': 'HQ 21 Corps',
//       'profilePic': 'sanmeetprofile.png',
//       'hReview': 'sanmeetreview.png',
//       'signature': 'sanmeetsign.png',
//     },
//     {
//       'name': 'Dhruv Sahdev',
//       'rank': 'Maj',
//       'appointment':'',
//       'address': 'ADC to GOC 21 Corps',
//       'profilePic': 'dhruvprofile.png',
//       'hReview': 'dhruvreview.png',
//       'signature': 'dhruvsign.png',
//     },
//   ];
//   for (final asset in assetsData) {
//     final profilepath='assets/${asset['profilePic']!}';
//     final reviewpath='assets/${asset['hReview']!}';
//     final signaturepath='assets/${asset['signature']!}';
//     // final assetPath = 'assets/$asset';
//     final destinationprofilePath = '${applicationDirectory.path}/${asset['profilePic']!}';
//     final destinationreviewPath = '${applicationDirectory.path}/${asset['hReview']!}';
//     final destinationsignaturePath = '${applicationDirectory.path}/${asset['signature']!}';
//
//
//     // Copy asset to application directory
//     await copyAssetToApplicationDirectory(profilepath, destinationprofilePath);
//     await copyAssetToApplicationDirectory(reviewpath, destinationreviewPath);
//     await copyAssetToApplicationDirectory(signaturepath, destinationsignaturePath);
//     // DateTime now=DateTime.now();
//     // String formattedDate=DateFormat('dd-MM-yyyy').format(now);
//
//     final review=Review(
//       rank:asset['rank'],
//       name:asset['name'],
//       profilePic: destinationprofilePath,
//       signature: destinationsignaturePath,
//       hReview: destinationreviewPath,
//       aReview: null,
//       address: asset['address'],
//       appointment: asset['appointment'],
//       type:"vip",
//       client:"21corps",
//       date: "29-12-2023",
//
//     );
//     // print(review.hReview);
//
//     objectbox.ReviewBox.put(review);
//     // Store asset path in ObjectBox
//
//   }
// }else{
//
// }
//
//
//
//
//
//   }

  void navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(

        image: DecorationImage(

          image: AssetImage('assets/welcome22.jpg'),
          fit: BoxFit.cover,
        ),

      ),
      child: Scaffold (
        backgroundColor: Colors.transparent,



        body : AnnotatedRegion<SystemUiOverlayStyle>(
          value : SystemUiOverlayStyle.light,
          child: GestureDetector (

            // child: Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            //   child: Text("Tap on screen.", style: TextStyle(
            //     color: Colors.white30,
            //     fontWeight: FontWeight.bold
            //   )),
            // ),
              onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen())
                );
              }),
          // child: Stack(
          //   children: <Widget>[
          //     // Container(
          //     //   padding: EdgeInsets.all(10),
          //     //   alignment: Alignment.center,
          //     //   // width: 300,
          //     //   // height: 300,

          //     //   // child: Image.asset('assets/logo.jpeg'),
          //     //   child: Stack(
          //     //     alignment: Alignment.topCenter,
          //     //     children: <Widget>[
          //     //     Column(
          //     //       mainAxisAlignment: MainAxisAlignment.center,
          //     //       crossAxisAlignment: CrossAxisAlignment.center,
          //     //       children: [
          //     //         Container(
          //     //         width: 100,
          //     //   height: 100,

          //     //   child: Image.asset('assets/logo.jpeg'),
          //     //         ),
          //     //         SizedBox(height: 10),
          //     //         Container(

          //     //     width: 130,
          //     //   height: 150,

          //     //   child: Text("THE CHINAR CORPS",selectionColor: Colors.white, style: TextStyle(
          //     //     color: Colors.black45, backgroundColor: Colors.white
          //     //   )),
          //     //     ),
          //     //       ],
          //     //     ),


          //     //   ],),
          //     // ),
          //     // SizedBox(height: 10),
          //     // Container(
          //     //   padding: EdgeInsets.all(10),
          //     //   alignment: Alignment.center,
          //     //   width: 200,
          //     //   height: 100,
          //     //   child: Text("THE CHINAR CORPS", fontWeight: FontWeight.bold,),

          //     // ),
          //     SizedBox(height: 100),
          //     Container(
          //       height: double.infinity,
          //       width: double.infinity,
          //       alignment: Alignment.bottomCenter,
          //       // decoration: BoxDecoration(
          //       //   gradient: LinearGradient(
          //       //     begin: Alignment.topCenter,
          //       //     end: Alignment.bottomCenter,
          //       //     colors: [
          //       //       Color(0x665ac18e),
          //       //       Color(0x995ac18e),
          //       //       Color(0xcc5ac18e),
          //       //       Color(0xff5ac18e),
          //       //     ]
          //       //   )
          //       // ),

          //       child: SingleChildScrollView(

          //         physics: AlwaysScrollableScrollPhysics(),
          //         padding: EdgeInsets.symmetric(
          //           vertical: 120,
          //           horizontal: 25
          //         ),
          //         child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,

          //         children: <Widget>[
          //           Container(
          //             child: ElevatedButton(
          //               child: Text('Admin'),
          //               onPressed: (){
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(builder: (context) => LogicScreen())
          //                   );

          //               },


          //             ),
          //           ),
          //           SizedBox(height: 15, width: 50),
          //           Container(
          //             child: ElevatedButton(
          //               child: Text('Guest'),
          //               onPressed: (){
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(builder: (context) => CreateReviewPage2())
          //                   );

          //               },
          //             ),
          //           ),

          //         ],
          //       ),
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
      // persistentFooterButtons:  [
      //   Container(
      //     alignment: Alignment.bottomLeft,
      //     child: Image.asset(
      //       'assets/digi_rev.jpeg',
      //       height: 50,
      //       width : 100,
      //       // alignment: Alignment.bottomLeft,
      //       filterQuality: FilterQuality.high,),
      //   )
      //    ],
      // ),
    );
  }


} 