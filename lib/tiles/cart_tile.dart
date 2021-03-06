import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/datas/cart_product.dart';
import 'package:loja_udemy/datas/product_data.dart';
import 'package:loja_udemy/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct product;
  CartTile(this.product);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(product.productData.images[0], fit: BoxFit.cover,),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(product.productData.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0)),
                  Text("Tamanho: ${product.size}", style: TextStyle(fontWeight: FontWeight.w300)),
                  Text("R\$ ${product.productData.price.toStringAsFixed(2)}",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0,fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: product.quantity > 1 ? (){
                          CartModel.of(context).decProduct(product);
                        } : null,
                      ),
                      Text(product.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incProduct(product);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(product);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    };

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(product.category)
                  .collection("items")
                  .doc(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData = ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
