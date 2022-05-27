import 'package:flutter/material.dart';

class ViewAuctionTableforOthers extends StatelessWidget {
  const ViewAuctionTableforOthers({Key? key}) : super(key: key);

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
