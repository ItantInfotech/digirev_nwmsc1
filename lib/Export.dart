import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:digirev_nwmsc/main.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;


import 'model/model.dart';

class Export extends StatefulWidget{
  ExportState createState()=>ExportState();
}

class ExportState extends State<Export>{

  TextEditingController startDateController= TextEditingController();
  TextEditingController endDateController= TextEditingController();
  String selectedValue = 'vip';
  List<String> dropdownItems = ['vip','guest'];
  List<Review> reviews=[];
  final pdf=pw.Document();
  final maxReviewsPerPage = 4;
  bool _isCreating=false;





  Future<pw.Widget> buildTable(List<Review> reviews) async{
    List<pw.TableRow> rows = [];
    final img = await rootBundle.load('assets/logo3.png');
    final logo = img.buffer.asUint8List();


    for(var review in reviews){

      final profilepic=pw.MemoryImage(review.profilePic!);
      final signature=pw.MemoryImage(review.signature!);
      final hreview=pw.MemoryImage(review.hReview!);
      // final profilepic=pw.MemoryImage(File(review.profilePic!).readAsBytesSync());
      // final signature=pw.MemoryImage(File(review.signature!).readAsBytesSync());
      // final hreview=pw.MemoryImage(File(review.hReview!).readAsBytesSync());

      rows.add(pw.TableRow(
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[pw.Container(width:70,height:70,child: pw.Image(profilepic)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
          pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[pw.Text('${review.rank!} ${review.name!}\n${review.appointment!} ${review.address!}'),],mainAxisAlignment: pw.MainAxisAlignment.center),),
          pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[ pw.Container(width:300,child: pw.Image(hreview)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
          pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[ pw.Container(width:100,child: pw.Image(signature)),],mainAxisAlignment: pw.MainAxisAlignment.center),),
          pw.Padding(padding: const pw.EdgeInsets.all(3.0),child: pw.Column(children:[   pw.Text(review.date!),],mainAxisAlignment: pw.MainAxisAlignment.center),)








        ],
      ));
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black),
      children: [
        // Header row
        pw.TableRow(
          children: [
            pw.Text('Profile', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Review', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Signature', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
        // Data rows



        ...rows,
        // Add more rows as needed
      ],
    );
  }




  Future<void> exportData() async {
    setState(() {
      _isCreating=true;
    });
    try {

      final startDate = startDateController.text;
      final endDate = endDateController.text;
      final img1 = await rootBundle.load('assets/digirevlogo.png');
      final img = await rootBundle.load('assets/logo3.png');
      final logo = img.buffer.asUint8List();
      final digirevlogo = img1.buffer.asUint8List();
      if (startDate != null && endDate != null) {
        reviews = objectbox.getReviewsByDate(startDate, endDate, selectedValue);


        for (var i = 0; i < reviews.length; i += maxReviewsPerPage) {
          final startIndex = i;
          final endIndex =
          (i + maxReviewsPerPage < reviews.length) ? i + maxReviewsPerPage : reviews.length;

          final table = await buildTable(reviews.sublist(startIndex, endIndex));

          pdf.addPage(
            pw.Page(
              margin: const pw.EdgeInsets.all(5.0),

              build: (pw.Context context) {
                return pw.Column(
                  //
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children:[
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 70,
                          child:pw.Image(pw.MemoryImage(logo)),
                        ),
                        // pw.Text('REVIEWS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ]
                    ),
                    table,
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 70,
                          child:pw.Image(pw.MemoryImage(digirevlogo)),
                        ),

                      ]
                    ),
                  ]
                );
              },
            ),
          );
        }

        await savePdf();
        startDateController.clear();
        endDateController.clear();
        setState(() {
          _isCreating=false;
        });
      } else {
        print('something is wrong');
        setState(() {
          _isCreating=false;
        });
        // Handle case where start or end date is null
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isCreating=false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // print(e.toString());

      // Handle any exceptions
    }
  }


  Future<void> savePdf() async{
    // final dir=await path.getExternalStorageDirectory();
    // print(dir?.path);
    // Directory appdir= await path.getApplicationDocumentsDirectory();
    final fileName='listofreviews${DateTime.now().millisecondsSinceEpoch}';

    final filePath='/storage/emulated/0/Download/$fileName.pdf';
    // print(filePath);
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: SizedBox(
        height: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child:TextField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Start Date",
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
                          startDateController.text=formattedDate.toString();
                        });
                      }else{
                        print("Not selected");
                      }
                    },
                    maxLines: 1,
                  ),
                ),

                SizedBox(
                  width: 300,
                  child:TextField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter End Date",
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
                          endDateController.text=formattedDate.toString();
                        });
                      }else{
                        print("Not selected");
                      }
                    },
                    maxLines: 1,
                  ),
                ),

                SizedBox(
                  width: 300,
                   child: DropdownButton<String>(

                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async{
                    await exportData();
                  },
                  child: _isCreating?const Text('Exporting Please Wait...'):Text('Export Reviews'),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

}