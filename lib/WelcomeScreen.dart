
  import 'dart:io';

  import 'package:digirev_nwmsc/Strip.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:digirev_nwmsc/guest.dart';
  import 'package:digirev_nwmsc/listvipforreviews.dart';
  import 'package:flutter/material.dart';
  import 'package:digirev_nwmsc/constants.dart';
  import 'package:path_provider/path_provider.dart';

  import 'login.dart';


  class WelcomeScreen extends StatefulWidget{

    @override
    _WelcomeScreenState createState()=>_WelcomeScreenState();

  }

  class _WelcomeScreenState extends State<WelcomeScreen>{



    @override
    void initState() {
      // TODO: implement initState
    // initializeStrip();

      super.initState();
      loadLocalImages();
    }

    List<String> imagePaths = [];
    // ... rest of the code remains the same
    Future<void> loadLocalImages() async {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        print(appDir.path);
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
    Widget build(BuildContext context){
      return Scaffold(

        body: Stack(
   children: [
     Container(
       decoration: const BoxDecoration(
         image: DecorationImage(
           image: AssetImage(background), // Replace with your image asset
           fit: BoxFit.cover, // Adjust the fit as needed
         ),
       ),
     ),

     Padding(
    padding : const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: const AssetImage(logo),width: MediaQuery.of(context).size.width*0.2,),
        ],
      ),
  ),
     const Positioned(
       top:250,
       right:0,
       left:0,
       child: Center(
         child: Text('DIGITAL VISITORS BOOK',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white, shadows: [
           Shadow(
             color: Colors.black,
             offset: Offset(2, 2),
             blurRadius: 4,
           ),
         ],)),
       ),
     ),

     Container(
       alignment: Alignment.center,
       child:   Row(
  mainAxisAlignment: MainAxisAlignment.center,
         children: [

           Padding(padding: const EdgeInsets.all(10.0),
           child:  ElevatedButton(

             style: ButtonStyle(
               backgroundColor: MaterialStateProperty.all(Colors.green),
               foregroundColor: MaterialStateProperty.all(Colors.white),
               minimumSize: MaterialStateProperty.all(Size(100, 50)),
             ),
               onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ListVipForReviews()));
           },

               child: const Text("Guests",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),

             ),

           Padding(padding: const EdgeInsets.all(10.0),
             child:  ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.green),
                   foregroundColor: MaterialStateProperty.all(Colors.white),
                   minimumSize: MaterialStateProperty.all(Size(100, 50)),
                 ),
                 onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>Guest()));
             }, child: const Text("Visitors",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
           ),
         ],
       ),
     ),





    Container(
         alignment: Alignment.bottomCenter,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children:_buildImageWidgets(),
         ),
       ),




     Container(
       alignment: Alignment.bottomRight,
       child: ElevatedButton(
         style: ButtonStyle(
           backgroundColor: MaterialStateProperty.all(Colors.red),
           foregroundColor: MaterialStateProperty.all(Colors.white),
         ),
         child: Text("Admin"),
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
         },
       ),

     ),
   ],

        ),

        //
        // body: Center(
        //   child: ElevatedButton(
        //     child: Text("Click Me"),
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=>drag()));
        //     },
        //   ),
        // ),
      );
    }
  }