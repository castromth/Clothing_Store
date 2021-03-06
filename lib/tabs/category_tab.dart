import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_udemy/tiles/category_tile.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context,snapshot) {
        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else{
          var divideTiles = ListTile
              .divideTiles(
              tiles: snapshot.data.docs.map((doc) =>
                  CategoryTile(doc)).toList(), color: Colors.grey[500]).toList();
          return ListView(
            children: divideTiles,
          );
        }
      },
    );
  }
}
