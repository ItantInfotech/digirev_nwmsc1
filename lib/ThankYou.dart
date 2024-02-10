// import 'dart:html';
import 'dart:io';
import 'package:digirev_nwmsc/Strip.dart';
import 'package:flutter/material.dart';

import 'package:digirev_nwmsc/main.dart';
import 'package:digirev_nwmsc/constants.dart';
import 'package:digirev_nwmsc/AudioPlayerWidget.dart';


class ThankYou extends StatefulWidget{
 _thankyouState createState()=>_thankyouState();
}

class _thankyouState extends State<ThankYou>{
// late AudioPlayer player;
// late bool _isPlaying;

@override
  void initState() {
    // TODO: implement initState
  // player=AudioPlayer();
  // _isPlaying=false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // player.dispose();
  }

  // void play(String path){
  // setState(() {
  //   _isPlaying=true;
  // });
  // Source url=UrlSource(path);
  // player.play(url);
  // }
  //
  // void stop(){
  // setState(() {
  //   _isPlaying=false;
  // });
  // player.stop();
  // }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows=[];
    final reviews=objectbox.getlatest();

    for(var review in reviews){
      rows.add(
        DataRow(cells: [
          DataCell(Image.memory(review.profilePic!,width: 100,)),
          // DataCell(Image.file(File(review.profilePic!),width: 100)),
          DataCell(Text(review.rank!+'.'+review.name!+'\n'+review.appointment!+' '+review.address!)),
          DataCell(
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, // Make sure to pass the context here
                  builder: (BuildContext context) {
                    return Dialog(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child:Image.memory(review.hReview!,fit: BoxFit.contain, )

                      ),
                    );
                  },
                );
              },
              child:Image.memory(review.hReview!,width:MediaQuery.of(context).size.width * 0.3,)

            ),
          ),
          DataCell(
            review.aReview != null
                ? AudioPlayerWidget(audioPath: review.aReview!)
                : Text('Not Given'),
          ),
          DataCell(Image.memory(review.signature!,width: MediaQuery.of(context).size.width * 0.1)),
          // DataCell(Image.file(File(review.signature!),width: MediaQuery.of(context).size.width * 0.1,)),
          DataCell(Text(review.date!)),
        ])
      );
    }

    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background), // Replace with your image asset
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
child: Row(
children: [
  Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:[
      SizedBox(height: 1,),
      Image(image: AssetImage(logo),width: 200,),
      Container(
        height: 400,
        child:   SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width*1,

            child: DataTable(
                headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(189, 189, 189, 189)),
                dataRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(189, 189, 189, 189)),
                dataRowMaxHeight:120,
                border: TableBorder.all(width: 1.0, color: Colors.black),
                // TableBorder.all({Color color = const Color(0xFF000000), double width = 1.0, BorderStyle style = BorderStyle.solid, BorderRadius borderRadius = BorderRadius.zero}),
                columnSpacing: 8,
                columns: const[
                  DataColumn(label: Text("Profile")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Review")),
                  DataColumn(label: Text("Audio")),
                  DataColumn(label:Text("Signature")),
                  DataColumn(label:Text("Date"))

                ], rows: rows
            ),
          ),
        ),
      ),
Container(
  child: Center(
   child: Text('THANK YOU',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
  ),
),
Container(child: Container(
  child: Strip(),
))





    ],
  ),
],
),
      ),
    );
  }
}


