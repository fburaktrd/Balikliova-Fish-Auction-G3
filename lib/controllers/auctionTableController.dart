import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/database.dart';

class AuctionTableController {
  final ref = FirebaseDatabase.instance.ref();

  void addProductToTable(String auctionTableID, String productID) {
    ref.child("AuctionTables").child(auctionTableID).child("Products");
  }

  void deleteProductFromTable(String auctionTableID, String productID) {
    ref
        .child("AuctionTables")
        .child(auctionTableID)
        .child("Products")
        .child(productID)
        .remove();
  }

  Future<List<AuctionTable>> getTables() async {
    List<AuctionTable> auctionTables = [];
    Map<String, int> mapKeysAsIndex = {
      "id": 0,
      "productName": 1,
      "quantity": 2,
      "basePrice": 3,
      "soldPrice": 4
    };

    var res = await ref.child("Auction_Table").get();
    var resMap = (res.value as Map<String, dynamic>);
    for (var key in resMap.keys) {
      List<List<dynamic>> seafoodsAsList = [];
      var seafoods = resMap[key]["seafoodProducts"];
      List<dynamic> seafoodAsList = [0, 0, 0, 0, 0];
      for (var seafood in seafoods.getRange(1, seafoods.length)) {
        for (var seaKey in seafood.keys) {
          seafoodAsList[(mapKeysAsIndex[seaKey]!)] = seafood[seaKey];
        }
        // print(seafoodAsList);
        seafoodsAsList.add(seafoodAsList);
      }
      auctionTables.add(AuctionTable(
          coopHeadId: resMap[key]["CoopHeadId"],
          seafoodProducts: seafoodsAsList,
          id: resMap[key]["id"]));
    }
    
    return auctionTables;
  }

  DatabaseReference getTable(String tableID) {
    return ref.child("AuctionTables").child(tableID);
  }

  static void addAuctionTable(List<List<dynamic>> products, String uid) {
    final List<String> keys = [
      "id",
      "productName",
      "quantity",
      "basePrice",
      "soldPrice"
    ];
    final now = DateTime.now();
    final id =
        now.microsecondsSinceEpoch.toString(); //Generating unique table id.

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

  void deleteAuctionTable(String auctionTableID) {
    ref.child("AuctionTables").child(auctionTableID).remove();
  }
}
