import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/auction.dart';
import 'package:myapp/models/database.dart';


class AuctionTableController{

  var db = Database();

  void addProductToTable(String auctionTableID,String productID){

    db.ref.child("AuctionTables").child(auctionTableID).child("Products");

  }

  void deleteProductFromTable(String auctionTableID,String productID){

    db.ref.child("AuctionTables").child(auctionTableID).child("Products").child(productID).remove();

  }

  DatabaseReference getTables(){

    return db.ref.child("AuctionTables");

  }

  DatabaseReference getTable(String tableID){

    return db.ref.child("AuctionTables").child(tableID);

  }

  void addAuctionTable(){

    //devam edecek

  }

  void deleteAuctionTable(String auctionTableID){

    db.ref.child("AuctionTables").child(auctionTableID).remove();


  }


}