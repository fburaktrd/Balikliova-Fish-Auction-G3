import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';
import 'package:myapp/controllers/UserController.dart';
import 'package:myapp/controllers/auctionTableController.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/coopHead.dart';
import 'package:myapp/models/user.dart';

class ViewAuctionTableCoopHead extends StatefulWidget {
  ViewAuctionTableCoopHead(this.userRole, {Key? key}) : super(key: key);
  String? userRole;
  @override
  State<ViewAuctionTableCoopHead> createState() =>
      _ViewAuctionTableCoopHeadState();
}

class _ViewAuctionTableCoopHeadState extends State<ViewAuctionTableCoopHead> {
  List<AuctionTable> auctionTables = [];
  List<List<List<dynamic>>> tables = [];

  List<List<List<dynamic>>> dummyTables = [
                                              [ 
                                                ["0","unpublished1",1,23,4],
                                                ["1","unpublished2",23,23,1]
                                              ],

                                              [
                                                ["0","Balıkfalan",12,12,0],
                                                ["1","bitanedahabalık",23,23,23],
                                              ]
                                          ];

  List<List<dynamic>> unpublishedTable =[
                                          ["0","unpublished1",1,23,4],
                                          ["1","unpublished2",23,23,1]
                                        ]; //dummy veri

  List<List<dynamic>> publishedTable = 
                                        [
                                          ["0","Balıkfalan",12,12,0],
                                          ["1","bitanedahabalık",23,23,23],
                                        ]; // dummy veri

  bool published = false;

  List<List<List<dynamic>>> unpublishedTables = []; // dummy veri

  List<List<List<dynamic>>> publishedTables = []; // dummy veri

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  GeneralUser user = getIt<UserController>().getUser;
  String productName = '';
  String quantity = '';
  String basePrice = '';

  List<List<dynamic>> table = [];

  @override
  void initState() {
    AuctionTableController().getTables(widget.userRole!).then((resAuctionTables) {
      for (var table in resAuctionTables) {
        //print(table.seafoodProducts);
        auctionTables.add(table);
        tables.add(table.seafoodProducts);
      }
      setState(() {
        
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("AuctionTableList"),
        ),
        drawer: const navBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  return showTables(tables)[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Column> showTables(List<List<List<dynamic>>> tables) {
    final columns = [
      "No",
      "Product Name",
      "Quantity",
      "Base Price",
      "Sold Price"
    ];
    int tableNum = 0;

    List<Column> cols = [];

    for (var i = 0; i < tables.length; i++) {
      table = tables[i];
      Column col = Column(
        children: [
          Padding(padding: const EdgeInsets.all(8)),
          Padding(padding: const EdgeInsets.all(8)
            ,child: checkIfPublished(auctionTables[i]),),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: getColumns(columns),
                rows: getRows(table),
              ),
            ),
          ),
          Row(
            children: [
              publishOrUnpublish(i),
              ElevatedButton(
                child: Text("Update"),
                onPressed: () {
                  setState(() {
                    chooseUpdateOption(context, tables[i], i);
                  });
                },
              )
            ],
          )
        ],
      );

      cols.add(col);
    }

    return cols;
  }

    Text checkIfPublished(AuctionTable table) { 
    
    if(table.isPublished){
      return Text("Published");
    }
    else{
      return Text("Unpublished");
    }
  }

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();


  ElevatedButton publishOrUnpublish(int index){
    if(published){
      showDialog(context: context, builder: (BuildContext build){
        return AlertDialog(
          title: Text("Warning!"),
          content: SizedBox(
            child: Column(
              children: [
                Container(
                  child: Text("A table is published already..."), 
                ),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Icon(Icons.arrow_back))

              ]),
          ),
        );
      }).then((_){
        setState(() {
        });
      } );
    }

    if(!dummyTables.contains(unpublishedTable)){
      return ElevatedButton(
          child: Text("Publish"),
            onPressed: () {
              setState(() {
                auctionTables[index].publishTable();
                publishedTables.add(unpublishedTable);
              });
            });
    } 
    else {
      return ElevatedButton(
          child: Text("Unpublish"),
            onPressed: () {
              setState(() {
                //auctionTables[i].publishTable();
                unpublishedTables.add(publishedTable);
              });
            });
    }
    

  }

  void updateAuctionTableRowView(
      BuildContext context, List<List<dynamic>> table) {
    List<ListTile> tiles = [];

    for (var i = 0; i < table.length; i++) {
      ListTile tile = ListTile(
        title: Text("Update row ${i + 1}"),
        onTap: () {
          //updateAuctionTableAlert(context, table,i);
        },
      );
      tiles.add(tile);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose row"),
              content: Container(
                width: double.minPositive,
                child: ListView.builder(
                    itemCount: tiles.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return tiles[index];
                    }),
              ));
        }).then((_) {
      setState(() {});
    });
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void chooseUpdateOption(
      BuildContext context, List<List<dynamic>> table, int tableNum) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose update option"),
            content: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text("Add Product"),
                    onPressed: () {
                      addProductAlert(context, tables[tableNum], tableNum);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text("Update product"),
                    onPressed: () {
                      updateRowAlert(context, tables[tableNum], tableNum);
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ))
              ],
            ),
          );
        }).then((_) {
      setState(() {});
    });
  }

  void addProductAlert(
      BuildContext context, List<List<dynamic>> table, int tableNum) {
    int newRow = tables[tableNum].length;
    newRow++;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add product"),
            content: Form(
              key: _key,
              child: Column(
                children: [
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
                      onChanged: (value) =>
                          setState(() => productName = value)),
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
                    onChanged: (value) => setState(() => basePrice = value),
                  ),
                ],
              ),
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
                  label: const Text("Save"),
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      List<dynamic> productInfo = [
                        (newRow).toString(),
                        productName,
                        int.parse(quantity),
                        int.parse(basePrice),
                        0
                      ];
                      auctionTables[tableNum].addProduct(productInfo);

                      setState(() {
                        _productNameController.clear();
                        _basePriceController.clear();
                        _quantityController.clear();
                      });

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          );
        }).then((_) {
      setState(() {});
    });
  }

  void updateRowAlert(
      BuildContext context, List<List<dynamic>> table, int tableNum) {
    List<ElevatedButton> buttons = [];
    for (var rowNum = 0; rowNum < table.length; rowNum++) {
      ElevatedButton button = ElevatedButton(
        child: Text("Update row ${rowNum + 1}"),
        onPressed: () {
          updateAuctionTableAlert(context, tables[tableNum], tableNum, rowNum);
        },
      );
      buttons.add(button);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          AlertDialog dialogName = AlertDialog(
            title: Text("Choose row"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  itemCount: buttons.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buttons[index];
                  }),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          return dialogName;
        }).then((_) {
      setState(() {});
    });
  }

  void updateAuctionTableAlert(BuildContext context, List<List<dynamic>> table,
      int tableNum, int rowNum) {

      final GlobalKey<FormState> _updateKey = GlobalKey<FormState>();
      final _updateProductNameController = TextEditingController(text: tables[tableNum][rowNum][1]);
      final _updateQuantityController = TextEditingController(text: tables[tableNum][rowNum][2].toString());
      final _updateBasePriceController = TextEditingController(text: tables[tableNum][rowNum][3].toString());
  
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update product"),
            content: Form(
              key: _updateKey,
              child: Column(
                children: [
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _updateProductNameController,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value!.isEmpty || _isNumeric(value)) {
                          return 'Please enter a product name with letters';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) =>
                          setState(() => productName = value)),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _updateQuantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value!.isEmpty || !(_isNumeric(value))) {
                          return 'Please enter a quantity with numbers';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() => quantity = value)),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _updateBasePriceController,
                    decoration: const InputDecoration(labelText: 'Base Price'),
                    validator: (value) {
                      if (value!.isEmpty || !(_isNumeric(value))) {
                        return 'Please enter a base price with numbers';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) => setState(() => basePrice = value),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  onPressed: () {
                    if (_updateKey.currentState!.validate()) {
                      _updateKey.currentState!.save();
                      List<dynamic> updatedInfo = [
                        (rowNum + 1).toString(),
                        productName,
                        int.parse(quantity),
                        int.parse(basePrice),
                        0
                      ];
                      auctionTables[tableNum]
                          .updateRowTable((rowNum + 1).toString(), updatedInfo);
                      tables[tableNum][rowNum] = updatedInfo;

                      setState(() {
                        _updateProductNameController.clear();
                        _updateBasePriceController.clear();
                        _updateQuantityController.clear();
                      });

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          );
        }).then((_) {
      setState(() {});
    });
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Widget okButton = TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          return AlertDialog(
              title: Text("Oops..."),
              content: Text("This table is already published"),
              actions: [okButton]);
        });
  }


}
