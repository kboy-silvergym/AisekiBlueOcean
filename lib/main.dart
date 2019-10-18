import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: '相席ラウンジ集計'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ShopList(),
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

class Shop {
  Shop.fromSnapshot(DocumentSnapshot document) {
    shopName = document['shop_name_en'] as String;
    man = document['man'] as String;
    woman = document['woman'] as String;
    timestamp = document['timestamp'] as Timestamp;
  }
  String shopName;
  String man;
  String woman;
  Timestamp timestamp;

  double manRate() {
    final int intMan = int.tryParse(man) ?? 0;
    final int intWoman = int.tryParse(woman) ?? 0;

    if (intWoman == 0) {
      return 1000.0;
    }
    return (intMan / intWoman).toDouble();
  }
}
