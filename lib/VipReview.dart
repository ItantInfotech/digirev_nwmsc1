
import 'dart:io';
import 'dart:typed_data';
import 'package:digirev_nwmsc/ThankYou.dart';

import 'package:digirev_nwmsc/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:digirev_nwmsc/model/model.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';

import 'constants.dart';


class VipReview extends StatefulWidget{

  final Vip vip;
  const VipReview(this.vip);
  @override
  VipReviewState createState()=>VipReviewState(vip);
}




class VipReviewState extends State<VipReview> {
  final GlobalKey<State> testkey = GlobalKey();
  final GlobalKey<State> testkey1= GlobalKey();

  final PainterController testController=PainterController();

  final PainterController testController1=PainterController();
  late AudioRecorder record;
  final Vip vip;
  VipReviewState(this.vip);
  // final DrawingController _reviewController=DrawingController();
  // final DrawingController _signatureController=DrawingController();
  double _leftColumnWidth = 0.2; // Initial width of left columnp-dr  =
  bool _expanded = false; // Tracks if the 30% column is expanded
  XFile? _image;


  final TextEditingController nameController=TextEditingController();
  final TextEditingController rankController=TextEditingController();
  final TextEditingController appointmentController=TextEditingController();
  final TextEditingController addressController= TextEditingController();

  bool _showLeftColumn=true;
  bool _isRecording=false;
  String? recordPath;


  @override
  void initState() {
    print(vip.profilepic);
    // print(_image!.path);
    // TODO: implement initState
    testController.backgroundColor=Color.fromARGB(0, 189, 189, 189);
    testController1.backgroundColor=Color.fromARGB(0, 189, 189, 189);
    testController.thickness=3;
    testController1.thickness=3;


    // _signatureController.setStyle(strokeWidth: 2,color: Colors.red);
    // _reviewController.setStyle(strokeWidth: 2,color: Colors.red);
    // record=AudioRecorder();
    nameController.text=vip.name!;
    rankController.text=vip.rank!;
    appointmentController.text=vip.appointment!;
    addressController.text=vip.address!;


// nameController.text=vip.name;
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
    // _reviewController.dispose();
    // _signatureController.dispose();
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

  double assignWidth(){
    final width=MediaQuery.of(context).size.width * (1 - _leftColumnWidth);
    return width;
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


  Future<void> getImage() async{
    final picker=ImagePicker();
    String? _imageError;
    try{
      final pickedImage=await picker.pickImage(source:ImageSource.camera);
      setState(() {
        if(pickedImage!=null){
          _image=XFile(pickedImage.path);
          _imageError=null;
        }else{
          _imageError="No Image Selected, Please try again!!";
          // print(_imageError);
        }
      });
    }catch(e){
      setState(() {
        _imageError="Error Picking Image: $e";
      });
    }
  }

  Future<Uint8List?> saveNewDrawing(PainterController type) async{
    // String saveError="";
    try{
      var paint=type.finish();
      var buffer= await paint.toPNG();
      return buffer;

    }
    catch(e){
      // saveError='Something went wrong.Error saving the picture. Please try again!!';
      return null;
    }

  }


  Future<Uint8List?> saveProfile(XFile path) async{
    if(path.path.length>0){
      final filepath=await createFilePath();
      final profilepic=await File(_image!.path).readAsBytes();
      // await File(_image!.path).copy(await filepath);
      // print('Saving profile pic...');
      return profilepic;
    }else{
      // return "Error Saving Profile picture";
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


// print(isReviewEmpty);

      bool isComplete=!isReviewEmpty && !isSignatureEmpty;
      // print(isReviewEmpty);
      // print(isSignatureEmpty);
      // print(_image!=null);
      // print(isComplete);

      if(isComplete){

        final hreview=await saveNewDrawing(testController);

        final signature=await saveNewDrawing(testController1);

 final profilepic=vip.profilepic;

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



  }





  Future<void> _toggleColumnWidth() async{
    setState(() {
      // Toggle between normal and expanded state for the 30% column

      // _leftColumnWidth=0.01;


      if (!_expanded) {
        _showLeftColumn=!_showLeftColumn;
        _leftColumnWidth = 0.01; // Width to show only the button
        _expanded = true;
      } else {
        _showLeftColumn=true;
        _leftColumnWidth = 0.2; // Width to show the button and content
        _expanded = false;
      }
    });
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
                              // getImage();
                            },
                            child: Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              decoration: BoxDecoration(
                                color:const Color.fromARGB(189, 189, 189, 189),
                                border: Border.all(),
                                // borderRadius: BorderRadius.circular(10.0),
                                image:
                                DecorationImage(
                                  image:MemoryImage(vip.profilepic!),

                                  fit: BoxFit.cover,
                                )
                                ,
                              ),
                              child: _image == null
                                  ? Center(
                                child: Container(
                                  // color: const Color.fromARGB(189, 189, 189, 189),
                                  // child:const Text('Tap to take a photo'),
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