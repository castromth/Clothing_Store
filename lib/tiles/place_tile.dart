import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot place;

  PlaceTile(this.place);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              place.data()["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(place.data()["title"],
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Text(
                  place.data()["anddress"],
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("Ver no mapa"),
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.zero,
                onPressed: (){
                  launch("https://www.google.com/maps/search/?api=1&query=${place.data()["lat"]},${place.data()["long"]}");
                },
              ),
              FlatButton(
                child: Text("Ligar"),
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.zero,
                onPressed: () {
                  launch("tel:${place.data()["phone"]}");
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
