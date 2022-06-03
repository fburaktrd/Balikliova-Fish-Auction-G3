import 'package:firebase_database/firebase_database.dart';

class CustomerController {
  final ref = FirebaseDatabase.instance.ref();

  void makeBid(String customerId, String customerUsername, double amount,
      String seafoodId) {
    ref.child("Live_Auction").child("bids").push().set({
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
}
