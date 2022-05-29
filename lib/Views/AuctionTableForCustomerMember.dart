import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
class ViewAuctionTableCustomerMember extends StatefulWidget{

  @override
  State<ViewAuctionTableCustomerMember> createState() => _ViewAuctionTablesState();
}

class _ViewAuctionTablesState extends State<ViewAuctionTableCustomerMember> {
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
                           
                        itemCount: getPublishedTables(tables, isPublished).length,
                        itemBuilder: (context,index){
                          return showTables(getPublishedTables(tables, isPublished),isAuctioned)[index];
                        },
                        ),),
                         

                        

                       
                        
                            

                    ],
                      ),)
                    
                   ,);
                  
               

              
             
           
  }


  List<Column> showTables(List<List<List<dynamic>>> tables,List<bool> isAuctioned){
    final columns = [
      "No",
      "Product Name",
      "Quantity",
      "Base Price",
      "Sold Price"
    ];
  
    var containers = tables.map((table) =>
      Column(
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
      ],)
    ).toList();        

    return containers;                
  }
  

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();

  List<List<List>> getPublishedTables(List<List<List>> tables, List<bool> isPublished) {
    List<List<List<dynamic>>> publishedTables = [];
    for (var i = 0; i < isPublished.length; i++) {
      if (isPublished[i]){
        publishedTables.add(tables[i]);
      }
    }
    return publishedTables;
  }

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
}
