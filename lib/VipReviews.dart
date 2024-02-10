import 'dart:io';

import 'package:flutter/material.dart';

import 'AudioPlayerWidget.dart';
import 'CreateCertificate.dart';

import 'main.dart';
import 'model/model.dart';

class VipReviews extends StatefulWidget {
  VipReviewsState createState() => VipReviewsState();
}

class VipReviewsState extends State<VipReviews> {
  List<Review> reviews = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      List<Review> fetchedReviews = await objectbox.getReviews('guest');
      setState(() {
        reviews = fetchedReviews; // Update the state with fetched reviews
      });
    } catch (e) {
      // Handle errors here, if any
    }
  }

  void deleteReview( index,int id) {

    setState(() {
      reviews.removeAt(index);
    });
    objectbox.ReviewBox.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: const BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Colors.black), // Add your border styling here
        ),
        child: SingleChildScrollView(

          child: PaginatedDataTable(

            columns: const [
              DataColumn(label: Text("Profile")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Review")),
              DataColumn(label: Text("Audio")),
              DataColumn(label: Text("Signature")),
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Certificate")),
              DataColumn(label: Text("Delete"))
            ],
            dataRowHeight: MediaQuery.of(context).size.height * 0.2,
            source: ReviewsDataSource(reviews, context, deleteReview), // Pass deleteReview
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: (int? value) {
              setState(() {
                _rowsPerPage = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}

class ReviewsDataSource extends DataTableSource {
  List<Review> _reviews;
  final BuildContext _context;
  final Function(int,int) _deleteReview; // Function to delete a review

  ReviewsDataSource(this._reviews, this._context, this._deleteReview);

  confirmdelete(int index,int id) {
    return showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Do you really want to delete?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deletereview(index,_reviews[index].id); // Delete the row
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deletereview(int index,id) {
    _deleteReview(index,id); // Call the provided delete function
  }

  @override
  DataRow getRow(int index) {
    final review = _reviews[index];
    return DataRow(
      cells: [
        DataCell(Image.memory(review.profilePic!,width: 50,)),

        DataCell(Text('${review.rank!}.${review.name!}\n${review.appointment!} ${review.address!}')),
        DataCell(
          GestureDetector(
            onTap: () {
              showDialog(
                context: _context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child:Image.memory(review.hReview!,fit: BoxFit.contain,),

                    ),
                  );
                },
              );
            },
            child:Image.memory(review.hReview!, width: MediaQuery.of(_context).size.width * 0.2,
    height: MediaQuery.of(_context).size.height * 0.2,)

          ),
        ),
        DataCell(
          review.aReview != null
              ? AudioPlayerWidget(audioPath: review.aReview!)
              : Text('Not Given'),
        ),
        DataCell(Image.memory(review.signature!,width: MediaQuery.of(_context).size.width * 0.1)),
        // DataCell(Image.file(File(review.signature!), width: MediaQuery.of(_context).size.width * 0.1)),
        DataCell(Text(review.date!)),
        DataCell(CreateCertificate(review)),
        DataCell(
          TextButton(
            onPressed: () async {
              confirmdelete(index,review.id); // Confirm deletion
            },
            child: const Text('Delete'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _reviews.length;

  @override
  int get selectedRowCount => 0;
}
