import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/CoopHeadController.dart';
import 'package:myapp/controllers/auctionController.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/seafood.dart';
import 'navBar.dart';

class LiveAuctionCoop extends StatefulWidget {
  const LiveAuctionCoop({Key? key}) : super(key: key);

  @override
  State<LiveAuctionCoop> createState() => _LiveAuctionCoopState();
}

Seafood fish = new Seafood(
    id: "0", productName: "Loading...", basePrice: 10, latestBid: 0, amount: 0);

class _LiveAuctionCoopState extends State<LiveAuctionCoop> {
  CoopHeadController cp = new CoopHeadController();

  double latestBid = fish.getLatestBid();
  String fishName = fish.getproductName();
  double quantity = fish.getFishAmount();
  double basePrice = fish.getBasePrice();
  bool isActive = true;
  Map? latestBidMap;
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

  //1. row no 2. name 3. quantity 4. base price 5. sold price
  List<dynamic> table = [
    ["1", "Levrek", 20, 10, 0],
    ["2", "Hamsi", 12, 23, 0],
    ["3", "Sardalya", 45, 3, 0],
    ["4", "Alabalık", 34, 45, 0],
    ["5", "Sardalya", 45, 3, 0]
  ];
  List<dynamic> unsoldsTable = [];

  String newPrice = "";
  int i = 0;
  int j = 0;
  bool wasSecondRound = false;
  AuctionController auctionController = AuctionController();
  dynamic currentItem;

  var auctionInfo = {};

  @override
  void initState() {
    currentItem = table[0];
    auctionController.listenLiveAuction(listenAuction: () {
      auctionController.getLiveAuction().then((value) {
        setState(() {
          auctionInfo = value;
          isActive = value["isButtonsActive"];
          fish.setInfo(auctionInfo["currentSeafood"]);
            try {
              latestBidMap = value["bids"][(value["bids"] as Map).keys.last];
              latestBid = latestBidMap?["amount"];
             
            } catch (e) {
              latestBid = 0;
              
            }

            fishName = fish.getproductName();
            quantity = fish.getFishAmount();
            basePrice = fish.getBasePrice();
          
        });
      });
    });
    super.initState();
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
                        label: Text("${auctionInfo["users"]}"),
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
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blueAccent, width: 5)),
                        child: Row(
                          children: [
                            Text(
                              "Current Seafood: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 2,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "$fishName, Quantity: $quantity kg, Base Price: $basePrice",
                              style: TextStyle(
                                  color: Colors.black, height: 2, fontSize: 20),
                            ),
                          ],
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 5)),
                      child: SizedBox(
                        child: Expanded(
                          child: Text(
                            latestBidMap == null
                                ? "There is no bid yet."
                                : "Latest Bid: $latestBid ₺, given by ${getLatestBidGiver()}",
                            style: TextStyle(
                                color: Colors.black, height: 1.5, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: SizedBox(
                      height: 35,
                      width: 300,
                      child: TextButton(
                        child: const Text(
                          'Change Product Flow',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),

                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              alignment: Alignment.bottomCenter,
                              title: const Text('Change Product Flow'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Next Item info:\n'),
                                    Text(willAuctionContinue()
                                        ? getItemInfo(getNextItem())
                                        : "There are no remaining items."),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    child: const Text('Next Item'),
                                    onPressed: () {
                                      //dont allow
                                      Navigator.of(context).pop();
                                      if (latestBid > 0) {
                                        Flushbar(
                                                title:
                                                    "Can't skip to next item!",
                                                message:
                                                    "There was a bid. You should finalise the sold price.",
                                                duration:
                                                    const Duration(seconds: 3))
                                            .show(context);
                                      } else {
                                        if (willAuctionContinue()) {
                                          setState(() {
                                            if (currentItem[4] == 0 &&
                                                !wasSecondRound) {
                                              unsoldsTable.add(currentItem);

                                              Flushbar(
                                                      title:
                                                          "Item was not sold",
                                                      message:
                                                          "Will try again 2nd round.",
                                                      duration: const Duration(
                                                          seconds: 3))
                                                  .show(context);
                                            }
                                            if (table.indexOf(currentItem) ==
                                                table.length - 1) {
                                              currentItem = getNextItem();

                                              wasSecondRound = true;

                                              Flushbar(
                                                      title:
                                                          "Second round started",
                                                      message:
                                                          "Second round started",
                                                      duration: const Duration(
                                                          seconds: 3))
                                                  .show(context);
                                            } else {
                                              currentItem = getNextItem();

                                              if (wasSecondRound) {
                                                latestBid = 0;
                                                j++;
                                              } else {
                                                i++;
                                              }
                                            }
                                            cp.setCurrentFood(currentItem);
                                            
                                          });
                                        } else {
                                          Flushbar(
                                                  title: "Auction Is Finished",
                                                  message:
                                                      "You cannot change the product of finished auction",
                                                  duration: const Duration(
                                                      seconds: 3))
                                              .show(context);
                                        }
                                      }
                                    }),
                              ],
                            ),
                          );
                          //cp.changeProductFlow();
                        },
                        //minWidth: MediaQuery.of(context).size.width - 45,
                        //height: 50
                      ),
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: SizedBox(
                      height: 35,
                      width: 300,
                      child: TextButton(
                        child: const Text(
                          'Change Base Price',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          

                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                      alignment: Alignment.bottomCenter,
                                      title: const Text("Enter your new price"),
                                      titleTextStyle:
                                          const TextStyle(fontSize: 24),
                                      elevation: 10,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              "Previous price: ${getCurrentItemPrice()}"),
                                          TextField(
                                            keyboardType: TextInputType.number,
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
                                                Navigator.of(context).pop;
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
                                              else if (getCurrentItemPrice() >
                                                  int.parse(newPrice)) {
                                                setCurrentItemPrice(newPrice);
                                                Navigator.of(context).pop;
                                                Flushbar(
                                                        title: "Done!",
                                                        message:
                                                            "Product value has been changed! " +
                                                                getItemInfo(
                                                                    currentItem),
                                                        duration:
                                                            const Duration(
                                                                seconds: 3))
                                                    .show(context);
                                              } else {
                                                Navigator.of(context).pop;
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
                                            child: const Text("Cancel"))
                                      ]));
                        },
                        // minWidth: MediaQuery.of(context).size.width - 45,
                        //height: 50
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: SizedBox(
                      height: 35,
                      width: 300,
                      child: TextButton(
                        child: const Text(
                          'Activate/Deactivate Buttons',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.bottomCenter,
                                title: Text((isActive
                                    ? "Deactivate buttons"
                                    : "Activate buttons")),
                                content: Text(isActive
                                    ? "Do you want to deactivate the buttons ?"
                                    : "Do you want to activate the buttons ?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text("Yes"),
                                    onPressed: () {
                                      cp.activateDeactivateButtons(isActive);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        //minWidth: MediaQuery.of(context).size.width - 45,
                        //height: 50
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: SizedBox(
                      height: 35,
                      width: 300,
                      child: TextButton(
                        child: const Text(
                          'Finalise Sold Price',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          
                          currentItem[4] = latestBid;
                          //Navigator.of(context).pop;
                          cp.finaliseSoldPrice(latestBid,currentItem[0]);
                          Flushbar(
                                  title: "Sold Price Set!",
                                  message: "Sold price set for row: " +
                                      getItemInfo(currentItem),
                                  duration: const Duration(seconds: 3))
                              .show(context);
                        },
                        //minWidth: MediaQuery.of(context).size.width - 45,
                        //height: 50
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: SizedBox(
                      height: 35,
                      width: 300,
                      child: TextButton(
                        child: const Text(
                          'Finish Live Auction',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.bottomCenter,
                                title: const Text("Finish Auction"),
                                content: const Text(
                                    "Do you really want to finish this auction ?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text("Yes"),
                                    onPressed: () {
                                      cp.finishLiveAuction(auctionInfo);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        //minWidth: MediaQuery.of(context).size.width - 45,
                        //height: 50
                      ),
                    ))
                  ],
                )
              ])),
    );
  }

  void setCurrentItem(int index, bool fromBaseTable) {
    if (fromBaseTable) {
      currentItem = table[index];
    } else {
      currentItem = table[table.indexOf(unsoldsTable[index])];
    }
  }

  int getCurrentItemPrice() {
    return currentItem[3];
  }

  bool willAuctionContinue() {
    if (wasSecondRound && j == unsoldsTable.length - 1) {
      return false;
    } else {
      return true;
    }
  }

  dynamic getNextItem() {
    if (wasSecondRound) {
      return unsoldsTable[j + 1];
    } else {
      if (i == table.length - 1) {
        return unsoldsTable[0];
      }
      return table[i + 1];
    }
  }

  void setCurrentItemPrice(String newValue) {
    currentItem[3] = int.parse(newValue);
    
  }

  String getItemInfo(dynamic item) {
    return ("Item no: " +
        item[0] +
        " Name: " +
        item[1] +
        " Quantity: " +
        item[2].toString() +
        " Base Price: " +
        item[3].toString() +
        " Sold Price: " +
        item[4].toString());
  }

  String getLatestBidGiver() {
    if (latestBidMap == null) {
      return "null";
    }
    return latestBidMap?["username"];
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
