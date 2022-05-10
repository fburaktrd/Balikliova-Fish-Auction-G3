import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/user.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();

  GeneralUser _userFromFirebaseUser(User user) {
    return GeneralUser(uid: user.uid);
  }

  Future<String> signUp(
      {required String password,
      required String
          email, //aslında username fakat flutter usernamele kayıt yapmıyor
      required String name, //usernameden sonra @abc.com eklenecek
      required String address,
      required String phoneNumber}) async {
    String message = "Cannot register at the moment please try again later";

    List<String> acceptedAdresses = <String>[
      "Mordoğan",
      "Balıklıova",
      "Urla",
      "Ildır"
    ];

    bool found = false;
    final splitted = address.split(" ");

    for (var i = 0; i < splitted.length; i++) {
      if (acceptedAdresses.contains(splitted[i])) {
        found = true;
      }
    }

    try {
      if (password.isEmpty ||
          email.isEmpty ||
          name.isEmpty ||
          address.isEmpty ||
          phoneNumber.isEmpty) {
        message = "Please fill all input boxes";
      } else if (!found) {
        message = "Address is not in the range. Try registration again";
      } else {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email + "@gmail.com", password: password);
        Customer _user = Customer(
            username: email,
            uid: cred.user!.uid,
            name: name,
            password: password,
            address: address,
            phoneNumber: phoneNumber);
        //setting to the database the values
        ref
            .child("Customer")
            .child(_user.uid)
            .set({"username": _user.username, "uid": _user.uid, "phoneNumber":phoneNumber,"name":name,"address":address});
        ref.child("UserNames").child(_user.uid).set(_user.username);
        // add user to database will be implemented
        message = "You have successfully registered ${_user.name}!";
      }
    } catch (err) {
      return err.toString();
    }

    return message;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email + "@gmail.com",
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
