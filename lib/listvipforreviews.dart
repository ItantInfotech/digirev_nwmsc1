
import 'dart:io';

import 'package:digirev_nwmsc/Strip.dart';
import 'package:digirev_nwmsc/VipReview.dart';


import 'package:flutter/material.dart';
import 'package:digirev_nwmsc/main.dart';
import 'VipReviewNew.dart';
import 'constants.dart';
import 'model/model.dart';
import 'model/model.dart';

class ListVipForReviews extends StatefulWidget{
  
  ListVipForReviewsState createState()=>ListVipForReviewsState();
  
}

class ListVipForReviewsState extends State<ListVipForReviews>{
  List<Vip> vips=[];

  @override
  void initState(){
    // TODO: implement initState

    super.initState();
    fetchVips();
  }

Future<void> fetchVips() async{
  try {
    List<Vip> fetchedReviews =  await objectbox.getVipsForReviews();
    setState(() {
      vips = fetchedReviews; // Update the state with fetched reviews
    });
  } catch (e) {
    // Handle errors here, if any

  }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background), // Replace with your image asset
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:10),
              Image(image: const AssetImage(logo),width: MediaQuery.of(context).size.width*0.2,),
              Padding(padding: EdgeInsets.all(10),
              child:  Container(

                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.5,
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
             Container(
               child:ElevatedButton(

                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.green),
                     foregroundColor: MaterialStateProperty.all(Colors.white),
                     minimumSize: MaterialStateProperty.all(Size(100, 50)),
                   ),
                   onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>VipReviewNew()));
                   },

                   child: const Text("Proceed >>",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
             ),
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
  
}