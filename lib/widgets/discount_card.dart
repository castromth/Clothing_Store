import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/models/cart_model.dart';
import 'package:loja_udemy/widgets/uppercase_text_formatter.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupom",),
              inputFormatters: [UpperCaseTextFormatter()],
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("coupons")
                    .doc(text)
                    .get()
                    .then((value) {
                  if (value.data() != null) {
                    CartModel.of(context).setCoupon(text, value.data()["percent"]);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Desconto de ${value.data()["percent"]}% aplicado"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    CartModel.of(context).setCoupon(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Cupom nao existente"),
                      backgroundColor: Colors.redAccent,
                    ));

                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
