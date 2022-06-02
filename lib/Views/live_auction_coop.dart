import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:another_flushbar/flushbar.dart';
import '../models/auctionTable.dart';
import 'package:flutter/cupertino.dart';

import 'navBar.dart';

class LiveAuctionCoop extends StatefulWidget {
  const LiveAuctionCoop({Key? key}) : super(key: key);

  @override
  State<LiveAuctionCoop> createState() => _LiveAuctionCoopState();
}

class _LiveAuctionCoopState extends State<LiveAuctionCoop> {
  CoopHeadController cp = new CoopHeadController();
  final CountdownController countdownController =
      new CountdownController(autoStart: true);
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'vq3IvvNe7VY',
    params: YoutubePlayerParams(
      startAt: Duration(seconds: 0),
      showControls: true,
      showFullscreenButton: true,
    ),
  );

  List<dynamic> table = [
    ["1", "Levrek", 20, 10, 10],
    ["2", "Hamsi", 12, 23, 43],
    ["3", "Sardalya", 45, 3, 24]
  ];

  String newPrice = "";
  int i = 0;
  int highestBid = 0;

  int getItemPrice(int itemIndex){
    return table[i][3];
  }

  void setItemPrice(int itemIndex, String newValue){
    table[i][3] = int.parse(newValue);
  }

  String getItemInfos(int itemIndex){
    return ("Item no: " + table[i][0] + " Name: " + table[i][1] + " Quantity: " + table[i][2] + " Base Price: " + table[i][3] + " Sold Price: " + table[i][4]);
  }


  @override
  Widget build(BuildContext context) {
    int userCount = getLiveUserCount();
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Live Auction"),
            centerTitle: true,
          ),
          drawer: const navBar(),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Live Auction Video Stream",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 2,
                            fontSize: 25),
                      ),
                    ),
                    SizedBox(width: 10, height: 3),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.person),
                        label: Text("$userCount"),
                        onPressed: () {
                          onEnd();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shadowColor: Colors.white,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Countdown(
                      controller: countdownController,
                      seconds: 9, //update time
                      build: (_, double time) => SizedBox.shrink(),
                      interval: Duration(seconds: 1),
                      onFinished: () {
                        onEnd();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: (MediaQuery.of(context).size.height) / 2,
                      width: MediaQuery.of(context).size.width - 2,
                      child: YoutubePlayerIFrame(
                        controller: _controller,
                        aspectRatio: 3 / 2,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                            child: const Text(
                              'Change Product Flow',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              cp.changeProductFlow();
                            },
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                            child: const Text(
                              'Change Base Price',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              //cp.changeBasePrice();


                              showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                              AlertDialog(
                              title: const Text(
                              "Enter your new price"),
                              titleTextStyle:
                              const TextStyle(fontSize: 24),
                              elevation: 10,
                              content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              Text("Previous price: ${getItemPrice(i)}"),
                              TextField(
                              keyboardType:
                              TextInputType.number,
                              onChanged: (String? str) =>
                              setState(() {
                              newPrice = str!;
                              }),
    )
    ],
    ),
    actions: <Widget>[
    TextButton(
    onPressed: () {
    if (newPrice == "") {
    Flushbar(
    title:
    "No value entered",
    message:
    "Please specify the next price.",
    duration:
    const Duration(
    seconds: 3))
        .show(context);
    }
    //value entered is higher
    else if (getItemPrice(i) > int.parse(newPrice)) {
    setItemPrice(i, newPrice);

    Flushbar(
    title: "Done!",
    message:
    "Product value has been changed! " +
    getItemInfos(i),
    duration:
    const Duration(
    seconds: 3))
        .show(context);
    } else {
    Flushbar(
    title:
    "Value Beyond Limit",
    message:
    "Please enter a lower value than previous.",
    duration:
    const Duration(
    seconds: 3))
        .show(context);
    }
    },
    //style: ButtonStyle(minimumSize: 16, maximumSize: 25),
    child: const Text("Change")),
    TextButton(
    onPressed: () => {
    Navigator.pop(
    context, 'Cancel'),
    },
    child: const Text("Cancel")),
    //TODO dummy bu silinecek
    TextButton(
    onPressed: () =>
    {highestBid = 600},
    child: const Text(
    "600 diye yeni bid gelmiş olsun")),
    ]));
                            },
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                            child: const Text(
                              'Activate/Deactivate Buttons',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              cp.activateDeactivateButtons();
                            },
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                            child: const Text(
                              'Finalise Sold Price',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              //TODO cp.finaliseSoldPrice();
                              table[i][4] = highestBid;
                              i++;
                              highestBid = 0;
                            },
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: FlatButton(
                            child: const Text(
                              'Finish Live Auction',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              cp.finishLiveAuction();
                              Navigator.of(context).pop();
                            },
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50))
                  ],
                )
              ])),
    );
  }

  onEnd() {
    //10 saniyede bir databaseden yeni bid var mı diye çekmesi gerek
    countdownController.restart();

    setState(() {});
  }

  int getLiveUserCount() {
    return 10;
  }
}
