import 'package:myapp/models/user.dart';

class Customer extends GeneralUser {
  String _address;
  Customer({required String uid, 
            required String name, 
            required String username, 
            required String password, 
            required String phoneNumber,
            required String address }) 
            : _address = address,
             super(uid: uid, name: name, 
                    username: username, 
                     phoneNumber: phoneNumber);


}