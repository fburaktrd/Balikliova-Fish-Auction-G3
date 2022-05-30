import 'package:firebase_database/firebase_database.dart';
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

  DatabaseReference getTables() {
    return ref.child("AuctionTables");
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
    final id = now.microsecondsSinceEpoch.toString(); //Generating unique table id.
    
    Map<String, Map<String, dynamic>> seafoodProductIds = {};
    for (var i = 0; i < products.length; i++) {
      seafoodProductIds[(i+1).toString()] = {};
      for (var j = 0; j < products[i].length; j++) {  
        seafoodProductIds[(i+1).toString()]![keys[j]] = products[i][j];
      }
    }
    Map<String, dynamic> auctionTable = {"id":id,
    "isPublished":false,
    "seafoodProductIds":seafoodProductIds,
    "createdTime": id,
    "CoopHeadId":uid};
    FirebaseDatabase.instance.ref().child("Auction_Table").child(id).set(auctionTable);
  }
  

  void deleteAuctionTable(String auctionTableID) {
    ref.child("AuctionTables").child(auctionTableID).remove();
  }
}
