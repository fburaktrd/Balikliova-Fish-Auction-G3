
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
  Map<String,Map<String,dynamic>> auct_form = {};

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _basePriceController = TextEditingController();
  int rowNo = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Create Auction Table"), centerTitle: true),
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
                        controller.addAuctionTable(auct_form);  
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
                          auct_form[rowNo.toString()] = {"name" : _productNameController.text};
                          auct_form[rowNo.toString()] = {"quantity": int.parse(_quantityController.text)};
                          auct_form[rowNo.toString()] = {"basePrice": int.parse(_basePriceController.text)};
                          auct_form[rowNo.toString()] = {"SoldPrice": 0};
                          _productNameController.text = "";
                          _basePriceController.text = "";
                          _quantityController.text = "";
                        
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
}