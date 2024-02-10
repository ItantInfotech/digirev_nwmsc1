import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:digirev_nwmsc/constants.dart';
import 'package:intl/intl.dart';
import 'package:digirev_nwmsc/main.dart';

import 'model/model.dart';

class CreateVip extends StatefulWidget{

  CreateVipState createState()=> CreateVipState();
}


class CreateVipState extends State<CreateVip>{

  XFile? _image;
  String? _imageError;
  TextEditingController nameController= TextEditingController();
  TextEditingController rankController=TextEditingController();
  TextEditingController appointmentController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController dateController=TextEditingController();



  Future<void> getImage() async{
    final picker=ImagePicker();
    try{
      final pickedImage=await picker.pickImage(source:ImageSource.gallery);
      setState(() {
        if(pickedImage!=null){
          _image=XFile(pickedImage.path);
          _imageError=null;
        }else{
          _imageError="No Image Selected, Please try again!!";

        }
      });
    }catch(e){
      setState(() {
        _imageError="Error Picking Image: $e";
      });
    }
  }



  Future<Uint8List?> saveProfile(XFile path) async{
    if(path.path.length>0){
      final filepath=await createFilePath();
      // await File(_image!.path).copy(await filepath);
      final profilepic=await File(_image!.path).readAsBytes();
      print('Saving profile pic...');
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


  Future<void> addVip() async{

    try{
      final name=nameController.text;
      final rank=rankController.text;
      final address=addressController.text;
      final appointment=appointmentController.text;
      final date=dateController.text;
      final profilepic=await saveProfile(_image!);
      final vip=Vip(
          name: name,
          rank: rank,
          address: address,
          appointment: appointment,
          date: date,
          profilepic: profilepic
      );
      print(vip.name);
      print(vip.rank);
      print(vip.profilepic);
      print(vip.address);
      print(vip.appointment);
      print(vip.date);
      if(await objectbox.addVip(vip)){
        nameController.clear();
        rankController.clear();
        addressController.clear();
        appointmentController.clear();
        dateController.clear();
        setState(() {
          _image=null;
        });
        // Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateVip()));
        return showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            content: Text("VIP added Succesfully"),
          );
        });
        print('Vip Added Successfully');


      }else{
        print('Something Went Wrong. Please try again');
      }

    }catch(e){
print(e.toString());
    }



    }


  Widget build(BuildContext context){
    return Scaffold(
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Take Photo from gallery

                Padding(padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    width: 200, // Adjust as needed
                    height: 200, // Adjust as needed
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
                ),
                ),

                Padding(padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.09,
                      width:MediaQuery.of(context).size.width*0.25,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          // icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date",
                          // labelText:'Appointment',

                          fillColor: const Color.fromARGB(189, 189, 189, 189),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async{
                          DateTime? pickedDate=await showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if(pickedDate!=null){
                            String formattedDate=DateFormat("dd-MM-yyyy").format(pickedDate);

                            setState(() {
                              dateController.text=formattedDate.toString();
                            });
                          }else{
                            print("Not selected");
                          }
                        },
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.09,
                      width:MediaQuery.of(context).size.width*0.25,

                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: rankController,
                        decoration: inputStyle('Rank*'),

                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.09,
                      width:MediaQuery.of(context).size.width*0.25,

                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: nameController,
                        decoration: inputStyle('Name*'),

                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(

                      height: MediaQuery.of(context).size.height*0.09,
                      width:MediaQuery.of(context).size.width*0.25,

                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: appointmentController,
                        decoration: inputStyle('Appointment*'),

                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.09,
                      width:MediaQuery.of(context).size.width*0.25,

                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: addressController,
                        decoration: inputStyle('Address*'),

                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.06,
                      width:MediaQuery.of(context).size.width*0.25,
                      child: ElevatedButton(
                        onPressed: (){
                          addVip();

                        },
                        child: Text("Submit"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
                )





              ],
            ),
          ],
        ),
      ),
    );
  }


}


