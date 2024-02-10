import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AudioPlayerWidget.dart';
import 'CreateCertificate.dart';
import 'constants.dart';
import 'main.dart';
import 'model/model.dart';

class GuestReviews extends StatefulWidget{
  GuestReviewsState createState()=>GuestReviewsState();

}

class GuestReviewsState extends State<GuestReviews>{

  List<Review> reviews = [];

  @override
  void initState(){
    // TODO: implement initState

    super.initState();
     fetchReviews();
  }


 Future<void> fetchReviews() async {
    try {
      List<Review> fetchedReviews =  await objectbox.getReviews('guest');
      setState(() {
        reviews = fetchedReviews; // Update the state with fetched reviews
      });
    } catch (e) {
      // Handle errors here, if any

    }
  }
  confirmdelete(id){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Do you really want to delete ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deletereview(id);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  deletereview(id){
    objectbox.ReviewBox.remove(id);
    fetchReviews();
  }


  @override
  Widget build(BuildContext context) {

    List<DataRow> rows=[];


    for(var review in reviews){
      rows.add(
          DataRow(cells: [
            DataCell(Image.memory(review.profilePic!,width: 100,)),
            // DataCell(Image.file(File(review.profilePic!),width: 100)),
            DataCell(Text('${review.rank!}.${review.name!}\n${review.appointment!} ${review.address!}')),
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
                          child:Image.memory(review.hReview!,fit: BoxFit.contain,)

                        ),
                      );
                    },
                  );
                },
                child:Image.memory(review.hReview!,width: MediaQuery.of(context).size.width * 0.3,)

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
            DataCell(CreateCertificate(review)),
            DataCell(TextButton( onPressed: () async {
              confirmdelete(review.id);


            },child:const Text('Delete'),)),
          ])
      );
    }


    // TODO: implement build
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: const BoxDecoration(
          // border: BorderDirectional(bottom: BorderSide(color: Color(0X0ff000000),width: 20.0,style: BorderStyle.solid))
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Add your border styling here
                  ),
                  height:MediaQuery.of(context).size.height * 0.7,
                  child:   SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*1,

                      child: DataTable(
                          headingRowColor: MaterialStateProperty.all<Color>(Colors.white),
                          dataRowColor: MaterialStateProperty.all<Color>(Colors.white),
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
                            DataColumn(label:Text("Date")),
                            DataColumn(label:Text("Certificate")),
                            DataColumn(label:Text("Delete"))

                          ], rows: rows
                      ),
                    ),
                  ),
                ),







              ],
            ),
          ],
        ),
      ),
    );
  }

}