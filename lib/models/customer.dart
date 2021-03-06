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
      required String address,
      required String email})
      : _address = address,
        super(
            uid: uid, name: name, username: username, phoneNumber: phoneNumber, email:email);

  void makeBid(double amount, String seafoodId) {
    controller.makeBid(uid, username, amount, seafoodId);
  }

  void joinAuction() {
    controller.joinAuction(this.uid, this.username);
  }

  void leaveAuction() {
    controller.leaveAuction(this.uid);
  }
}
