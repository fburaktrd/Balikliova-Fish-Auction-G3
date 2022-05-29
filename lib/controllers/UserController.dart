import 'package:flutter/cupertino.dart';

class UserController extends ChangeNotifier {
  dynamic _user;

  UserController();

  fetchCust(dynamic user) {
    _user = user;
    notifyListeners();
  }

  dynamic get getUser => _user;
}
