import 'dart:convert';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:digirev_nwmsc/FirstScreen.dart';
import 'package:digirev_nwmsc/ObjectBox.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import 'model/model.dart';

late ObjectBox objectbox;




Future<pw.Widget> buildTable(List<Review> reviews) async{
  List<pw.TableRow> rows = [];
  final img = await rootBundle.load('assets/logo3.png');
  final logo = img.buffer.asUint8List();


  for(var review in reviews){

    final profilepic=pw.MemoryImage(review.profilePic!);
    final signature=pw.MemoryImage(review.signature!);
    final hreview=pw.MemoryImage(review.hReview!);


    rows.add(pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[pw.Container(width:70,height:70,child: pw.Image(profilepic)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
        pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[pw.Text('${review.rank!} ${review.name!}\n${review.appointment!} ${review.address!}'),],mainAxisAlignment: pw.MainAxisAlignment.center),),
        pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[ pw.Container(width:200,child: pw.Image(hreview)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
        pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[ pw.Container(width:100,child: pw.Image(signature)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
        pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[   pw.Text(review.date!),],mainAxisAlignment: pw.MainAxisAlignment.center),)








      ],
    ));
  }

  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),
    children: [
      // Header row
      pw.TableRow(
        children: [
          pw.Text('Profile', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Review', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Signature', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
      // Data rows



      ...rows,
      // Add more rows as needed
    ],
  );
}


Future<void> savePdf(pdf,type) async{
  // final dir=await path.getExternalStorageDirectory();
  // print(dir?.path);
  // Directory appdir= await path.getApplicationDocumentsDirectory();
  if(type=='vip'){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

  // Concatenate the formatted date with the file name
  String fileName = 'VIP_$formattedDate';

  // final fileName='VIP Reviews';

    final filePath='/storage/emulated/0/Download/DigiRevApp/VIP/Reviews/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }else if(type=='guest'){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Concatenate the formatted date with the file name
    String fileName = 'Guest_$formattedDate';

    final filePath='/storage/emulated/0/Download/DigiRevApp/Guest/Reviews/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

  // print(filePath);

}


Future<void> exportData(String type) async {
  final pdf=pw.Document();
  final maxReviewsPerPage = 4;

  try {


    final img1 = await rootBundle.load('assets/digirevlogo.png');
    final img = await rootBundle.load('assets/logo3.png');
    final logo = img.buffer.asUint8List();
    final digirevlogo = img1.buffer.asUint8List();

    final reviews = objectbox.getTodayReview(type);
    if(reviews.length>0){
      for (var i = 0; i < reviews.length; i += maxReviewsPerPage) {
        final startIndex = i;
        final endIndex =
        (i + maxReviewsPerPage < reviews.length) ? i + maxReviewsPerPage : reviews.length;

        final table = await buildTable(reviews.sublist(startIndex, endIndex));

        pdf.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(5.0),

            build: (pw.Context context) {
              return pw.Column(
                //
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children:[
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 70,
                            child:pw.Image(pw.MemoryImage(logo)),
                          ),
                          // pw.Text('REVIEWS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ]
                    ),
                    table,
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 70,
                            child:pw.Image(pw.MemoryImage(digirevlogo)),
                          ),

                        ]
                    ),
                  ]
              );
            },
          ),
        );
      }

      await savePdf(pdf,type);
    }else{

    }





  } catch (e) {


  // print(e.toString());

    // Handle any exceptions
  }
}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  objectbox=await ObjectBox.create();


  BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,  // <-- minutes
      stopOnTerminate: false,
      startOnBoot: true
  ), (String taskId) async {  // <-- Event callback
    // This callback is typically fired every 15 minutes while in the background.
    // print('Background working properly');
    await exportData('guest');
    await exportData('visitor');

    // print('[BackgroundFetch] Event received.');
    // IMPORTANT:  You must signal completion of your fetch task or the OS could
    // punish your app for spending much time in the background.
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {  // <-- Task timeout callback
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    BackgroundFetch.finish(taskId);
  });



  Future<void> requestPermissions() async {
    // Request microphone, camera, and storage permissions
    Map<Permission, PermissionStatus> status = await [
      Permission.microphone,
      Permission.camera,
      Permission.storage,
    ].request();

    // Check the status of each permission
    if (status[Permission.microphone] != PermissionStatus.granted) {
      // Handle the case when microphone permission is not granted
      print('Microphone permission not granted!');
    }

    if (status[Permission.camera] != PermissionStatus.granted) {
      // Handle the case when camera permission is not granted
      print('Camera permission not granted!');
    }

    if (status[Permission.storage] != PermissionStatus.granted) {
      // Handle the case when storage permission is not granted
      print('Storage permission not granted!');
    }
  }



print(objectbox.store.directoryPath);
  await requestPermissions();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar translucent
    ));
    return MaterialApp(
      theme: ThemeData(
        highlightColor: Colors.green,
        indicatorColor: Colors.green,
        primarySwatch: Colors.green, // Set primary color to green
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green, // Set the button color to green
          textTheme: ButtonTextTheme.primary, // Make text on buttons white
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Set default text color
          // Add more text styles as needed
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FirstScreen(),
      ),
    );
  }
}



