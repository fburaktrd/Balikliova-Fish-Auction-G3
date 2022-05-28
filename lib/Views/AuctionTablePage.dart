import 'package:flutter/material.dart';
import 'package:myapp/Views/navBar.dart';
import "package:myapp/controllers/auctionTableController.dart";
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuctionTableScreen extends StatefulWidget {
  const AuctionTableScreen({Key? key}) : super(key: key);

  @override
  State<AuctionTableScreen> createState() => _AuctionTableScreenState();
}

class _AuctionTableScreenState extends State<AuctionTableScreen> {
  bool _customer = false;
  bool _coopMember = false;
  bool _coopHead = false;
  bool _coopCrew = false;
  bool _crewMember = false;
  bool loading = true;
  var userInfo;

  late AuctionTableController controller;
  Map<String, Map<String, dynamic>> auct_form = {};
  List<List<List<dynamic>>> tablesList = [];
  List<List<dynamic>> oneTable = [];

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  int rowNo = 0;
  bool show_auct_table = false;
  Map<String, Map<String, Map<String, dynamic>>> tables = {"tables": {}};

  @override
  void initState() {
    // TODO: implement initState
    Database()
        .ref
        .child("Roles")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      Database()
          .ref
          .child(res.value == "CUSTOMER" ? "Customer" : "Cooperative_Head")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((userRes) {
        userInfo = userRes.value;
        print(FirebaseAuth.instance.currentUser!.uid);
        checkUserTypes();
        print(_coopHead);
        setState(() {
          loading = false;
          print(userInfo);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkUserTypes();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Create Auction Table"), centerTitle: true),
        drawer: navBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      addAuctionTableAlert(context);
                    });
                  },
                ),
                show_auct_table == true
                    ? showAuctionTable(oneTable)
                    : Text("You have no auction table...")
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addAuctionTableAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Auction Tables'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(hintText: 'Product Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _basePriceController,
                    decoration: const InputDecoration(hintText: 'Base Price'),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Add item"),
                onPressed: () {
                  if (!isNameEmpty(context, _productNameController.text) &&
                      !isQuantityEmpty(context, _quantityController.text) &&
                      !isPriceEmpty(context, _basePriceController.text)) {
                    auct_form[rowNo.toString()] = {};
                    auct_form[rowNo.toString()]!["name"] =
                        _productNameController.text;

                    auct_form[rowNo.toString()]!["quantity"] =
                        int.parse(_quantityController.text);

                    auct_form[rowNo.toString()]!["basePrice"] =
                        int.parse(_basePriceController.text);
                    auct_form[rowNo.toString()]!["soldPrice"] = 0;

                    oneTable.add([
                      rowNo.toString(),
                      _productNameController.text,
                      int.parse(_quantityController.text),
                      int.parse(_basePriceController.text),
                      0
                    ]);
                    tablesList.add(oneTable);

                    setState(() {
                      show_auct_table = true;
                      _productNameController.clear();
                      _basePriceController.clear();
                      _quantityController.clear();
                    });

                    for (var key in auct_form.keys) {
                      print(auct_form);
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        }).then((_) {
      setState(() {});
    });
  }

  bool isNameEmpty(BuildContext context, String productName) {
    return productName.isEmpty;
  }

  bool isQuantityEmpty(BuildContext context, String quantity) {
    return quantity.isEmpty;
  }

  bool isPriceEmpty(BuildContext context, String price) {
    return price.isEmpty;
  }

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  Row showAuctionTable(List<List<dynamic>> oneTable) {
    final columns = [
      "No",
      "Product Name",
      "Quantity",
      "Base Price",
      "Sold Price"
    ];

    Row card = Row(children: [
      Expanded(
        child: DataTable(
          columns: getColumns(columns),
          rows: getRows(oneTable),
        ),
      ),
    ]);
    return card;
  }

  void checkUserTypes() {
    if (checkUserTypeCustomer()) {
      _customer = true;
      _coopMember = false;
      _coopHead = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCoopCrew()) {
      _coopCrew = true;
      _customer = false;
      _coopMember = false;
      _coopHead = false;
      _crewMember = false;
    } else if (checkUserTypeCoopHead()) {
      _coopHead = true;
      _customer = false;
      _coopMember = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCoopMember()) {
      _coopMember = true;
      _customer = false;
      _coopHead = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCrewMember()) {
      _crewMember = true;
      _customer = false;
      _coopMember = false;
      _coopHead = false;
      _coopCrew = false;
    }
  }

  String getName() {
    return (userInfo != null ? userInfo["name"] : "");
  }

  String getUserType() {
    // return "COOP_HEAD";
    return (userInfo != null ? userInfo["role"] : "");
  }

  bool checkUserType(String userType) {
    if (getUserType() == userType) {
      return true;
    } else {
      return false;
    }
  }

  bool checkUserTypeCustomer() {
    return checkUserType("CUSTOMER");
  }

  bool checkUserTypeCoopHead() {
    return checkUserType("COOP_HEAD");
  }

  bool checkUserTypeCoopCrew() {
    return checkUserType("Cooperative Crew");
  }

  bool checkUserTypeCoopMember() {
    return checkUserType("Cooperative Member");
  }

  bool checkUserTypeCrewMember() {
    return checkUserType("Crew Member");
  }
}
