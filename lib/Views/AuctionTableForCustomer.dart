import 'package:myapp/Views/navBar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/auctionTableController.dart';
import 'package:myapp/models/auctionTable.dart';

class ViewAuctionTableCustomerMember extends StatefulWidget {
  ViewAuctionTableCustomerMember(this.userRole, {Key? key}) : super(key: key);
  String? userRole;
  @override
  State<ViewAuctionTableCustomerMember> createState() =>
      _ViewAuctionTablesState();
}

class _ViewAuctionTablesState extends State<ViewAuctionTableCustomerMember> {
  List<AuctionTable> auctionTables = [];
  List<List<List<dynamic>>> tables = [];

  List<List<dynamic>> table = [];

  @override
  void initState() {
    AuctionTableController()
        .getTables(widget.userRole!)
        .then((resAuctionTables) {
      
      for (var table in resAuctionTables) {
        //print(table.seafoodProducts);
        auctionTables.add(table);
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
          title: const Text("Published Auction Tables"),
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

    var containers = tables
        .map((table) => Column(
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
              ],
            ))
        .toList();

    return containers;
  }

  List<DataRow> getRows(List<List<dynamic>> table) =>
      table.map((row) => DataRow(cells: getCells(row))).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((cell) => DataCell(Text('${cell}'))).toList();

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((column) => DataColumn(label: Text(column))).toList();
}
