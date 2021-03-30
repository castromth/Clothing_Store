import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/datas/cart_product.dart';
import 'package:loja_udemy/datas/product_data.dart';
import 'package:loja_udemy/models/cart_model.dart';
import 'package:loja_udemy/models/user_model.dart';
import 'package:loja_udemy/ui/cart_screen.dart';
import 'package:loja_udemy/ui/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData productData;

  ProductScreen(this.productData);

  @override
  _ProductScreenState createState() => _ProductScreenState(productData);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String size;

  _ProductScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                images: product.images.map((url) => NetworkImage(url)).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16.0),
                Text("Tamanho",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                SizedBox(
                    height: 34.0,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                      ),
                      children: product.sizes
                          .map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    size = e;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    border: Border.all(
                                        color: e == size
                                            ? primaryColor
                                            : Colors.grey[500],
                                        width: 2.0),
                                  ),
                                  width: 50.0,
                                  alignment: Alignment.center,
                                  child: Text(e),
                                ),
                              ))
                          .toList(),
                    )),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct p = new CartProduct(product);
                              p.size = size;
                              p.quantity = 1;
                              p.pid = product.id;
                              p.category = product.category;
                              CartModel.of(context).addCartItem(p);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar no carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Descriçao",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Text(product.title, style: TextStyle(fontSize: 16.0))
              ],
            ),
          )
        ],
      ),
    );
  }
}
