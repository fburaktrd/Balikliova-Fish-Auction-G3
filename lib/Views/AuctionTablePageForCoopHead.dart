import "package:myapp/Views/AuctionTablePage.dart";
import "package:myapp/Controllers/CoopHeadController.dart";
import 'package:flutter/material.dart';

class AuctionTablePageForCoopHead extends state <AuctionTablePage.AuctionTableScreen._AuctionTableScreenState>(){



    @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title ListTile(
              //contentPadding: EdgeInsets.all(<some value here>),//change for side padding
              title: Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(onPressed: (CoopHeadController.changeProductFlow()) {},child: Text("ChangeProductFlow"),color: Colors.black,textColor: Colors.white,)),
                  Expanded(child: RaisedButton(onPressed: (CoopHeadController.createAuctionTable()) {},child: Text("CreateAuctiınTable"),color: Colors.black,textColor: Colors.white,)),
                ],
              ),
            )
        )
    )
    )    
  }
}