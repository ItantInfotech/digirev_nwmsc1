import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import 'ThankYou.dart';
import 'constants.dart';
import 'main.dart';
import 'model/model.dart';
import 'package:painter/painter.dart';

class VipReviewNew extends StatefulWidget{
  const VipReviewNew({Key? key}) : super(key: key);
  _VipReviewNew createState()=>_VipReviewNew();
}

class _VipReviewNew extends State<VipReviewNew>{
  //
  // final GlobalKey<State> reviewKey = GlobalKey();
  // final GlobalKey<State> signatureKey = GlobalKey();
  final GlobalKey<State> testkey = GlobalKey();
  final GlobalKey<State> testkey1= GlobalKey();

  final PainterController testController=PainterController();

  final PainterController testController1=PainterController();
  XFile? _image;

  bool _isRecording=false;
  String? recordPath;
  AudioRecorder record=AudioRecorder();

  final TextEditingController nameController=TextEditingController();
  final TextEditingController rankController=TextEditingController();
  final TextEditingController appointmentController=TextEditingController();
  final TextEditingController addressController= TextEditingController();

  @override
  void initState() {
    testController.backgroundColor=Color.fromARGB(0, 189, 189, 189);
    testController1.backgroundColor=Color.fromARGB(0, 189, 189, 189);
    testController.thickness=3;
    testController1.thickness=3;
    // TODO: implement initState

    // _reviewController.setPaintContent(SmoothLine(brushPrecision: 0.5));
    //
    // _signatureController.setStyle(strokeWidth: 2,color: Colors.black);
    // _reviewController.setStyle(strokeWidth: 4,color: Colors.black);
    // record=AudioRecorder();

    super.initState();
  }

  // Variable Declaration




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    rankController.dispose();
    appointmentController.dispose();
    addressController.dispose();
    testController.dispose();
    testController1.dispose();
    // record.dispose();

  }

  Future dialog(){
    return  showDialog(context: context,
      builder:(BuildContext context)=>Dialog(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child:SizedBox(
            width:300,
            height: 200,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You are going to submit the review!'),
                const Text('Are you sure?'),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:MaterialStateProperty.all(Colors.green),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        submitData();
                        Navigator.pop(context);
                      },
                      child: const Text('Submit'),)
                  ],
                ),

              ],
            ),
          ),


        ),
      ),
    );
  }
  Future<void> getImage() async{
    final picker=ImagePicker();
    String? imageError;
    try{
      final pickedImage=await picker.pickImage(source:ImageSource.camera);
      setState(() {
        if(pickedImage!=null){
          _image=XFile(pickedImage.path);
          imageError=null;
        }else{
          imageError="No Image Selected, Please try again!!";
          // print(_imageError);
        }
      });
    }catch(e){
      setState(() {
        imageError="Error Picking Image: $e";
      });
    }
  }

  Future<Uint8List?> saveNewDrawing(PainterController type) async{
    String saveError="";
    try{
      var paint=type.finish();
      var buffer= await paint.toPNG();
      // final filepath=createFilePath();
      // String path=await saveByteImage(await filepath, buffer);
      return buffer;
    }
    catch(e){
      saveError='Something went wrong.Error saving the picture. Please try again!!';
      return null;
    }

  }



  Future<Uint8List?> saveProfile(XFile path) async{
    if(path.path.length>0){
      final filepath=await createFilePath();
      // await File(_image!.path).copy(filepath);
      final profilepic=File(_image!.path).readAsBytes();
      // print('Saving profile pic...');
      return profilepic;
    }else{
return null;

    }

  }

  Future<String> createFilePath() async{
    Directory appdir= await path.getApplicationDocumentsDirectory();
    final fileName=DateTime.now().millisecondsSinceEpoch.toString();
    final filePath='${appdir.path}/$fileName.png';
    return filePath;
  }

  Future<String> saveByteImage(String path,Uint8List buffer) async{
    try{
      await File(path).writeAsBytes(buffer);
      // print("Saving Drawing....");
      return path;
    }catch(e){
      return "Something went wrong";
    }
  }




  void submitData() async{
    try{
      bool isReviewEmpty=testController.isEmpty;
      bool isSignatureEmpty=testController1.isEmpty;




      bool isComplete=!isReviewEmpty && !isSignatureEmpty && _image !=null && !nameController.text.isEmpty;
      print(isComplete);

      if(isComplete){

        final hreview=await saveNewDrawing(testController);

        final signature=await saveNewDrawing(testController1);

        final profilepic=await saveProfile(_image!);

        DateTime now=DateTime.now();
        String formattedDate=DateFormat('dd-MM-yyyy').format(now);



        final review=Review(
          rank:rankController.text,
          name:nameController.text,
          profilePic: profilepic,
          signature: signature,
          hReview: hreview,
          aReview: recordPath,
          address: addressController.text,
          appointment: appointmentController.text,
          type:"guest",
          client:"nwmsc",
          date: formattedDate,

        );

        objectbox.addReview(review);
        if(await objectbox.addReview(review)){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ThankYou()));
        }else{

        }
      }else{
        print('not working');
        var showError="Please fill in all the information required";
        showAlert(context, "Incomplete Information", showError);
      }
    }catch(e){
      showAlert(context,"Application Error",e.toString());
    }





    // // }else{
    //   var showError="Please fill in all the information required";
    //   showAlert(context, "Incomplete Information", showError);
    // }


  }


  Future<void> startRecording() async {
    record=AudioRecorder();
    setState(() {
      _isRecording=true;
    });
    try{
      if(await record.hasPermission()){

        Directory dir=await path.getApplicationDocumentsDirectory();
        final fileName=DateTime.now().millisecondsSinceEpoch.toString();
        recordPath='${dir.path}/$fileName.wav';
        await record.start(const RecordConfig(encoder: AudioEncoder.wav), path: recordPath!);


      }
    }catch(e){
      // print('Error starting:{$e}');
    }
  }

  Future<void> stopRecording() async{
    setState(() {
      _isRecording=false;
    });
    try{
      // final path=
      await record.stop();
      // print(path);
    }
    catch(e){
      // print('Error saving:{$e}');
    }

    // record.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();




    return Scaffold(

      body:Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background), // Replace with your image asset
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
        child:Row(
          children: [
            Expanded(
              flex: 3,
              child:Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex:2,
                        child:LayoutBuilder(
                          builder: (BuildContext context,BoxConstraints constraints){
                            return Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child:  const Image(image: AssetImage(logo)),
                            );
                          },
                        )
                    ),
                    Expanded(
                      flex:3,
                      child: LayoutBuilder(
                        builder: (BuildContext context,BoxConstraints constraints){
                          return  GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              // width: MediaQuery.of(context).size.width * _leftColumnWidth, // Adjust as needed

                              width: constraints.maxWidth,
                              height: constraints.maxHeight,// Adjust as needed
                              decoration: BoxDecoration(
                                color:const Color.fromARGB(189, 189, 189, 189),
                                border: Border.all(),
                                // borderRadius: BorderRadius.circular(10.0),
                                image: _image != null
                                    ? DecorationImage(
                                  image: FileImage(File(_image!.path)),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: _image == null
                                  ? Center(
                                child: Container(
                                  color: const Color.fromARGB(189, 189, 189, 189),
                                  child:const Text('Tap to take a photo'),
                                ),
                              )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height:15),
                    Expanded(flex:1,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: TextField(


                            controller: rankController,
                            decoration: inputStyle('Rank*'),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        );
                      },

                      ),
                    ),
                    Expanded(flex:1,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: TextField(


                            controller: nameController,
                            decoration: inputStyle('Name*'),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        );
                      },

                      ),
                    ),
                    Expanded(flex:1,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: TextField(


                            controller: appointmentController
                            ,
                            decoration: inputStyle('Appointment*'),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        );
                      },

                      ),
                    ),
                    Expanded(flex:1,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: TextField(


                            controller: addressController,
                            decoration: inputStyle('Address*'),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        );
                      },

                      ),
                    ),
                  ],
                ),
              ),

            ),
            Expanded(
              flex:9,
              child:Padding(
                padding:EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: Column(
                    children: [
                      Expanded(
                        flex: 10,
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return  Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: const Color.fromARGB(189, 189, 189, 189),
                              ),
                              key:testkey,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,

                              child: Painter(



                                  testController
                              ),
                            );


                            // return DrawingBoard(
                            //   key: reviewKey,
                            //   boardPanEnabled: false,
                            //   boardScaleEnabled: false,
                            //   controller: _reviewController,
                            //   background: Container(
                            //     width: constraints.maxWidth,
                            //     height: constraints.maxHeight,
                            //     color: Color.fromARGB(189, 189, 189, 189),
                            //   ),
                            //   // showDefaultActions: true,
                            //   // showDefaultTools: true,
                            //
                            // );
                          },
                        ),
                      ),
                      const SizedBox(height:5),
                      Expanded(
                        flex:2,
                        child: Row(
                            children:[
                              Column(
                                children: [
                                  Container(
                                    // flex:4,
                                    alignment: Alignment.topLeft,
                                    height:50,
                                    child: Container(
                                      color: Colors.blueGrey,
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [


                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [


                                              IconButton(
                                                onPressed: (){
                                                  testController.thickness=3;
                                                  testController.eraseMode=false;
                                                  testController.drawColor=Colors.red;
                                                  testController1.thickness=3;
                                                  testController1.eraseMode=false;
                                                  testController1.drawColor=Colors.red;

                                                }, icon: const Icon(Icons.square,color: Colors.red,),


                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  testController.thickness=3;
                                                  testController.eraseMode=false;
                                                  testController.drawColor=Colors.green[900]!;
                                                  testController1.thickness=3;
                                                  testController1.eraseMode=false;
                                                  testController1.drawColor=Colors.green[900]!;

                                                }, icon: const Icon(Icons.square,color: Colors.green,),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  testController.thickness=3;
                                                  testController.eraseMode=false;
                                                  testController.drawColor=Colors.black;
                                                  testController1.thickness=3;
                                                  testController1.eraseMode=false;
                                                  testController1.drawColor=Colors.black;

                                                }, icon: const Icon(Icons.square,color: Colors.black,),
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  testController.thickness=3;
                                                  testController.eraseMode=false;
                                                  testController.drawColor=Colors.blue;
                                                  testController1.thickness=3;
                                                  testController1.eraseMode=false;
                                                  testController1.drawColor=Colors.blue;

                                                }, icon: const Icon(Icons.square,color: Colors.blue,),
                                              ),

                                              IconButton(
                                                onPressed: (){
                                                  testController.eraseMode=true;
                                                  testController.thickness=10;
                                                  testController1.eraseMode=true;
                                                  testController1.thickness=10;


                                                },  icon:const FaIcon(FontAwesomeIcons.eraser,color: Colors.black,),
                                              ),
                                              IconButton(onPressed: () {
                                                // Eraser(color: Color.fromARGB(1000, 189, 189, 189)).drawPath;
                                                if(_isRecording){
                                                  stopRecording();
                                                }else{
                                                  startRecording();
                                                }
                                              },
                                                icon: _isRecording?const Icon(Icons.stop,color: Colors.red,):const Icon(Icons.mic,color: Colors.black,),


                                              ),
                                              IconButton(onPressed: (

                                                  ) {
                                                testController.clear();
                                                testController1.clear();


                                              }, icon: const Icon(Icons.delete_forever,color: Colors.black,),

                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  testController.undo();
                                                  // testController1.undo();
                                                },
                                                icon: const Icon(Icons.undo,color: Colors.black,),
                                              ),






                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width:10),


                              Expanded(
                                flex: 3,
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return  Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      color: Color.fromARGB(189, 189, 189, 189),
                                      child: Painter(testController1),
                                    );

                                  },
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child:LayoutBuilder(
                                  builder: (BuildContext context,BoxConstraints constraints){
                                    return  Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child:Container(
                                        // color:Colors.green[800],

                                        child: ElevatedButton(

                                          onPressed: (){
                                            // dialog();
                                            submitData();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:Colors.green[800],
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text("Submit"),
                                        ),
                                      ),
                                    );

                                  },
                                ),

                              ),
                              Expanded(
                                flex:1,
                                child:LayoutBuilder(
                                  builder: (BuildContext context,BoxConstraints constraints){

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          // color: Colors.green[900],
                                          width: 100,
                                          height: constraints.maxHeight,
                                          child:const Image(image: AssetImage(digirevlogo)),
                                        )
                                      ],
                                    );

                                  },
                                ),


                              ),
                            ]

                        ),
                      ),
                    ]
                ),
              ),

            ),

          ],
        ),

      ),

    );
  }




}