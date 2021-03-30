import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String title;
  String marca;

  double price;

  List images;
  List sizes;

  String category;


  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.id;
    title = snapshot.data()["title"];
    marca = snapshot.data()["marca"];
    price = snapshot.data()["price"] + 0.0;
    images = snapshot.data()["images"];
    sizes = snapshot.data()["sizes"];

  }


  Map<String, dynamic> toResumeMap() {
    return {
      "title": title,
      "marca": marca,
      "price": price
    };
  }
}