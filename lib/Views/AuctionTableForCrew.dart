import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
// import 'package:myapp/controllers/CoopCrewMemberController.dart';
import 'package:myapp/controllers/UserController.dart';
import 'package:myapp/controllers/auctionTableController.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/crewMember.dart';
import 'package:myapp/models/user.dart';
class ViewAuctionTableCrew extends StatefulWidget{
  ViewAuctionTableCrew(this.userRole, {Key? key}) : super(key: key);
  String? userRole;

  @override
  State<ViewAuctionTableCrew> createState() => _ViewAuctionTableCrewState();
}

class _ViewAuctionTableCrewState extends State<ViewAuctionTableCrew> {

  List<AuctionTable> auctionTables = [];
  List<List<List<dynamic>>> tables = [];
  
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
          // Padding(padding: const EdgeInsets.all(8)
          //   ,child: checkIfPublished(auctionTables[i]),),
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
          //    ElevatedButton(
          // child: Text("Publish"),
          //   onPressed: () {
          //     setState(() {
          //       if(published){
          //         publishAlertDialog(context);
          //       }
          //       else{
          //         auctionTables[i].publishTable();
          //         published = true;
          //       } 
              
          //     });
          //   }),
      
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

  //   Text checkIfPublished(AuctionTable table) { 
    
  //   if(table.isPublished){
  //     return Text("Published");
  //   }
  //   else{
  //     return Text("Unpublished");
  //   }
  // }

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  // void publishAlertDialog(BuildContext context){
  //     showDialog(context: context, builder: (BuildContext build){
  //       return AlertDialog(
  //         title: Text("Warning!"),
  //         content: Row(children: [
  //            Column(children: [
  //             Container(
  //                 child: Text("A table is published already..."), 
  //               ),
  //             Padding(padding: const EdgeInsets.all(8)),
  //             ElevatedButton(onPressed: () {
  //               Navigator.of(context).pop();
  //               }, 
  //               child: const Text("OK")),
  //           ],)       

  //         ],),           
  //             );
  //     }).then((_){
  //       setState(() {
  //       });
  //     } );
  //    } 


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
                Padding(padding: const EdgeInsets.all(8),),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text("Update product"),
                    onPressed: () {
                      updateRowAlert(context, tables[tableNum], tableNum);
                    },
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8),),
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
    List<Column> columns = [];
    for (var rowNum = 0; rowNum < table.length; rowNum++) {
      Column column = Column(children: [
        ElevatedButton(
        child: Text("Update row ${rowNum + 1}"),
        onPressed: () {
          updateAuctionTableAlert(context, tables[tableNum], tableNum, rowNum);
        },
      ),
      Padding(padding: const EdgeInsets.all(5)),
      ],);
      
      columns.add(column);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          AlertDialog dialogName = AlertDialog(
            title: Text("Choose row"),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  itemCount: columns.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return columns[index];
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

  void updateAuctionTableAlert(BuildContext context, List<List<dynamic>> table,int tableNum ,int rowNum) {
  final GlobalKey<FormState> _updateKey = GlobalKey<FormState>();
  final _updateProductNameController = TextEditingController(text: tables[tableNum][rowNum][1]);
  final _updateQuantityController = TextEditingController(text: tables[tableNum][rowNum][2].toString());
  final _updateBasePriceController = TextEditingController(text: tables[tableNum][rowNum][3].toString());
  
      showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Update product"),
        content: Form(
          key: _updateKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _updateProductNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) { 
                  if (value!.isEmpty || _isNumeric(value)) {
                    return 'Please enter a product name with letters';}
                  else{
                    return null;}
                },
                  onChanged: (value) => setState(() => productName = value)
              ),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _updateQuantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  
                  if (value!.isEmpty || !(_isNumeric(value))) {
                    return 'Please enter a quantity with numbers';}
                  else{
                    return null;}
                  
                },
                onChanged: (value) => setState(() => quantity = value)
                  
                ),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _updateBasePriceController,
                decoration: const InputDecoration(labelText: 'Base Price'),
                validator: (value) {
                  
                  if (value!.isEmpty || !(_isNumeric(value))) {
                    return 'Please enter a base price with numbers';}
                  else{
                    return null;}
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

          }
         ),
          

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save"),
            onPressed: () {
              if (_updateKey.currentState!.validate()){
                _updateKey.currentState!.save();

                tables[tableNum][rowNum] = [(rowNum+1).toString(),
                          productName,
                          int.parse(quantity),
                          int.parse(basePrice),
                          0
                ];
          
                setState(() {
                  _updateProductNameController.clear();
                  _updateBasePriceController.clear();
                  _updateQuantityController.clear();
                });

                Navigator.of(context).pop();

              }
            }
          ),
       ],
      );
    }).then((_) {
      setState(() {});
    });
  }
}
