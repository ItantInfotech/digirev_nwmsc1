import 'dart:io';

import 'package:digirev_nwmsc/main.dart';
import 'package:flutter/material.dart';
import 'package:digirev_nwmsc/model/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digirev_nwmsc/constants.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:digirev_nwmsc/ObjectBox.dart';
import 'ObjectBox.dart';


class CreateReview extends StatefulWidget {

  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview>{

String name="";
String rank="";
String profilepic="";
TextEditingController nameController=TextEditingController();
TextEditingController rankController=TextEditingController();



Future<String> getProfilePic() async{
  Directory dir=  await path.getApplicationDocumentsDirectory();
  String profilepic= dir.path+'click2.png';
  return profilepic;
}

  getPhoto() async{
    final picker=ImagePicker();
    final XFile? pickedFile=await picker.pickImage(source: ImageSource.camera,maxWidth: 200,maxHeight:200,imageQuality: 30);
  setState(() {
    if(pickedFile!=null){
     // profilepic=pickedFile.path;
    }
  });
  }




    @override
    Widget build(BuildContext context){
      return Scaffold(
        body:Column(

          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height*0.5,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          TextField(
                            controller: rankController,
                            decoration: InputDecoration(
                              labelText: "Designation*",
                              fillColor: Colors.lightGreen,
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Designation*",
                              fillColor: Colors.lightGreen,
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Designation*",
                              fillColor: Colors.lightGreen,
                            ),
                          ),
                          ElevatedButton(onPressed: () async{

                            Review review=new Review();
                            review.name=nameController.text;
                            review.rank=rankController.text;

                        final result=await objectbox.addReview(review);




                          }, child: Text("Submit"))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(

                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Designation*",
                              fillColor: Colors.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    ),


                  )
                ],
              ),
            ),

          ],

        ),

      );
    }

  }

