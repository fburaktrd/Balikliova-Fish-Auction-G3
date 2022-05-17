import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/models/customer.dart';
import 'package:get_it/get_it.dart';

class UserController extends ChangeNotifier {
  dynamic _user;

  UserController();

  fetchCust(dynamic user) {
    _user = user;
    notifyListeners();
  }

  dynamic get getUser => _user;
}
