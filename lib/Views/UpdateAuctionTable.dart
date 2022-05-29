import 'package:flutter/material.dart';

class UpdateAuctionTable extends StatelessWidget {
  const UpdateAuctionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Update Auction Table",
        )),
      ),
      body: Column(
        children: const [Center(child: Text("Overview")), Placeholder()],
      ),
    );
  }
}
