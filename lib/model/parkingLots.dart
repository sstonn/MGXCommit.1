import 'package:firebase_database/firebase_database.dart';
class Lots {
  String key;
  String lotsName;
  String address;
  String userId;
  Lots(this.lotsName,this.userId, this.address);

  Lots.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId=snapshot.value["userId"],
        lotsName = snapshot.value["lotsName"],
        address = snapshot.value["address"];

  toJson() {
    return {
      "userId": userId,
      "lotsName": lotsName,
      "address": address,
    };
  }
}