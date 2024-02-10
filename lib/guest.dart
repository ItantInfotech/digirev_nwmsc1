
import 'dart:io';

import 'package:digirev_nwmsc/Strip.dart';
import 'package:digirev_nwmsc/constants.dart';

import 'package:digirev_nwmsc/login.dart';




import 'dart:async';


import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';


import 'package:permission_handler/permission_handler.dart';

import 'GuestRev.dart';


class Guest extends StatefulWidget {
  @override
  _Guest createState() => _Guest();
}

class _Guest extends State<Guest> {
  // late review;
  @override
  void initState(){
    // TODO: implement initState



    requestPermissions();
    // loadLocalImages();

    super.initState();
  }
  List<String> imagePaths = [];
  // ... rest of the code remains the same
  Future<void> loadLocalImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDir.path}/images'); // Replace with your image folder name

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

  Future<void> requestPermissions() async {


    PermissionStatus microphoneStatus = await Permission.microphone.request();
    print('Microphone permission status: $microphoneStatus');

    // Request storage permission
    PermissionStatus storageStatus = await Permission.storage.request();
    print('Storage permission status: $storageStatus');
  }


  List<Shadow> shade(){
    return  [
      Shadow(
        color: Colors.black,
        offset: Offset(3, 1),
        blurRadius: 0,
      ),
    ];
  }











  @override
  Widget build(BuildContext context) {
    Container(
      child:Image(image: const AssetImage(logo),width:MediaQuery.of(context).size.width*0.1),
    );
    return Container(

      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(background),fit: BoxFit.cover)
      ),
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.transparent,

        body:Container(

          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,



            children: [
              //
              // Positioned(
              //   bottom:0,
              //   child:  Container(
              //     alignment: Alignment.topCenter,
              //     child: Row(
              //       children:_buildImageWidgets(),
              //     ),
              //   ),
              //
              //
              //
              // ),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text('ADMIN',style:TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize:14,
                    color:Colors.white,
                    backgroundColor: Colors.red,
                  )),
                  onPressed: (){
                    //copyAssetFileToLocal();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login())
                    );

                  },
                ),
              ),

              Align(
                alignment: Alignment.topCenter,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height:30),
                    Container(
                      child: Image(image: const AssetImage(logo),width:MediaQuery.of(context).size.width*0.2),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.1,),
                    Container(
                      // width: MediaQuery.of(context).size.width*1,

                      child:Text(
                        "Thank You for visiting our esteemed premises."
                        ,style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                        fontSize: MediaQuery.of(context).size.height*0.035,

                      ),textAlign: TextAlign.center,),
                    ),

                    Container(
                      // width: MediaQuery.of(context).size.width*1,
                      child:Text(
                        "We have taken immense hardship in nurturing every corner of the place"
                        ,style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: shade(),
                        fontSize: MediaQuery.of(context).size.height*0.035,

                      ),textAlign: TextAlign.center,),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width*1,
                      child:Text(
                        "Thus making it worth your valuable time."
                        ,style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: shade(),
                        fontSize: MediaQuery.of(context).size.height*0.035,

                      ),textAlign: TextAlign.center,),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width*1,
                      child:Text(
                        "Your feedback is valuable to us."
                        ,style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: shade(),
                        fontSize: MediaQuery.of(context).size.height*0.035,

                      ),textAlign: TextAlign.center,),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width*1,
                      child:Text(
                        "To give your feedback, please -"

                        ,style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: shade(),
                        fontSize: MediaQuery.of(context).size.height*0.035,

                      ),textAlign: TextAlign.center,),
                    ),
                    SizedBox(height:50),
                    Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor: MaterialStateProperty.all(Colors.white),

                        ),
                        child: Text('CLICK HERE',style:TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize:MediaQuery.of(context).size.height*0.04,
                          color:Colors.white,
                          // backgroundColor: Colors.red,
                        )),
                        onPressed: (){
                          //copyAssetFileToLocal();
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const GuestRev()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => CreateReviewPage())
                          // );

                        },
                      ),
                    ),

                  ],
                ),

              ),



              // Positioned(
              //   top: MediaQuery.of(context).size.height*0.22,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Container(
              //           // width: MediaQuery.of(context).size.width*1,
              //           child:Text(
              //               "For us to show you the best, your feedback is very valuable, if you wish to give your feedback, Please"
              //           ),
              //         ),
              //
              //       ],
              //     ),
              //    )








Container(
  alignment: Alignment.bottomCenter,
  child: Strip(),
)
            ],
          ),
        ),

      ),
    );

  }



  // List<Widget> _buildImageWidgets() {
  //   final List<Widget> imageWidgets = [];
  //
  //   for (int i = 0; i < imagePaths.length; i++) {
  //     // if (i > 0) {
  //     //   // Add a spacing widget between images
  //     //   imageWidgets.add(SizedBox(width: 8.0));
  //     // }
  //
  //     imageWidgets.add(
  //       Image.file(
  //         File(imagePaths[i]),
  //         fit: BoxFit.contain,
  //         width: MediaQuery.of(context).size.width / 6, // Divide by the number of images in a row
  //       ),
  //     );
  //   }
  //
  //   return imageWidgets;
  // }



}

