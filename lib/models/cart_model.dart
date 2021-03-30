import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_udemy/datas/cart_product.dart';
import 'package:loja_udemy/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  List<CartProduct> products = [];
  String couponCode;
  int discountPercentage = 0;
  UserModel user;
  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItems();
    }
  }
  bool isLoading = false;
  
  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);
  
  void addCartItem(CartProduct product){
    products.add(product);
    
    FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").add(product.toMap())
        .then((value) => product.cid = value.id);

    notifyListeners();
  }
  
  void removeCartItem(CartProduct product){
    FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").doc(product.cid).delete();

    products.remove(product);
    notifyListeners();
  }

  void decProduct(CartProduct product){
    product.quantity--;
    FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").doc(product.cid).update(product.toMap());
    notifyListeners();
  }
  void incProduct(CartProduct product){
    product.quantity++;
    FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").doc(product.cid).update(product.toMap());
    notifyListeners();
  }

  void _loadCartItems() async{
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
      return price;
    }
  }
  double getProductsDiscount(){

    return getProductsPrice() * discountPercentage / 100;
  }
  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String> finishOrder() async{
    if(products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double price = getProductsPrice();
    double discount = getProductsDiscount();
    double ship = getShipPrice();
    
    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user.user.uid,
      "products": products.map((e) => e.toMap()).toList(),
      "shipPrice": ship,
      "productsPrice": price,
      "discountPrice":discount,
      "totalPrice": price+ship-discount,
      "status": 1
    });
    await FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("orders").doc(refOrder.id).set({
      "id": refOrder
    });

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.user.uid).collection("cart").get();

    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }
    products.clear();
    discount = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();


    return refOrder.id;

  }


}