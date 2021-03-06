import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/models/database.dart';

class AuctionController {
  final ref = FirebaseDatabase.instance.ref();

  String getTimeStampId() {
    final now = DateTime.now();
    final id =
        now.microsecondsSinceEpoch.toString(); //Generating unique table id.
    return id;
  }

  Future<dynamic> getCurrentAuctionTableAsList() async {
    var res = await ref.child("Live_Auction").child("seafoodProducts").get();
    Map<String, int> mapKeysAsIndex = {
      "id": 0,
      "productName": 1,
      "quantity": 2,
      "basePrice": 3,
      "soldPrice": 4
    };
    var returnedList = [];
    var list = (res.value as List).getRange(1, (res.value as List).length);
    list.forEach((element) {
      returnedList.add([
        element["id"],
        element["productName"],
        element["quantity"],
        element["basePrice"],
        element["soldPrice"]
      ]);
    });
    print(returnedList);
    return returnedList;
  }

  DatabaseReference getAuctions() {
    return ref.child("Auctions");
  }

  void listenLiveAuction({VoidCallback? listenAuction}) {
    ref.child("Live_Auction").onValue.listen((event) {
      listenAuction!();
    });
  }

  Future<dynamic> getLiveAuction() async {
    var res = (await ref.child("Live_Auction").get());
    if (res.value != null) {
      var resMap = res.value as Map;
      var updatedSeafoods = {};
      var listSea = (resMap["seafoodProducts"] as List);
      listSea.getRange(1, listSea.length).forEach((element) {
        updatedSeafoods[element["id"].toString()] = element;
        if (element["id"] == resMap["currentSeafood"]["id"]) {
          try {
            resMap["bids"] = element["bids"];
          } catch (e) {
            print(e);
          }
        }
      });

      resMap["seafoodProducts"] = updatedSeafoods;

      var currentSeafood = resMap["currentSeafood"];
      resMap["currentSeafood"] = [
        currentSeafood["id"],
        currentSeafood["productName"],
        currentSeafood["quantity"],
        currentSeafood["basePrice"],
        currentSeafood["soldPrice"]
      ];
      try {
        resMap["usersCount"] = resMap["users"].length;
      } catch (e) {
        resMap["usersCount"] = 0;
      }
      resMap["seafoodProducts"] = await getCurrentAuctionTableAsList();
      //resMap["users"] = resMap["users"].length;
      return resMap;
    }
    return {};
  }

  Future<bool> startAuction(String coopHeadId) async {
    var res = await ref.child("Published_Auction_Table").get();
    var resMap = res.value as Map;

    var updatedSeafoods = {};

    var listSea = (resMap[resMap.keys.elementAt(0)]["seafoodProducts"] as List);
    listSea.getRange(1, listSea.length).forEach((element) {
      updatedSeafoods[element["id"].toString()] = element;
    });

    resMap[resMap.keys.elementAt(0)]["seafoodProducts"] = updatedSeafoods;
    if (res.value != null) {
      var publishedAuctionTables = (res.value as Map);
      String id = getTimeStampId();
      ref.child("Live_Auction").set({
        "id": id,
        "isButtonsActive": false,
        "auctionTableid": publishedAuctionTables["id"],
        "coopHead": coopHeadId,
        "createdTime": id,
        "seafoodProducts": updatedSeafoods,
        "currentSeafood": listSea[1]
      });
      return true;
    }
    return false;
  }

  void deleteAuction(auctionID) {
    FirebaseDatabase.instance.ref().child("Auctions").child(auctionID).remove();
  }

  DatabaseReference getUsersInAuction(auctionID) {
    return ref.child("Auctions").child(auctionID).child("Users");
  }

  DatabaseReference getUserInAuction(userID, auctionID) {
    return ref.child("Auctions").child(auctionID).child("Users").child(userID);
  }
}
