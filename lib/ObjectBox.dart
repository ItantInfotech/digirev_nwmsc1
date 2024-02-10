import 'dart:ffi';

import 'package:intl/intl.dart';


import 'Objectbox.g.dart';

import 'model/model.dart';

class ObjectBox{
  late final Store store;
  late final Box<Review> ReviewBox;
  late final Box<Vip> VipBox;

  ObjectBox._create(this.store){
ReviewBox=Box<Review>(store);
VipBox=Box<Vip>(store);
  }

  static Future<ObjectBox> create() async{

    final store=await openStore();
    return ObjectBox._create(store);
  }

closeStore(){
    store.close();
}

    Future<bool> addReview(Review review) async{
      try{
    if(review.name !=null && review.rank !=null && review.hReview != null && review.signature !=null){
ReviewBox.put(review);
     return true;
    }else{
    return false;
    }

      }catch(e){
    return false;
      }


      }

      Future<bool> addVip(Vip vip) async{
    try{

      if(vip.name !=null && vip.rank !=null && vip.appointment != null && vip.address !=null && vip.profilepic!=null){

     VipBox.put(vip);


        return true;


      }else{
        return false;
      }
    }catch(e){

      return false;
        }
      }

    // Future<void> showReviews(List<Review> reviews) async{
    //     for(var review in reviews){
    //       print('name:${review.name},profile:${review.profilePic},review:${review.hReview},signature:${review.signature},audio:${review.aReview},date:${review.date},');
    //     }
    // }

  // Future<void> showVips(List<Vip> vips) async{
  //   for(var vip in vips){
  //     print('name:${vip.name},profile:${vip.profilepic},review:${vip.rank},signature:${vip.appointment},date:${vip.date},');
  //   }
  // }


  bool check(){
    final query=ReviewBox.query(Review_.name.equals('Vipul Shinghal')).build();
    final review=query.find();
    if(review.isEmpty){
      return true;
    }else{
      return false;
    }



  }
List<Review> getTodayReview(String type){
    print('working');
  final date=DateTime.now();
  String formattedDate=DateFormat('dd-MM-yyyy').format(date);

  final query=ReviewBox.query(Review_.type.equals(type).and(Review_.date.equals(formattedDate))).build();
  final reviews=query.find();
  print(formattedDate);
  query.close();
  showReviews(reviews);
  return reviews;
}
showReviews(List<Review> reviews){
  for (Review review in reviews) {
  print(review.name!+'\n');
  }
}

  List<Review> getReviews(String type) {

    final query= ReviewBox.query(Review_.type.equals(type)).order(Review_.id,flags: Order.descending).build();
    final reviews=query.find();
    query.close();
    return reviews;

  }


List<Vip> getVipsForReviews(){
    final date=DateTime.now();
  String formattedDate=DateFormat('dd-MM-yyyy').format(date);
    final query=VipBox.query(Vip_.date.equals(formattedDate)).build();
    final vips= query.find();
    query.close();

    return vips;
  }


  List<Review> getReviewsByDate(String start,String end,String type){
   final query=ReviewBox.query(
       Review_.date.greaterOrEqual(start).and(Review_.date.lessOrEqual(end).and(Review_.type.equals(type)))

   ).build();
   final reviews=query.find();
   query.close();
   // showReviews(reviews);
   return reviews;
  }



    List<Review> getlatest()  {
      final query = ReviewBox.query()
        ..order(Review_.id, flags: Order.descending);
      final reviews = query.build().find().take(7).toList();

      // showReviews(reviews);
      return reviews;
    }
    Future<void> deleteAllData() async{
        try{
          ReviewBox.removeAll();

        }catch(e){

        }
    }

}