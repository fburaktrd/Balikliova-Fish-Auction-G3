import 'package:firebase_database/firebase_database.dart';

import 'UserController.dart';
import 'package:myapp/models/database.dart';

class CoopHeadController {
  final ref = FirebaseDatabase.instance.ref();

  void changeBasePrice(int price) {
    ref
        .child("Live_Auction")
        .child("currentSeafood")
        .child("basePrice")
        .set(price);
  }

  void setCurrentFood(List<dynamic> food) async {
    var seafoodMap = {
      "id": food[0],
      "productName": food[1],
      "quantity": food[2],
      "basePrice": food[3],
      "soldPrice": 0
    };
    ref.child("Live_Auction").child("currentSeafood").set(seafoodMap);
  }

  void activateDeactivateButtons(bool isActive) {
    ref.child("Live_Auction").child("isButtonsActive").set(!(isActive));
  }

  void finaliseSoldPrice(double price, String productId) {
    ref
        .child("Live_Auction")
        .child("currentFood")
        .child("soldPrice")
        .set(price);
    ref
        .child("Live_Auction")
        .child("seafoodProducts")
        .child(productId)
        .child("soldPrice")
        .set(price);
    
  }

  void finishLiveAuction(Map auctionInfo) {
    auctionInfo.remove("currentSeafood");
    ref.child("Auction").child(auctionInfo["id"]).set(auctionInfo);

    ref.child("Live_Auction").remove();
  }
}
