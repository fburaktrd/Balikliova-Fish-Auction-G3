import 'package:flutter/cupertino.dart';
import 'package:myapp/controllers/auctionTableController.dart';

class AuctionTableGetItController extends ChangeNotifier {
  List<List<dynamic>> _table = [];
  AuctionTableGetItController();

  fetchTable(dynamic table) {
    _table = table;
    notifyListeners();
  }

  dynamic get getTable => _table;
}
