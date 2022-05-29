import 'package:flutter/material.dart';
import 'package:myapp/Views/navBar.dart';
import 'package:myapp/controllers/AuctionTableGetItController.dart';
import "package:myapp/controllers/auctionTableController.dart";
import 'package:myapp/locator.dart';
import 'package:myapp/Views/update_info.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAuctionTableScreen extends StatefulWidget {
  const CreateAuctionTableScreen({Key? key}) : super(key: key);

  @override
  State<CreateAuctionTableScreen> createState() => _CreateAuctionTableScreenState();
}

class _CreateAuctionTableScreenState extends State<CreateAuctionTableScreen> {
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

  static set deleteButton(TextButton deleteButton) {}
  static set publishButton(TextButton publishButton) {}

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
  bool show_auct_table = false;

  @override
  void initState() {
    show_auct_table = oneTable.isEmpty ? false : true;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Create Auction Table"), centerTitle: true),
        drawer: const navBar(),
        body: Form(
          key: _key,
          child: Center(
            child: Column(
              children: [
                show_auct_table == true
                    ? showAuctionTable(oneTable)
                    : const Text("You have no auction table..."),
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      addAuctionTableAlert(context);
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    deleteButton = TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        oneTable.clear();
                        rowNo = 1;
                        show_auct_table = false;
                        setState(() {});
                      },
                      child: const Text('Delete Table'),
                    ),
                    publishButton = TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {},
                      child: const Text('Add Table to the library'),
                    )
                  ],
                ) //if (oneTable.isNotEmpty) buttonRow
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
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
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value!.isEmpty || _isNumeric(value)) {
                        return 'Please enter a product name with letters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        auct_form[rowNo.toString()]!["name"] = value!;
                      });
                    },
                    onChanged: (value) => setState(() => productName = value)),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    validator: (value) {
                      if (value!.isEmpty || !(_isNumeric(value))) {
                        return 'Please enter a quantity with numbers';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        auct_form[rowNo.toString()]!["quantity"] =
                            int.parse(value!);
                      });
                    },
                    onChanged: (value) => setState(() => quantity = value)),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _basePriceController,
                  decoration: const InputDecoration(labelText: 'Base Price'),
                  validator: (value) {
                    if (value!.isEmpty || !(_isNumeric(value))) {
                      return 'Please enter a base price with numbers';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      auct_form[rowNo.toString()]!["basePrice"] =
                          int.parse(value!);
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
                  if (_key.currentState!.validate()) {
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
      row.map((cell) => DataCell(Text('$cell'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  Container showAuctionTable(List<List<dynamic>> oneTable) {
    final columns = [
      "No",
      "Product Name",
      "Quantity",
      "Base Price",
      "Sold Price"
    ];

    Container container = Container(
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: getColumns(columns),
            rows: getRows(oneTable),
          ),
        ),
      ),
    );
    return container;
  }
}
