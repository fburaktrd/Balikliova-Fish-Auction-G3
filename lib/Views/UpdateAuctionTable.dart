import 'package:flutter/material.dart';

class UpdateAuctionTable extends StatelessWidget {
  const UpdateAuctionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Update Auction Table",
        )),
      ),
      body: Column(
        children: [Center(child: Text("Overview")), Placeholder()],
      ),
    );
  }
}
