import 'package:digirev_nwmsc/Strip.dart';
import 'package:digirev_nwmsc/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Login extends StatefulWidget{
  LoginState createState()=>LoginState();
}
class LoginState extends State<Login>{

  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  
  login(){
    print(username.text);
    print(password.text);
    if(username.text=='nwmsc' && password.text=='nwmsc123#'){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard()));
    }else{
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text('Dialog Title'),
            content: Text('Username or Password is incorrect. Please try again!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

  }
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return Scaffold(
body: Container(
    width:MediaQuery.of(context).size.width*1,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(background), // Replace with your image asset
      fit: BoxFit.cover, // Adjust the fit as needed
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
       Image(image: AssetImage(logo),width: MediaQuery.of(context).size.height*0.4,height: 200,),
      Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.09,
              width:MediaQuery.of(context).size.width*0.25,

              child: TextField(
                controller: username,
                decoration: inputStyle('username*'),

              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.09,
              width:MediaQuery.of(context).size.width*0.25,

              child: TextField(
                obscureText: true,
                controller: password,
                decoration: inputStyle('Password*'),

              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.06,
              width:MediaQuery.of(context).size.width*0.25,
              child: ElevatedButton(
                onPressed: (){

login();
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
      ),
      Container(
        child: Strip(),
      ),
    ],
  ),
),
);
  }

}