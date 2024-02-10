

import 'package:flutter/material.dart';



const String logo = 'assets/logo4.png';
const String background="assets/background.jpg";
const String armylogo="assets/armylogo.png";
const String armylogo1="assets/armylogo1.png";
const String uname="21corps";
const String Password="21corps123#";
const String digirevlogo="assets/digirevlogo1.png";




InputDecoration inputStyle(String name){
  return InputDecoration(
    labelText: name,
    fillColor: Color.fromARGB(189, 189, 189, 189),
    filled: true,
  );
}

void showAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,style: const TextStyle(color: Colors.red),),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the alert
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

