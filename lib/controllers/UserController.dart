import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/models/customer.dart';
import 'package:get_it/get_it.dart';

class UserController extends GetxController {
  dynamic _user;


  UserController();

  fetchCust(Customer user) {
    _user = user;
    refresh();
  }


  dynamic get getUser => _user;

}
