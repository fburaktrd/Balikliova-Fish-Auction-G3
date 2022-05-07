import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GeneralUser _userFromFirebaseUser(User user) {
    return GeneralUser(uid: user.uid);
  }

  

  

  Future<String> signUp({
    required String password,
    required String email, //aslında username fakat flutter usernamele kayıt yapmıyor 
    required String name,   //usernameden sonra @abc.com eklenecek 
    required String address,
    required String surname,
    required String phone_number

  }) async {
    String message = "Cannot register at the moment please try again later";

    List<String> acceptedAdresses = <String>["Mordoğan", "Balıklıova", "Urla", "Ildır"];

    bool found = false;
    final splitted = address.split(" ");

    for (var i = 0; i < splitted.length; i++) {
      if (acceptedAdresses.contains(splitted[i])) {
          found = true;
      }
    }

    try{
      if (password.isEmpty ||
          email.isEmpty ||
          name.isEmpty ||
          address.isEmpty ||
          surname.isEmpty ||
          phone_number.isEmpty) {
            message = "Please fill all input boxes";
          }
      else if(!found){
        message = "Address is not in the range. Try registration again";
      }
      else{
        UserCredential cred = await _auth.signInWithEmailAndPassword(email: email+"@abc.com", password: password);
        models.GeneralUserData _user = models.GeneralUserData(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );


      }
    } catch(err){
      return err.toString();
    }

    return message;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return [cred, _userFromFirebaseUser(cred)];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future realRegister(String email, String password, String displayName) async {
    var val = await registerWithEmailAndPassword(email, password);
    if (val != null) {
      DataBaseConnection.setUser(val[0].uid, email, displayName);
      print("buraaassıı hoştur");
      print(val[0].displayName);
      DataBaseConnection.setUserDisplayName(val[0].uid, displayName);
      return val[1];
    } else {
      return val;
    }
  }
}

