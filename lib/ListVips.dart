
import 'dart:io';
import 'package:digirev_nwmsc/Objectbox.g.dart';
import 'package:digirev_nwmsc/Strip.dart';
import 'package:digirev_nwmsc/VipReview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:digirev_nwmsc/main.dart';
import 'constants.dart';
import 'model/model.dart';
import 'model/model.dart';

class ListVips extends StatefulWidget{

  ListVipsState createState()=>ListVipsState();

}

class ListVipsState extends State<ListVips>{
  List<Vip> vips=[];

  @override
  void initState(){
    // TODO: implement initState

    super.initState();
    fetchVips();
  }

  Future<void> fetchVips() async{
    try {
      List<Vip> fetchedReviews =  await objectbox.VipBox.getAll();
      setState(() {
        vips = fetchedReviews; // Update the state with fetched reviews
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
                deletevip(id);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  deletevip(id){
   objectbox.VipBox.remove(id);
   fetchVips();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Container(

        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image(image: const AssetImage(logo),width: MediaQuery.of(context).size.width*0.2,),
              Padding(padding: const EdgeInsets.all(10),
                child:  Container(

                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // Number of columns
                      crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                    ),
                    itemCount: vips.length, // Total number of items in the grid
                    itemBuilder: (BuildContext context, int index) {
                      Vip vip = vips[index];
                      return GestureDetector(
                        onLongPress: (){
                          confirmdelete(vip.id);
                        },
                        onTap: (){
                          // print(vip.runtimeType);

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>VipReview(vip)));

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(189, 189, 189, 189),
                            border: Border.all(),
                            image: DecorationImage(
                              image:MemoryImage(vip.profilepic!),
                              // image: FileImage(File(vip.profilepic!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              Container(
                                color: Colors.green.withOpacity(0.8),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${vip.rank!} ${vip.name!}\n${vip.appointment!}, ${vip.address!}',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),


                            ],
                          ),
                        ),
                      );

                    },
                  ),
                ),),


            ],
          ),
        ),
      ),




    );


  }

}