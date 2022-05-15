// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import "package:myapp/controllers/auctionTableController.dart";

class AuctionTableScreen extends StatefulWidget {
  const AuctionTableScreen({Key? key}) : super(key: key);

  @override
  State<AuctionTableScreen> createState() => _AuctionTableScreenState();
}

class _AuctionTableScreenState extends State<AuctionTableScreen> {
  
  late AuctionTableController controller;
  List<int> noList = [];
  List<String> nameList = [];
  List<String> quantityList = [];
  List<String> basePriceList = [];

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  
  double _formProgress = 0;
  int rowNo = 0;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(title: const Text("Create Auction Table")),
        body: SafeArea(
          child: 
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: 
                        FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            setState((
                            ) {
                              addAuctionTableAlert(context);
                        
                          });
                        },
                      ),
                    ),
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
              LinearProgressIndicator(value: _formProgress),
              Text('Auction Table'),
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
          actions: <Widget> [
            new ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            ),

            new ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Complete"),
              onPressed: () {
                if (!isNameEmpty(context, _productNameController.text) 
                    && !isQuantityEmpty(context, _quantityController.text)
                    && !isPriceEmpty(context, _basePriceController.text)){
                      noList.add(rowNo);
                      rowNo++;
                      nameList.add(_productNameController.text);  //deneme için
                      quantityList.add(_quantityController.text);
                      basePriceList.add(_basePriceController.text);
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      printRows(noList,nameList,quantityList,basePriceList);
                      controller.addAuctionTable();
                    }
              },
            ),

            new ElevatedButton.icon(
              icon: Icon(Icons.navigate_next),
              label: Text("Next"),
              onPressed: () {
                if (!isNameEmpty(context, _productNameController.text) 
                    && !isQuantityEmpty(context, _quantityController.text)
                    && !isPriceEmpty(context, _basePriceController.text)){
                      noList.add(rowNo);
                      rowNo++;
                      nameList.add(_productNameController.text);
                      quantityList.add(_quantityController.text);
                      basePriceList.add(_basePriceController.text);
                      addAuctionTableAlert(context);
                }
              }
                
            ),
          

          new ElevatedButton.icon(
              icon: Icon(Icons.navigate_next),
              label: Text("Previous"),
              onPressed: () {
                Navigator.of(context).pop();
              },
          ),
        ],
      );
    }
  ); 
  }

  bool isNameEmpty(BuildContext context, String productName){
    return productName.isEmpty;
  }

  bool isQuantityEmpty(BuildContext context, String quantity){
    return quantity.isEmpty;
  }

  bool isPriceEmpty(BuildContext context, String price){
    return price.isEmpty;
  }

  void printRows(List<int> noList, List<String> nameList, List<String> quantityList, List<String> basePriceList) {
    for (var i = 0; i < noList.length; i++) {
      print("${noList[i]}, ${nameList[i]}, ${quantityList[i]}, ${basePriceList[i]}");
    }
  }

}

