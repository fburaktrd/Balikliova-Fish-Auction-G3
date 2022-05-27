import 'package:flutter/material.dart';

class ViewAuctionTableforCOOPHEAD extends StatelessWidget {
  const ViewAuctionTableforCOOPHEAD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "View Auction Table",
        )),
      ),
      body: Column(
        children: [Center(child: Text("Overview")), Placeholder()],
      ),
    );
  }
}
