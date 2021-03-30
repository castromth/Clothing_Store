import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_udemy/datas/product_data.dart';

class CartProduct {

  String cid;
  String pid;
  String category;
  int quantity;
  String size;

  ProductData productData;

  CartProduct(this.productData);
  CartProduct.fromDocument(DocumentSnapshot doc){
    cid = doc.id;
    category = doc.data()["category"];
    pid = doc.data()["pid"];
    quantity = doc.data()["quantity"];
    size = doc.data()["size"];
  }

  Map<String, dynamic> toMap(){
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumeMap(),
    };
  }
}