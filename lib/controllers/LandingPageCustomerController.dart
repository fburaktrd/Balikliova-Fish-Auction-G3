import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/models/customer.dart';
import 'package:get_it/get_it.dart';

class LandingPageCustomerController extends GetxController {
  Customer? _customer;

  LandingPageCustomerController();

  fetchCust(Customer user) {
    _customer = user;
    refresh();
  }

  Customer? get getCustomer => _customer;
}
