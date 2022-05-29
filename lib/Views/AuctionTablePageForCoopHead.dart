import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';

class AuctionTablePageForCoophead extends StatefulWidget {
  const AuctionTablePageForCoophead({Key? key}) : super(key: key);

  @override
  _AuctionTablePageForCoopheadState createState() => _AuctionTablePageForCoopheadState();

}

class _AuctionTablePageForCoopheadState extends State<AuctionTablePageForCoophead> {
  late CoopHeadController controller;
  Map<String, Map<String, dynamic>> auct_form = {};
  List<List<List<dynamic>>> tablesList = [];
  List<List<dynamic>> oneTable = [];


  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  int rowNo = 0;
  bool show_auct_table = false;
  Map<String, Map<String,Map<String,dynamic>>> tables = {"tables": {}};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {controller.changeProductFlow();},
                child: const Text("ChangeProductFlow"),
              ),
              ElevatedButton(
                onPressed: () {addAuctionTableAlert(context);},
                child: const Text("CreateAuctionTable"),
              ),
            ],
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
                const Text('Auction Table'),
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

                    oneTable.add([rowNo.toString(),
                      _productNameController.text,
                      int.parse(_quantityController.text),
                      int.parse(_basePriceController.text),
                      0]);
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
      table.map((row) =>
          DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) =>
          DataCell(Text('$cell'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) =>
          DataColumn(label: Text(column))
      ).toList();

  Row showAuctionTable(List<List<dynamic>> oneTable) {
    final columns = ["No", "Product Name", "Quantity", "Base Price", "Sold Price"];

    Row card = Row(
        children: [
          Expanded(
            child: DataTable(
              columns: getColumns(columns),
              rows: getRows(oneTable),),),]);
    return card;
  }




}