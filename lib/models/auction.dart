
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/customer.dart';

abstract class Auction{

  auction({
    required String date,
    required List <int> bidList,
    required AuctionTable auctionTable,
    required List <int> auctionID,
    required List <Customer> customersInAuction,});

}