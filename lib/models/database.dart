import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';


class Database{
  final ref = FirebaseDatabase.instance.ref();

  Future<DataSnapshot> getUser(String username) async {
    DataSnapshot snap;
    snap = (await ref.child("Users").child(username).once()) as DataSnapshot;
    return snap;
  }

  void setUser(String uid, String username, String name, String surname, String address, String phone_number) {
    ref
        .child("Users")
        .child(username)
        .set({"username": username, "name": name, "uid": uid, "phone_number": phone_number, "address": address, "surname": surname});
    ref.child("Usernames").child(uid).set(username);
  }



}
