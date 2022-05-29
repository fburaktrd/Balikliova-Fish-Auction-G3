import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';
import 'package:myapp/models/coopHead.dart';
class ViewAuctionTables extends StatefulWidget{

  @override
  State<ViewAuctionTables> createState() => _ViewAuctionTablesState();
}

class _ViewAuctionTablesState extends State<ViewAuctionTables> {
  



  List<List<List<dynamic>>> tables =  [
                                        [
                                        ["1","Levrek",20,10,10],
                                        ["2","Hamsi",12,23,43],
                                        ["3","Sardalya",45,3,24]
                                        ],

                                        [
                                        ["1","Çipura",20,10,10],
                                        ["2","Sazan",12,23,43],
                                        ["3","Kalkan",45,3,24]
                                        ],
                                        
                                        [
                                        ["1","Lüfer",20,10,10],
                                        ["2","Palamut",12,23,43],
                                        ["3","Uskumru",45,3,24]
                                        ],
                                      ];
  List<bool> isAuctioned = [true,true,false];
  List<bool> isPublished = [false,true,true];

  List<List<dynamic>> table = []; 
  
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("AuctionTableList"),),
        drawer: const navBar(),
        body: Column(
                  children: [
                    Expanded(child: ListView.builder(
                           
                        itemCount: tables.length,
                        itemBuilder: (context,index){
                          return showTables(tables,isAuctioned,isPublished)[index];
                        },
                        ),),
          
                    ],
                      ),)                 
                   ,);                      
  }


  List<Column> showTables(List<List<List<dynamic>>> tables,List<bool> isAuctioned,List<bool> isPublished){
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
        Container(child: Align(alignment: Alignment.center,child: tableAuctioned(isAuctioned),),
                width: double.infinity,
                color: Colors.blue,
                height: 22,),
        SingleChildScrollView(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        
          child: DataTable(
            columns: getColumns(columns),
            rows: getRows(table),
          ),
        ),
      ),
   
      Row(children: [
          ElevatedButton(onPressed: () {
            setState(() {
              if(checkTablePublished(isPublished,i) == false){
                publishAuctionTable(isPublished,i);}
              else{
                showPopUpDialog(context);
              }
            });
            
          }, child: Text("Publish")),

          ElevatedButton(onPressed: () {
            setState(() {
              updateAuctionTableRowView(context,table);
            });
          
        }, child: Text("Update"))
      ],)
        ],);
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

    Text tableAuctioned(List<bool> isAuctioned) {
    if (isAuctioned[0]){
      isAuctioned.add(isAuctioned.removeAt(0));
      return Text("Auctioned");
    }
    else{
      isAuctioned.add(isAuctioned.removeAt(0));
      return Text("Not Auctioned");
    }
  }

  void publishAuctionTable(List<bool> isPublished, index) {
    if(!isPublished[index]){
      isPublished[index] = true;
    }
  }

  void updateAuctionTableRowView(BuildContext context,List<List<dynamic>> table) {
    
      List<ListTile> tiles = [];

      for (var i = 0; i < table.length; i++) {
        ListTile tile = ListTile(title: Text("Update row ${i+1}"),
                                  onTap: (){
                                    //updateAuctionTableAlert(context, table,i);
                                  },);
                                tiles.add(tile);
        
      }
      
      showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text("Choose row"),
                        content: Container(width: double.minPositive,
                                  child: ListView.builder(itemCount: tiles.length,
                                  shrinkWrap: true,
                                      itemBuilder: (context,index){
                                        return tiles[index];
                                      }
                                      ),)                        
                                );
      }
      ).then((_) {
      setState(() {});
    });
 
  }

   bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
/*
  void updateAuctionTableAlert(BuildContext context, List<List<dynamic>> table,int index){
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    final _productNameController = TextEditingController();
    final _quantityController = TextEditingController();
    final _basePriceController = TextEditingController();
    String productName = '';
    String quantity = '';
    String basePrice = '';


  
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text("Update Table"),
                          content: Form(child: Column(
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
                                  onSaved: (value){
                                    setState(() {
                                      table[index][1] = value!;
                                    });
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
                                  onSaved: (value){
                                    setState(() {
                                      table[index][2] = int.parse(value!);
                                    });
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
                                  onSaved: (value){
                                    setState(() {
                                      table[index][3] = int.parse(value!);
                                    });
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

                          setState(() {
                            _productNameController.clear();
                            _basePriceController.clear();
                            _quantityController.clear();
                          });

                          Navigator.of(context).pop();
                  }
                },
              ),
                        ]
                      );


    }).then((_) {
      setState(() {});
    });
  }
  */

  bool checkTablePublished(List<bool> isPublished, int i) {
    return isPublished[i];
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
         },);
      return AlertDialog(title: Text("Oops..."),
                  content: Text("This table is already published"),
                  actions: [okButton]
            );
    });
    
  }
}
