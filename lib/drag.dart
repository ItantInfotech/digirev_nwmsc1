// import 'dart:io';
// import 'dart:typed_data';
// import 'package:digi_rev/ThankYou.dart';
// import 'package:digi_rev/main.dart';
// import 'package:path_provider/path_provider.dart' as path;
// import 'package:digi_rev/model/model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_drawing_board/flutter_drawing_board.dart';
// import 'package:flutter_drawing_board/paint_contents.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:record/record.dart';
//
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//
// import 'constants.dart';
//
//
// class drag extends StatefulWidget{
//   // const drag({super.key});
//
//   @override
//   _dragstate createState()=>_dragstate();
// }
//
//
//
//
// class _dragstate extends State<drag> {
//
//   late DrawingController reviewController;
//   late DrawingController signatureController;
//   late AudioRecorder record;
//   double _leftColumnWidth = 0.2; // Initial width of left column
//   bool _expanded = false; // Tracks if the 30% column is expanded
//   XFile? _image;
//
//
//   final TextEditingController nameController=TextEditingController();
//   final TextEditingController rankController=TextEditingController();
//   final TextEditingController appointmentController=TextEditingController();
//   final TextEditingController addressController= TextEditingController();
//
//   bool _showLeftColumn=true;
//   bool _isRecording=false;
//   String? recordPath;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     reviewController= DrawingController();
//     signatureController=  DrawingController();
//     reviewController.setPaintContent(SimpleLine());
//     reviewController.setStyle(strokeWidth: 2);
//     signatureController.setStyle(strokeWidth: 2);
//     signatureController.setStyle(strokeWidth: 2,color: Colors.black);
//     reviewController.setStyle(strokeWidth: 2,color: Colors.black);
//     // record=AudioRecorder();
//
//     super.initState();
//   }
//
//   // Variable Declaration
//
//
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     nameController.dispose();
//     rankController.dispose();
//     appointmentController.dispose();
//     addressController.dispose();
//     reviewController.dispose();
//     signatureController.dispose();
//     record.dispose();
//
//   }
//
//
//
//
//   double assignWidth(){
//     final width=MediaQuery.of(context).size.width * (1 - _leftColumnWidth);
//     return width;
//   }
//
//   Future<void> startRecording() async {
//     record=AudioRecorder();
//     setState(() {
//       _isRecording=true;
//     });
//     try{
//       if(await record.hasPermission()){
//
//         Directory dir=await path.getApplicationDocumentsDirectory();
//         final fileName=DateTime.now().millisecondsSinceEpoch.toString();
//         recordPath='${dir.path}/$fileName.wav';
//         await record.start(const RecordConfig(encoder: AudioEncoder.wav), path: recordPath!);
//
//
//       }
//     }catch(e){
//       // print('Error starting:{$e}');
//     }
//   }
//
//   Future<void> stopRecording() async{
//     setState(() {
//       _isRecording=false;
//     });
//     try{
//       // final path=
//       await record.stop();
//       // print(path);
//     }
//     catch(e){
//       // print('Error saving:{$e}');
//     }
//
//     // record.dispose();
//   }
//
//
//   Future<void> getImage() async{
//     final picker=ImagePicker();
//     String? imageError;
//     try{
//       final pickedImage=await picker.pickImage(source:ImageSource.camera);
//       setState(() {
//         if(pickedImage!=null){
//           _image=XFile(pickedImage.path);
//           imageError=null;
//         }else{
//           imageError="No Image Selected, Please try again!!";
//           // print(_imageError);
//         }
//       });
//     }catch(e){
//       setState(() {
//         imageError="Error Picking Image: $e";
//       });
//     }
//   }
//
//   Future<String> saveDrawing(DrawingController type) async{
//     // print(type);
//     String saveError="";
//     try{
//
//       final byteData=await type.getImageData();
//
//       if(byteData!=null){
//         final filepath=createFilePath();
//         final buffer=byteData.buffer.asUint8List();
//         String path= await saveByteImage(await filepath, buffer);
//         // print(path);
//         return path;
//       }else{
//         saveError='No image selected';
//
//         return saveError;
//       }
//
//     }catch(e){
//       saveError='Something went wrong.Error saving the picture. Please try again!!';
//       return saveError;
//     }
//   }
//
//   Future<String> saveProfile(XFile path) async{
//     if(path.path.length>0){
//       final filepath=await createFilePath();
//       await File(_image!.path).copy(filepath);
//       // print('Saving profile pic...');
//       return filepath;
//     }else{
//       return "Error Saving Profile picture";
//     }
//
//   }
//
//   Future<String> createFilePath() async{
//     Directory appdir= await path.getApplicationDocumentsDirectory();
//     final fileName=DateTime.now().millisecondsSinceEpoch.toString();
//     final filePath='${appdir.path}/$fileName.png';
//     return filePath;
//   }
//
//   Future<String> saveByteImage(String path,Uint8List buffer) async{
//     try{
//       await File(path).writeAsBytes(buffer);
//       // print("Saving Drawing....");
//       return path;
//     }catch(e){
//       return "Something went wrong";
//     }
//   }
//
//
//
//
//   void submitData() async{
//    // print("Submitting Data....");
//     try{
//      // print("trying...");
//
//
//
//       final hreview=await saveDrawing(reviewController);
//
//       final signature=await saveDrawing(signatureController);
//       final profilepic=await saveProfile(_image!);
//       DateTime now=DateTime.now();
//       String formattedDate=DateFormat('dd-MM-yyyy').format(now);
//
//
//       if(reviewController.currentIndex>=2 && signatureController.currentIndex>=1 && nameController.text!="" && profilepic.length!=0){
//         _toggleColumnWidth();
//         final review=Review(
//           rank:rankController.text,
//           name:nameController.text,
//           profilePic: profilepic,
//           signature: signature,
//           hReview: hreview,
//           aReview: recordPath,
//           address: addressController.text,
//           appointment: appointmentController.text,
//           type:"guest",
//           client:"nwmsc",
//           date: formattedDate,
//
//         );
//         // print(review.date);
//         objectbox.addReview(review);
//         if(await objectbox.addReview(review)){
//           Navigator.pop(context);
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>ThankYou()));
//         }else{
//
//         }
//       }else{
//         var showError="Please fill in all the information required";
//         showAlert(context, "Incomplete Information", showError);
//       }
//
//     }catch(e){
//       showAlert(context, "Application Error", e.toString()+"\n"+"Please check if you have filled all the information including profile pic");
//      // print(e);
//     }
//   }
//
//
//
//   void _toggleColumnWidth() {
//     setState(() {
//       // Toggle between normal and expanded state for the 30% column
//
//       // _leftColumnWidth=0.01;
//
//
//       if (!_expanded) {
//         _showLeftColumn=!_showLeftColumn;
//         _leftColumnWidth = 0.02; // Width to show only the button
//         _expanded = true;
//
//       } else {
//         _showLeftColumn=true;
//         _leftColumnWidth = 0.2; // Width to show the button and content
//         _expanded = false;
//
//       }
//     });
//   }
//
//   void lineMode(Color? color){
//     try{
//       setState(() {
//         reviewController.clear();
//         signatureController.clear();
//         reviewController.setPaintContent(SimpleLine());
//         reviewController.setStyle(strokeWidth: 3,color: color);
//         signatureController.setPaintContent(SimpleLine());
//         signatureController.setStyle(strokeWidth: 3,color:color);
//       });
//     }catch(e){
//       // print(e.toString());
//     }
//
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(background), // Replace with your image asset
//             fit: BoxFit.cover, // Adjust the fit as needed
//           ),
//         ),
//         child: Stack(
//           children: [
//
//
//
//
//             // LPW
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 0), // Animation duration
//               curve: Curves.easeInOut,
//               left: _showLeftColumn ? 0 : -MediaQuery.of(context).size.width * 0.2,
//               top: 0,
//               bottom: 0,
//               width: MediaQuery.of(context).size.width * _leftColumnWidth,
//               child:Padding(
//                 padding: const EdgeInsets.fromLTRB(30.0, 30.0, 10.0, 30.0),
//                 child:   Column(
//
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Expanded(
//
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//
//                         children: [
//
//
//
//                           const Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//
//
//
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//
//                             children: [
//                               const Image(image: AssetImage(logo),width: 200,height: 200,),
//
//                               GestureDetector(
//                                 onTap: () {
//                                   getImage();
//                                 },
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width * _leftColumnWidth, // Adjust as needed
//                                   height: 200, // Adjust as needed
//                                   decoration: BoxDecoration(
//                                     color:const Color.fromARGB(189, 189, 189, 189),
//                                     border: Border.all(),
//                                     // borderRadius: BorderRadius.circular(10.0),
//                                     image: _image != null
//                                         ? DecorationImage(
//                                       image: FileImage(File(_image!.path)),
//                                       fit: BoxFit.cover,
//                                     )
//                                         : null,
//                                   ),
//                                   child: _image == null
//                                       ? Center(
//                                     child: Container(
//                                       color: const Color.fromARGB(189, 189, 189, 189),
//                                       child:const Text('Tap to take a photo'),
//                                     ),
//                                   )
//                                       : null,
//                                 ),
//                               )
//                             ],
//                           ),
//
//                           TextField(
//
//                             controller: rankController,
//                             decoration: inputStyle('Rank*'),
//                             textCapitalization: TextCapitalization.sentences,
//                           ),
//                           TextField(
//                             controller: nameController,
//                             decoration: inputStyle('Name*'),
//                             textCapitalization: TextCapitalization.sentences,
//                           ),
//                           TextField(
//                             controller: appointmentController,
//                             decoration: inputStyle('Appointment*'),
//                             textCapitalization: TextCapitalization.sentences,
//                           ),
//                           TextField(
//                             controller: addressController,
//                             decoration: inputStyle('Address*'),
//                             textCapitalization: TextCapitalization.sentences,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//             ),
// //RP Widget
//
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 0), // Animation duration
//               curve: Curves.easeInOut,
//               right:0,
//               top: 0,
//               bottom: 0,
//               width: assignWidth(),
//               child:Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 30.0),
//
//                 child:SizedBox(
//                   width: assignWidth(),
//                   // color: Colors.black,
//
//
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//
//
//
//                         Container(
//                           height:MediaQuery.of(context).size.height*0.75,
//                           width:assignWidth(),
//                           decoration: BoxDecoration(
//                             color:const Color.fromARGB(189, 189, 189, 189),
//                             border: Border.all(),
//
//                           ),
//                           child: DrawingBoard(
//                             boardPanEnabled: false,
//                             boardScaleEnabled: false,
//
//                             controller:reviewController,
//                             background: SizedBox(
//                                 // color:const Color.fromARGB(189, 189, 189, 189),
//                                 height:MediaQuery.of(context).size.height*0.75,
//                                 width:assignWidth()),
//                             // showDefaultActions:true,
//                             showDefaultTools: false,
//                            showDefaultActions: false,
//
//                           ) ,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                           children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//
//                                   Container(
//
//                                     color: Colors.black,
//
//                                     child:  IconButton(onPressed: (){
//                                       _toggleColumnWidth();
//                                     },
//                                       icon: _showLeftColumn? const Icon(Icons.arrow_back, color: Colors.white):const Icon(Icons.arrow_forward, color: Colors.white),),
//                                   ),
//
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child: IconButton(
//                                       onPressed: (){
//                                         reviewController.setPaintContent(SimpleLine());
//                                         reviewController.setStyle(strokeWidth: 2);
//                                         signatureController.setPaintContent(SimpleLine());
//                                         signatureController.setStyle(strokeWidth: 2);
//
//                                         reviewController.setStyle(color: Colors.red);
//                                       signatureController.setStyle(color: Colors.red);
//                                       }, icon: const Icon(Icons.square,color: Colors.red,),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child:  IconButton(
//                                       onPressed: (){
//                                         reviewController.setPaintContent(SimpleLine());
//                                         reviewController.setStyle(strokeWidth: 2);
//                                         signatureController.setPaintContent(SimpleLine());
//                                         signatureController.setStyle(strokeWidth: 2);
//                                         reviewController.setStyle(color: Colors.green);
//                                         signatureController.setStyle(color: Colors.green);
//                                       }, icon: const Icon(Icons.square,color: Colors.green,),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child:  IconButton(
//                                       onPressed: (){
//                                         reviewController.setPaintContent(SimpleLine());
//                                         reviewController.setStyle(strokeWidth: 2);
//                                         signatureController.setPaintContent(SimpleLine());
//                                         signatureController.setStyle(strokeWidth: 2);
//                                         reviewController.setStyle(color: Colors.black);
//                                         signatureController.setStyle(color: Colors.black);
//                                       }, icon: const Icon(Icons.square,color: Colors.black,),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child:  IconButton(
//                                       onPressed: (){
//                                         reviewController.setPaintContent(SimpleLine());
//                                         reviewController.setStyle(strokeWidth: 2);
//                                         signatureController.setPaintContent(SimpleLine());
//                                         signatureController.setStyle(strokeWidth: 2);
//                                         reviewController.setStyle(color: Colors.blue);
//                                         signatureController.setStyle(color: Colors.blue);
//                                       }, icon: const Icon(Icons.square,color: Colors.blue,),
//                                     ),
//                                   ),
//
//
//
//
//
//
//
//                                 ],
//                               ),
//                               Row(
//
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child:
//                                     IconButton(
//                                       onPressed: (){
//                                         reviewController.setPaintContent(Eraser(color: const Color.fromARGB(1000, 189, 189, 189)));
//
//                                         reviewController.setStyle(strokeWidth: 25);
//                                         signatureController.setPaintContent(Eraser(color: const Color.fromARGB(1000, 189, 189, 189)));
//                                         signatureController.setStyle(strokeWidth: 25);
//                                       },  icon:const FaIcon(FontAwesomeIcons.eraser,color: Colors.black,),
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//                                     child: IconButton(onPressed: () {
//                                       // Eraser(color: Color.fromARGB(1000, 189, 189, 189)).drawPath;
//                                       if(_isRecording){
//                                         stopRecording();
//                                       }else{
//                                         startRecording();
//                                       }
//                                     },
//                                       icon: _isRecording?const Icon(Icons.stop,color: Colors.red,):const Icon(Icons.mic,color: Colors.black,),
//
//
//                                     ),
//                                   ),
//                                   Container(
//                                     // color:Colors.black,
//                                     decoration: BoxDecoration(
//                                       color:Colors.blueGrey,
//                                       border: Border.all(),
//
//                                     ),
//
//                                     child: IconButton(onPressed: () {
//                                       reviewController.clear();
//                                       signatureController.clear();
//
//                                     }, icon: const Icon(Icons.delete_forever,color: Colors.black,),
//
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   height:MediaQuery.of(context).size.height*0.14,
//                                   width: MediaQuery.of(context).size.width*0.2,
//                                   decoration: BoxDecoration(
//                                     color:const Color.fromARGB(189, 189, 189, 189),
//                                     border: Border.all(),
//
//                                   ),
//
//                                   // color:Color.fromARGB(189, 189,189,189),
//                                   child: DrawingBoard(
//                                     boardPanEnabled: false,
//                                     boardScaleEnabled: false,
//                                     controller: signatureController,
//                                     background:SizedBox(
//                                       height:MediaQuery.of(context).size.height*0.14,
//                                       width: MediaQuery.of(context).size.width*0.2,
//
//
//                                     ),
//                                     showDefaultActions:false,
//                                     showDefaultTools: false,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height:MediaQuery.of(context).size.height*0.14,
//                                   width: MediaQuery.of(context).size.width*0.15,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         height:MediaQuery.of(context).size.height*0.14,
//
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//                                           children: [
//
//                                             ElevatedButton(
//                                               onPressed: (){
//                                                 // dialog();
//                                                 submitData();
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:Colors.green,
//                                                 foregroundColor: Colors.white,
//                                               ),
//                                               child: const Text("Submit Review"),
//                                             )
//                                           ],
//                                         ),
//
//
//                                       ),
//                                     ],
//                                   ),
//
//                                 ),
//
//                                 Image(image: AssetImage(digirevlogo),width:120),
//
//                               ],
//                             ),
//
//
//
//
//
//
//
//                           ],
//                         ),
//                       ]
//                   ),
//                 ),
//
//               ),
//
//
//
//             ),
//
//
//
//           ],
//         ),
//
//       ),
//     );
//   }
// }
