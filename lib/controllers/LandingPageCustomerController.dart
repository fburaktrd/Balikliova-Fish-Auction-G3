import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/models/customer.dart';
import 'package:get_it/get_it.dart';

class UserController extends GetxController {
  Customer? _user;

  UserController();

  fetchCust(dynamic user) {
    _user = user;
    refresh();
  }

  Customer? get getUser => _user;
}
