import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';
import 'package:myapp/controllers/auctionTableController.dart';
import 'package:myapp/models/auctionTable.dart';
import 'package:myapp/models/coopHead.dart';

class ViewAuctionTableCoopHead extends StatefulWidget {
  @override
  State<ViewAuctionTableCoopHead> createState() =>
      _ViewAuctionTableCoopHeadState();
}

class _ViewAuctionTableCoopHeadState extends State<ViewAuctionTableCoopHead> {
  List<AuctionTable> auctionTables = [];
  List<List<List<dynamic>>> tables = [];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  String productName = '';
  String quantity = '';
  String basePrice = '';



  // [
  //   [
  //     ["1", "Levrek", 20, 10, 10],
  //     ["2", "Hamsi", 12, 23, 43],
  //     ["3", "Sardalya", 45, 3, 24]
  //   ],
  //   [
  //     ["1", "Çipura", 20, 10, 10],
  //     ["2", "Sazan", 12, 23, 43],
  //     ["3", "Kalkan", 45, 3, 24]
  //   ],
  //   [
  //     ["1", "Lüfer", 20, 10, 10],
  //     ["2", "Palamut", 12, 23, 43],
  //     ["3", "Uskumru", 45, 3, 24]
  //   ],
  // ];

  List<List<dynamic>> table = [];

  @override
  void initState() {
    AuctionTableController().getTables().then((resAuctionTables) {
      for (var table in resAuctionTables) {
        //print(table.seafoodProducts);
        tables.add(table.seafoodProducts);
      }
      setState(() {});
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
              ElevatedButton(
                  child: Text("Publish"),
                  onPressed: () {
                    setState(() {
                      publishAuctionTable(table);
                    });
                  }),
              ElevatedButton(child: Text("Update"),
                onPressed: () {
                setState(() {
                  chooseUpdateOption(context,tables[i],i);
                });
          
        }, )
            ],
          )
        ],
      );

      cols.add(col);
    }

    return cols;
  }

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  void publishAuctionTable(List<List<dynamic>> table) {
    // table i published table a gönder
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

   void chooseUpdateOption(BuildContext context, List<List<dynamic>> table, int tableNum) {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose update option"),
        content: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Add Product"),
                onPressed: () {
                  addProductAlert(context,tables[tableNum],tableNum);
                }, ),
            ),

            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Update product"),
                onPressed: () {
                  updateRowAlert(context,tables[tableNum],tableNum);
                },),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },)
            )
          ],
        ),
      );
    }).then((_) {
      setState(() {});
    });
  }

  void addProductAlert(BuildContext context, List<List<dynamic>> table, int tableNum) {
    int newRow = tables[tableNum].length;
    newRow++;
    
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Add product"),
        content: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _productNameController,
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
                controller: _quantityController,
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
                controller: _basePriceController,
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
            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save"),
            onPressed: () {
              if (_key.currentState!.validate()){
                _key.currentState!.save();

                tables[tableNum].add([(newRow).toString(),
                          productName,
                          int.parse(quantity),
                          int.parse(basePrice),
                          0
                          ]);
          
                setState(() {
                  _productNameController.clear();
                  _basePriceController.clear();
                  _quantityController.clear();
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

  void updateRowAlert(BuildContext context, List<List<dynamic>> table, int tableNum) {
    List<ElevatedButton> buttons = [];
    for (var rowNum = 0; rowNum < table.length; rowNum++) {
        ElevatedButton button = ElevatedButton(
          child: Text("Update row ${rowNum+1}"),
          onPressed: (){
            updateAuctionTableAlert(context,tables[tableNum],tableNum,rowNum);
                      },
        );
      buttons.add(button);
    }
    showDialog(context: context, builder: (BuildContext context){
      AlertDialog dialogName=  AlertDialog(
        title: Text("Choose row"),
        content: Container(
          width: double.minPositive,
          child: ListView.builder(itemCount: buttons.length,
          shrinkWrap: true,
              itemBuilder: (context,index){
                return buttons[index];
              }
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
        ],                       
        );
      return dialogName;                    
    }).then((_) {
      setState(() {});
    });
    
  }

  void updateAuctionTableAlert(BuildContext context, List<List<dynamic>> table,int tableNum ,int rowNum) {
        showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Update product"),
        content: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _productNameController,
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
                controller: _quantityController,
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
                controller: _basePriceController,
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
              if (_key.currentState!.validate()){
                _key.currentState!.save();

                tables[tableNum][rowNum] = [(rowNum+1).toString(),
                          productName,
                          int.parse(quantity),
                          int.parse(basePrice),
                          0
                ];
          
                setState(() {
                  _productNameController.clear();
                  _basePriceController.clear();
                  _quantityController.clear();
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

  bool checkTablePublished(List<bool> isPublished, int i) {
    return isPublished[i];
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
