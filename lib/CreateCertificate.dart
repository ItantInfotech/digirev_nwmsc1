import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:digirev_nwmsc/constants.dart';
import 'package:intl/intl.dart';
import 'model/model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';


class CreateCertificate extends StatefulWidget{
  late Review review;
  CreateCertificate(this.review);

  @override
  CreateCertificateState createState()=>CreateCertificateState(review);
}



class CreateCertificateState extends State<CreateCertificate>{
  final Review review;
  CreateCertificateState(this.review);
  bool _isCreating=false;
  final pdf=pw.Document();

  void initState() {
    // TODO: implement initState
    // initializeStrip();
    Review reviews=this.review;
    super.initState();
  }

  Future<void> requestStoragePermissions() async {
    var status = await Permission.manageExternalStorage.status;
    print(status);

    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();

      if (!status.isGranted) {
        // Handle the case when permission is not granted
        print('Permission not granted!');
      }
    }
  }

  Future<void> savePdf(type,name) async{
    // final dir=await path.getExternalStorageDirectory();
    // print(dir?.path);
    // Directory appdir= await path.getApplicationDocumentsDirectory();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    final fileName=name+' '+formattedDate;
    if(type=='guest'){
      final filePath='/storage/emulated/0/Download/DigiRevApp/Guest/Certificates/$fileName.pdf';
      print(filePath);
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    }else if(type=='visitor'){
      final filePath='/storage/emulated/0/Download/DigiRevApp/Visitor/Certificates/$fileName.pdf';
      print(filePath);
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    }


  }

  Future<void> generateCertificate() async{

    final profilepic= pw.MemoryImage(review.profilePic!);
    final signature=pw.MemoryImage(review.signature!);
    final hreview=pw.MemoryImage(review.hReview!);
    // final profilepic=pw.MemoryImage(File(review.profilePic!).readAsBytesSync());
    // final signature=pw.MemoryImage(File(review.signature!).readAsBytesSync());
    // final hreview=pw.MemoryImage(File(review.hReview!).readAsBytesSync());
    final borderimg=await rootBundle.load('assets/bordertopleft.png');
    final borderimg1=await rootBundle.load('assets/bordertopright.png');
    final borderimg2=await rootBundle.load('assets/middleborder.png');
    final borderimg3=await rootBundle.load('assets/borderbottomleft.png');
    final borderimg4=await rootBundle.load('assets/borderbottomright.png');
    final bordertopleft=borderimg.buffer.asUint8List();
    final bordertopright=borderimg1.buffer.asUint8List();
    final borderbottomleft=borderimg3.buffer.asUint8List();
    final borderbottomright=borderimg4.buffer.asUint8List();
    final middleborder=borderimg2.buffer.asUint8List();

    final img = await rootBundle.load('assets/logo2.png');
    final logo = img.buffer.asUint8List();
    final armyimage=await rootBundle.load(armylogo1);
    final army=armyimage.buffer.asUint8List();
    final img2 = await rootBundle.load('assets/background.jpg');
    final background = img2.buffer.asUint8List();
    final img3 = await rootBundle.load('assets/certbacknew.png');
    final certback = img3.buffer.asUint8List();
    // final img1 = await rootBundle.load('assets/digirevlogo.png');
    // final digirevlogo = img1.buffer.asUint8List();
    final containerwidth=MediaQuery.of(context).size.width*0.8;
setState(() {
  _isCreating=true;
});

try{
  pdf.addPage(pw.Page(

      pageFormat: const PdfPageFormat(700,450),
      build: (pw.Context context) {

        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black),
            image:pw.DecorationImage(image: pw.MemoryImage(background),fit: pw.BoxFit.cover),
          ),
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [


                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 120,
                              height:120,
                              child: pw.Image(pw.MemoryImage(logo)),
                            ),
                          ]
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(

                              child: pw.Text(
                                  "VISITOR MOMEMTS",
                                  style:   pw.TextStyle(fontWeight:pw.FontWeight.bold,fontSize: 25,color: PdfColors.white)),
                            ),
                          ]
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 120,
                              height:120,
                              child: pw.Image(pw.MemoryImage(army)),
                            ),
                          ]
                      ),




                    ]
                ),
                // pw.Row(
                //     mainAxisAlignment: pw.MainAxisAlignment.center,
                //   children: [
                //     pw.Container(
                //       color: PdfColors.black,
                //       height:1,
                //       width:700,
                //     )
                //   ]
                // ),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.center,
                //   children: [
                pw.Padding(
                  padding:pw.EdgeInsets.all(0),
                  child: pw.Stack(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            // border: pw.Border.all(color: PdfColors.black),
                            borderRadius:  pw.BorderRadius.circular(10.0),
                            image:pw.DecorationImage(image: pw.MemoryImage(certback),fit: pw.BoxFit.cover),
                            //color: const PdfColor.fromInt(0x80adaaab),
                          ),
                          height:350,
                        ),
                        pw.Positioned(top:4,left:4,child: pw.Image(pw.MemoryImage(bordertopleft),width: 50),),
                        pw.Positioned(top:4,right:4,child: pw.Image(pw.MemoryImage(bordertopright),width: 50),),
                        pw.Positioned(bottom:4,left:4,child: pw.Image(pw.MemoryImage(borderbottomleft),width: 50),),
                        pw.Positioned(bottom:4,right:4,child: pw.Image(pw.MemoryImage(borderbottomright),width: 50),),
                        pw.Positioned(
                          bottom:4,
                          left:0,
                          right:0,
                          child: pw.Center(child: pw.Image(pw.MemoryImage(middleborder),width: 140),),
                        ),

                        pw.Positioned(
                         top:4,
                          left:0,
                          right:0,
                          child: pw.Center(child: pw.Image(pw.MemoryImage(middleborder),width: 140),),
                        ),

                        pw.Positioned(
                          right:70,
                          top:40,
                          child:pw.Container(
                            width:700,
                            height:270,
                            child: pw.Image(hreview),
                          ),
                        ),

                        pw.Positioned(
                          left:20,
                          top:50,
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: 120,
                                  height:120,
                                  // height:100,
                                  child: pw.Image(profilepic),
                                  decoration: pw.BoxDecoration(

                                   border: pw.Border.all(color:PdfColors.blueGrey,width: 10),
                                  ),
                                ),
                                pw.SizedBox(height:10),
                                pw.Text(
                                    '${review.rank!} ${review.name!}',
                                    style:   pw.TextStyle(fontWeight:pw.FontWeight.bold,color: PdfColors.white,fontSize: 10.0)),
                                pw.Text(
                                    '${review.appointment!} ${review.address!}',
                                    style:   pw.TextStyle(fontWeight:pw.FontWeight.bold,color: PdfColors.white,fontSize: 8.0)),
                                pw.SizedBox(height:10),
                                pw.Padding(
                                  padding:pw.EdgeInsets.all(3.0),
                                  child: pw.Container(
                                    decoration: pw.BoxDecoration(
                                      image:pw.DecorationImage(image: pw.MemoryImage(certback),fit: pw.BoxFit.cover),
                                      borderRadius:  pw.BorderRadius.circular(10.0),
                                    ),
                                    width: 120,
                                    // height:100,
                                    child: pw.Image(signature),
                                  ),
                                ),


                              ]
                          ),
                        ),

                      ]
                  ),
                ),


pw.Container(
  child:  pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [

        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(

                child: pw.Text(
                    "ALWAYS AHEAD",
                    style:   pw.TextStyle(fontWeight:pw.FontWeight.bold,fontSize: 10,color: PdfColors.white)),
              ),
            ]
        ),





      ]
  ),
),




              ]
          ),

        ); }));
  await requestStoragePermissions();
  await savePdf(review.type,review.name);
  setState(() {
    _isCreating=false;
  });
}
catch(e){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Something Went Wrong'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );


// print(e.toString());
  setState(() {
    _isCreating=false;
  });
}


  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return TextButton( onPressed: () async {
await generateCertificate();

  },child:_isCreating? const Text('Creating.....'):const Text('Certificate'),);
  }


}