import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/database.dart';

class AuctionTableController {
  var db = Database();

  void addProductToTable(String auctionTableID, String productID) {
    db.ref.child("AuctionTables").child(auctionTableID).child("Products");
  }

  void deleteProductFromTable(String auctionTableID, String productID) {
    db.ref
        .child("AuctionTables")
        .child(auctionTableID)
        .child("Products")
        .child(productID)
        .remove();
  }

  DatabaseReference getTables() {
    return db.ref.child("AuctionTables");
  }

  DatabaseReference getTable(String tableID) {
    return db.ref.child("AuctionTables").child(tableID);
  }

  AuctionTable addAuctionTable(Map<String,Map<String,dynamic>> auct_table) {
    int rowNo = 0;
    List<String> rowIds = [];
    List<String> products = [];
    List<int> basePrices = [];
    List<int> quantities = [];
    List<int> soldPrices = [];
    

    for (int i = 0; i < auct_table.length; i++) {
      rowIds.add(rowNo.toString());
      products.add(auct_table[rowNo.toString()]!["name"]);
      basePrices.add(auct_table[rowNo.toString()]!["basePrice"]);
      quantities.add(auct_table[rowNo.toString()]!["quantity"]);
      products.add(auct_table[rowNo.toString()]!["name"]);
      soldPrices.add(0);
      rowNo++;
    }

    AuctionTable table = AuctionTable(uid, //rastgele bir id mi gelecek?
                                      products: products, 
                                      basePrices: basePrices, 
                                      quantities: quantities, 
                                      soldPrices: soldPrices, 
                                      rowID: rowIds);
    return table;
    
  }

  void deleteAuctionTable(String auctionTableID) {
    db.ref.child("AuctionTables").child(auctionTableID).remove();
  }
}
