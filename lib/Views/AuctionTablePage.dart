import 'package:flutter/material.dart';
import 'package:myapp/Views/navBar.dart';
import "package:myapp/controllers/auctionTableController.dart";

class AuctionTableScreen extends StatefulWidget {
  const AuctionTableScreen({Key? key}) : super(key: key);

  @override
  State<AuctionTableScreen> createState() => _AuctionTableScreenState();
}

class _AuctionTableScreenState extends State<AuctionTableScreen> {
  late AuctionTableController controller;
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
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Create Auction Table"), centerTitle: true),
        drawer: navBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          addAuctionTableAlert(context);
                        });
                      },
                    ),
                  ),
                  show_auct_table == true ? showAuctionTables(tablesList) : Text("You have no auction table...")
                ],
              ),
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
                label: const Text("Complete"),
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
                  });

                  for (var key in auct_form.keys) {
                    print(auct_form);
                  }
                  Navigator.of(context).pop();
                      }
                },
              ),
              ElevatedButton.icon(
                  icon: const Icon(Icons.navigate_next),
                  label: const Text("Next"),
                  onPressed: () {
                    if (!isNameEmpty(context, _productNameController.text) &&
                        !isQuantityEmpty(context, _quantityController.text) &&
                        !isPriceEmpty(context, _basePriceController.text)) {
                      setState(() {
                        auct_form[rowNo.toString()] = {};
                        auct_form[rowNo.toString()]!["name"] =
                            _productNameController.text;

                        auct_form[rowNo.toString()]!["quantity"] =
                            int.parse(_quantityController.text);

                        auct_form[rowNo.toString()]!["basePrice"] =
                            int.parse(_basePriceController.text);
                        auct_form[rowNo.toString()]!["SoldPrice"] = 0;
                        _productNameController.clear();
                        _basePriceController.clear();
                        _quantityController.clear();
                        rowNo++;
                      });
                    }
                  }),
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
    DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
    columns.map((column) => 
    DataColumn(label: Text(column))
    ).toList();

  DataTable showAuctionTable(List<List<dynamic>> table) {
    final columns = ["No", "Product Name", "Quantity", "Base Price", "Sold Price"];

    DataTable auct_table = DataTable(
              columns: getColumns(columns),
              rows: getRows(table),);
    return auct_table;
  }

  ListView showAuctionTables(List<List<List<dynamic>>> tables){
    ListView auctionTablesList = ListView.separated(
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context,_){
              return Divider(
                height: 5,
                color: Colors.black,
              );
            },
            itemCount: tables.length,
            itemBuilder: (context,index){
              return ListTile(
                title: Text("Auction Table"),
                leading: Icon(Icons.add),
                
                onLongPress: (){
                  setState(() {
                    showAuctionTable(tables[index]);
                  });
                },
              );
            },
          );  
        
    return auctionTablesList;

  }

}

