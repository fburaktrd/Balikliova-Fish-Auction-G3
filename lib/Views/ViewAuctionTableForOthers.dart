import 'package:flutter/material.dart';

class ViewAuctionTableforOthers extends StatelessWidget {
  const ViewAuctionTableforOthers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "View Auction Table",
        )),
      ),
      body: Column(
        children: const [Center(child: Text("Overview")), Placeholder()],
      ),
    );
  }
}
