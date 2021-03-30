import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/models/cart_model.dart';
import 'package:loja_udemy/models/user_model.dart';
import 'package:loja_udemy/tiles/cart_tile.dart';
import 'package:loja_udemy/ui/login_screen.dart';
import 'package:loja_udemy/ui/order_screen.dart';
import 'package:loja_udemy/widgets/cart_price.dart';
import 'package:loja_udemy/widgets/discount_card.dart';
import 'package:loja_udemy/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int n = model.products.length;
                return Text(
                  "${n ?? 0} ${n == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Faça o login para adiconar produtos!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  )
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto no carinho",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((e) => CartTile(e)).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if(orderId != null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OrderScreen(orderId)));
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
