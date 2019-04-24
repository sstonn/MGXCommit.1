import 'package:firebase_database/firebase_database.dart';
class Lots {
  String key;
  String lotsName;
  String address;
  String description;
  bool isSelected;
  String userId;
  Lots(this.lotsName,this.userId, this.address,this.description);

  Lots.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId=snapshot.value["userId"],
        lotsName = snapshot.value["lotsName"],
        address = snapshot.value["address"],
        description=snapshot.value["description"];

  toJson() {
    return {
      "userId": userId,
      "lotsName": lotsName,
      "address": address,
      "description": description,
    };
  }
}