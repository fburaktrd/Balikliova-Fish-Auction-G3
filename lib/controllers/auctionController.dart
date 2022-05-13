import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/auction.dart';
import 'package:myapp/models/database.dart';

class AuctionController{
    var db = Database();

    DatabaseReference getAuctions(){
        return db.ref.child("Auctions");
    }

    DatabaseReference getAuction(auctionID){
        return db.ref.child("Auctions").child(auctionID);
    }

    Auction startAuction(){
        //devam edecek,tam da anlamadım
    }

    void deleteAuction(auctionID){
        FirebaseDatabase.instance.ref().child("Auctions").child(auctionID).remove();
    }


    DatabaseReference getUsersInAuction(auctionID){
        return db.ref.child("Auctions").child(auctionID).child("Users");
    }

    DatabaseReference getUserInAuction(userID,auctionID){
        return db.ref.child("Auctions").child(auctionID).child("Users").child(userID);
    }


}






