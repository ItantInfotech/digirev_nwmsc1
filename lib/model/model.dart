import 'dart:convert';
import 'dart:typed_data';

import 'package:digirev_nwmsc/Objectbox.g.dart';
import 'package:digirev_nwmsc/main.dart';
import 'package:objectbox/objectbox.dart';

import '../ObjectBox.dart';

@Entity()
class Review {
  @Id()
  int id; // ObjectBox will handle auto-incrementing

  String? rank;
  String? name;
  Uint8List? profilePic;
  String? appointment;
  String? address;
  Uint8List? hReview;
  String? wReview;
  String? aReview;
  Uint8List? signature;
  String? type;
  String? date;
  String? status;
  String? client;

  Review({
    this.id = 0,
    this.rank,
    this.name,
    this.profilePic,
    this.appointment,
    this.address,
    this.hReview,
    this.wReview,
    this.aReview,
    this.signature,
    this.type,
    this.date,
    this.status,
    this.client,
  });

  // factory Review.fromJson(Map<String, dynamic> json) {
  //   return Review(
  //     rank: json['rank'] as String,
  //     name: json['name'] as String,
  //     profilePic: _decodeBase64(json['profilePic']),
  //     appointment: json['appointment'] as String,
  //     address: json['address'] as String,
  //     hReview: _decodeBase64(json['hReview']),
  //     wReview: json['wReview'] as String,
  //     aReview: json['aReview'] as String,
  //     signature: _decodeBase64(json['signature']),
  //     type: json['type'] as String,
  //     date: json['date'] as String,
  //     status: json['status'] as String,
  //     client: json['client'] as String,
  //
  //   );
  // }

  factory Review.fromJson(Map<String, dynamic> json) {
    // Assuming 'name' and 'hReview' together form a unique combination
    String name = json['name'] as String;
    String hReview = json['hReview'] as String;
  Uint8List? hReview1=_decodeBase64(hReview);
    // Check if a Review with the same name and hReview combination already exists
   Review? review= objectbox.ReviewBox.query(Review_.hReview.equals(hReview1!)).build().findFirst();




    // If an existing Review is found, return it instead of creating a new one
    if (review != null) {
      return review;
    }

    // If no existing Review is found, proceed with creating a new one
    return Review(
      rank: json['rank'] as String,
      name: name,
      profilePic: _decodeBase64(json['profilePic']),
      appointment: json['appointment'] as String,
      address: json['address'] as String,
      hReview: _decodeBase64(hReview),
      wReview: json['wReview'] as String,
      aReview: json['aReview'] as String,
      signature: _decodeBase64(json['signature']),
      type: json['type'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      client: json['client'] as String,
      // Add other properties...
    );
  }




  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rank': rank,
      'profilePic': _encodeBase64(profilePic),
      'appointment': appointment,
      'address': address,
      'hReview': _encodeBase64(hReview),
      'wReview': 'NG',
      'aReview': 'NG',
      'signature': _encodeBase64(signature),
      'type': type,
      'date': date,
      'status': 'NG',
      'client': client,
    };
  }

  static String? _encodeBase64(Uint8List? data) {

     return data != null ? base64Encode(data) : null;
  }

  static Uint8List? _decodeBase64(dynamic data) {
    if (data is String) {
      print(base64Decode(data));
      return base64Decode(data);
      
    } else {
      return null; // Handle the case when it's a List<dynamic> or null
    }
  }
}

@Entity()
class Vip{
  @Id()
  int id;
  String? rank;
  String? name;
  Uint8List? profilepic;
  String? appointment;
  String? address;
  String? date;

  Vip({
    this.id=0,
    this.rank,
    this.name,
    this.address,
    this.appointment,
    this.profilepic,
    this.date
});


}
