import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/database.dart';

class AuctionTableController {
  final ref = FirebaseDatabase.instance.ref();

  String getTimeStampId() {
    final now = DateTime.now();
    final id =
        now.microsecondsSinceEpoch.toString(); //Generating unique table id.
    return id;
  }

  void publishTable(String auctionTableId) async {
    await ref.child("Published_Auction_Table").remove();
    var res = await getTable(auctionTableId);
    var updatedSeafoods = {};
    ((res["seafoodProducts"] as List)
            .getRange(1, res["seafoodProducts"].length))
        .forEach((element) {
      updatedSeafoods[element["id"].toString()] = element;
    });
    res["seafoodProducts"] = updatedSeafoods;
    res["isPublished"] = true;
    ref.child("Published_Auction_Table").child(auctionTableId).set(res);
    ref
        .child("Auction_Table")
        .child(auctionTableId)
        .child("isPublished")
        .set(true);
  }

  void addProductToTableDb(String auctionTableID, List<dynamic> productInfo) {
    ref
        .child("Auction_Table")
        .child(auctionTableID)
        .child("seafoodProducts")
        .child(productInfo[0].toString())
        .set({
      "id": productInfo[0],
      "productName": productInfo[1],
      "quantity": productInfo[2],
      "basePrice": productInfo[3],
      "soldPrice": 0
    });
  }

  void updateProductToTableDb(
      String auctionTableId, String rowNo, List<dynamic> productInfo) {
    ref
        .child("Auction_Table")
        .child(auctionTableId)
        .child("seafoodProducts")
        .child(rowNo)
        .set({
      "id": productInfo[0],
      "productName": productInfo[1],
      "quantity": productInfo[2],
      "basePrice": productInfo[3],
      "soldPrice": 0
    });
  }

  void deleteProductFromTable(String auctionTableID, String productRowNo) {
    ref
        .child("Auction_Table")
        .child(auctionTableID)
        .child("seafoodProducts")
        .child(productRowNo)
        .remove();
  }

  Future<List<AuctionTable>> getTables(String userRole) async {
    String path =
        userRole == "CUSTOMER" ? "Published_Auction_Table" : "Auction_Table";
    print(userRole);
    List<AuctionTable> auctionTables = [];
    Map<String, int> mapKeysAsIndex = {
      "id": 0,
      "productName": 1,
      "quantity": 2,
      "basePrice": 3,
      "soldPrice": 4
    };

    var res = await ref.child(path).get();

    var resMap = (res.value as Map<String, dynamic>);
    for (var key in resMap.keys) {
      List<List<dynamic>> seafoodsAsList = [];
      var seafoods = resMap[key]["seafoodProducts"];

      for (var seafood in seafoods.getRange(1, seafoods.length)) {
        List<dynamic> seafoodAsList = [0, 0, 0, 0, 0];
        for (var seaKey in seafood.keys) {
          //print("${seaKey} --> ${mapKeysAsIndex[seaKey]}");
          seafoodAsList[(mapKeysAsIndex[seaKey]!)] = seafood[seaKey];
        }

        seafoodsAsList.add(seafoodAsList);
        //print(seafoodsAsList);
      }

      var auctionTable = AuctionTable(
          coopHeadId: resMap[key]["CoopHeadId"],
          seafoodProducts: seafoodsAsList,
          id: resMap[key]["id"]);
      auctionTables.add(auctionTable);
    }
    // for (var table in auctionTables) {
    //   print(table.seafoodProducts);
    // }
    return auctionTables;
  }

  Future<dynamic> getTable(String tableID) async {
    return ((await ref.child("Auction_Table").child(tableID).get()).value
        as Map<String, dynamic>);
  }

  void addAuctionTable(List<List<dynamic>> products, String uid) {
    final List<String> keys = [
      "id",
      "productName",
      "quantity",
      "basePrice",
      "soldPrice"
    ];
    String id = getTimeStampId();

    Map<String, Map<String, dynamic>> seafoodProducts = {};
    for (var i = 0; i < products.length; i++) {
      seafoodProducts[(i + 1).toString()] = {};
      for (var j = 0; j < products[i].length; j++) {
        seafoodProducts[(i + 1).toString()]![keys[j]] = products[i][j];
      }
    }
    Map<String, dynamic> auctionTable = {
      "id": id,
      "isPublished": false,
      "seafoodProducts": seafoodProducts,
      "createdTime": id,
      "CoopHeadId": uid
    };
    FirebaseDatabase.instance
        .ref()
        .child("Auction_Table")
        .child(id)
        .set(auctionTable);
  }

  void deletePublishedAuctionTable(String auctionTableID) {
    ref.child("Published_Auction_Table").child(auctionTableID).set({});
  }
}
