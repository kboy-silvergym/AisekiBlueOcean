import 'package:cloud_firestore/cloud_firestore.dart';

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
