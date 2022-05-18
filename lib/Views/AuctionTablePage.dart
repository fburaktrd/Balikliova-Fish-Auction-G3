import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/Views/navBar.dart';
import 'package:myapp/controllers/AuctionTableGetItController.dart';
import "package:myapp/controllers/auctionTableController.dart";
import 'package:myapp/locator.dart';

class AuctionTableScreen extends StatefulWidget {
  const AuctionTableScreen({Key? key}) : super(key: key);

  @override
  State<AuctionTableScreen> createState() => _AuctionTableScreenState();
}

class _AuctionTableScreenState extends State<AuctionTableScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late AuctionTableController controller;
  Map<String, Map<String, dynamic>> auct_form = {};
  List<List<List<dynamic>>> tablesList = [];
  List<List<dynamic>> oneTable = getIt<AuctionTableGetItController>().getTable;

   final _productNameController = TextEditingController();
   final _quantityController = TextEditingController();
   final _basePriceController = TextEditingController();



   String productName = '';
   String quantity = '';
   String basePrice = '';

   @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _productNameController.dispose();
    _basePriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
  int rowNo = 1;
  bool show_auct_table=false;

  @override
  void initState() {
    show_auct_table = oneTable.length == 0 ? false : true;
    setState(() {
      
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Create Auction Table"), centerTitle: true),
        drawer: navBar(),
        body: Form(
            key: _key,
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
                const Text('Auction Table'),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _productNameController,
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      
                      if (value!.isEmpty || !RegExp(r'a-zA-Z').hasMatch(value)) {
                        return 'Please enter a product name with letters';}
                      else{
                        return null;}
                    },
                    onSaved: (value){
                      setState(() {
                        auct_form[rowNo.toString()]!["name"] = value!;
                      });
                    },
                     onChanged: (value) => setState(() => productName = value)
                  ),
                
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'0-9').hasMatch(value)) {
                        return 'Please enter a quantity with numbers';}
                      else{
                        return null;}
                      
                    },
                    onSaved: (value){
                      setState(() {
                        auct_form[rowNo.toString()]!["quantity"] = int.parse(value!);
                      });
                    },
                    onChanged: (value) => setState(() => quantity = value)
                      
                    ),            
                
                
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _basePriceController,
                    decoration: const InputDecoration(labelText: 'Base Price'),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'0-9').hasMatch(value)) {
                        return 'Please enter a base price with numbers';}
                      else{
                        return null;}
                    },
                    onSaved: (value){
                      setState(() {
                        auct_form[rowNo.toString()]!["basePrice"] = int.parse(value!);
                      });
                    },
                    onChanged: (value) => setState(() => basePrice = value),
                  ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Add item"),
                onPressed: () {
                  if (_key.currentState!.validate()){
                    _key.currentState!.save();
                    
                    for (var key in auct_form.keys) {
                      auct_form[key]!["soldPrice"] = 0;
                      
                    }

                    oneTable.add([
                      rowNo.toString(),
                      productName,
                      int.parse(quantity),
                      int.parse(basePrice),
                      0
                    ]);
                    getIt<AuctionTableGetItController>().fetchTable(oneTable);
                    rowNo++;
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
}
