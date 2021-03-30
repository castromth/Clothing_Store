import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/tiles/place_tile.dart';

class LojasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else{
          return ListView(
            children: snapshot.data.docs.map((e) => PlaceTile(e)).toList(),
          );
        }
      },
    );
  }
}
