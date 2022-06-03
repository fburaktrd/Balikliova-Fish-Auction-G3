import 'package:myapp/controllers/CustomerController.dart';
import 'package:myapp/models/user.dart';

class Customer extends GeneralUser {
  final String _address;

  CustomerController controller = CustomerController();
  Customer(
      {required String uid,
      required String name,
      required String username,
      required String phoneNumber,
      required String address})
      : _address = address,
        super(
            uid: uid, name: name, username: username, phoneNumber: phoneNumber);

  void makeBid(String auctionId, double amount, String seafoodId) {
    controller.makeBid(uid, username, amount, seafoodId);
  }

  void joinAuction() {
    controller.joinAuction(this.uid, this.username);
  }
}
