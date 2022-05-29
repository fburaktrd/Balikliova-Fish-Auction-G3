import 'package:flutter/material.dart';

class LiveAuctionCoop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Live Auction"),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    alignment: Alignment.topRight,
                    height: (MediaQuery.of(context).size.height) / 2,
                    width: MediaQuery.of(context).size.width - 45,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FlatButton(
                          child: Text(
                            'Change Product Flow',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {},
                          minWidth: 350,
                          height: 50))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FlatButton(
                          child: Text(
                            'Change Base Price',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {},
                          minWidth: 350,
                          height: 50))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FlatButton(
                          child: Text(
                            'Activate/Deactivate Buttons',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {},
                          minWidth: 350,
                          height: 50))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FlatButton(
                          child: Text(
                            'Finalise Sold Price',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {},
                          minWidth: 350,
                          height: 50))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FlatButton(
                          child: Text(
                            'Finish Live Auction',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {},
                          minWidth: 350,
                          height: 50))
                ],
              )
            ]));
  }
}
