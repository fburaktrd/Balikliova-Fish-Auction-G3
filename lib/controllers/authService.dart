import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();

  Future setRole(User? user, GeneralUser gUser) async {
    var res = await ref.child("Roles").child(user!.uid).get();

    gUser.role = res.value.toString();
  }

  GeneralUser _getUser(User? user) {
    var appUser = GeneralUser(
        uid: user!.uid, username: user.email!.split("@gmail.com")[0],role: "null");
    setRole(user, appUser);
    return appUser;
  }

  Stream<GeneralUser> get onAuthStateChanged =>
      _auth.authStateChanges().map(_getUser);

  Future<dynamic> signUp(
      {required String password,
      required String
          email, //aslında username fakat flutter usernamele kayıt yapmıyor
      required String name, //usernameden sonra @abc.com eklenecek
      required String address,
      required String phoneNumber}) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email + "@gmail.com", password: password);

      Customer _user = Customer(
          username: email,
          uid: cred.user!.uid,
          address: address,
          name: name,
          phoneNumber: phoneNumber);

      //setting to the database the values
      ref.child("Customer").child(_user.uid).set({
        "username": _user.username,
        "uid": _user.uid,
        "phoneNumber": phoneNumber,
        "name": name,
        "role": "CUSTOMER",
        "address": address
      });
      ref.child("Roles").child(_user.uid).set("CUSTOMER");
      // add user to database will be implemented
      //role = "CUSTOMER";
      return _user;
    } catch (err) {
      return null;
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        var authRes = await _auth.signInWithEmailAndPassword(
          email: email + "@gmail.com",
          password: password,
        );
        //await getRole(authRes.user);
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
