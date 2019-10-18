import 'package:aiseki/shop.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '相席ラウンジ集計',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('相席ラウンジ集計'),
        ),
        body: ShopList(),
      ),
    );
  }
}

class ShopList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('shops').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading...');
          default:
            final shops =
                snapshot.data.documents.map((DocumentSnapshot document) {
              return Shop.fromSnapshot(document);
            }).toList();
            shops.sort((a, b) => a.manRate().compareTo(b.manRate()));

            return ListView(
              children: shops.map((Shop shop) {
                final man = shop.man;
                final woman = shop.woman;
                final subtitle = '男:$man人 女:$woman人';

                return ListTile(
                  title: Text(shop.shopName),
                  subtitle: Text(subtitle),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
