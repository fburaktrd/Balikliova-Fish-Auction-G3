import 'package:firebase_database/firebase_database.dart';

class CustomerController {
  final ref = FirebaseDatabase.instance.ref();

  void makeBid(String customerId, String customerUsername, double amount,
      String seafoodId) {
    ref.child("Live_Auction").child("seafoodProducts").child(seafoodId).child("bids").child(getTimeStampId()).set({
      "custId": customerId,
      "username": customerUsername,
      "seafoodId": seafoodId,
      "amount": amount
    });
  }

  void joinAuction(String customerId, String username) {
    ref
        .child("Live_Auction")
        .child("users")
        .child(customerId)
        .set({"username": username});
  }

  void leaveAuction(String customerId) {
    ref.child("Live_Auction").child("users").child(customerId).set({});
  }

  String getTimeStampId() {
    final now = DateTime.now();
    final id =
        now.microsecondsSinceEpoch.toString(); //Generating unique table id.
    return id;
  }
}
