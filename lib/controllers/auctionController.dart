import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/database.dart';

class AuctionController {
  final ref = FirebaseDatabase.instance.ref();

  String getTimeStampId() {
    final now = DateTime.now();
    final id =
        now.microsecondsSinceEpoch.toString(); //Generating unique table id.
    return id;
  }

  DatabaseReference getAuctions() {
    return ref.child("Auctions");
  }

  DatabaseReference getAuction(auctionID) {
    return ref.child("Auctions").child(auctionID);
  }

  Future<bool> startAuction(String coopHeadId) async {
    var res = await ref.child("Published_Auction_Table").get();

    if (res.value != null) {
      var publishedAuctionTables = (res.value as Map);
      String id = getTimeStampId();
      ref.child("Live_Auction").set({
        "id": id,
        "isButtonsActive": false,
        "auctionTableid": publishedAuctionTables["id"],
        "coopHead": coopHeadId,
        "createdTime": id
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
