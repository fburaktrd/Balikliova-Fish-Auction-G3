import 'dart:core';
import 'package:myapp/models/coopMember.dart';
import 'package:myapp/models/auction.dart';
import 'package:myapp/models/database.dart';
import 'package:myapp/controllers/auctionController.dart';

class Product {
  final String fishtype;
  final int amount;
  final int price;
  final int fishID;
  final int auctionID;
  bool isSold;

  Product(
      {required this.fishtype,
      required this.amount,
      required this.price,
      required this.fishID,
      required this.auctionID,
      required this.isSold,});
}
