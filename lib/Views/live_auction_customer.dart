import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/controllers/UserController.dart';
import 'package:myapp/controllers/auctionController.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/models/seafood.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'navBar.dart';

class LiveAuctionCustomer extends StatefulWidget {
  const LiveAuctionCustomer({Key? key}) : super(key: key);
  @override
  State<LiveAuctionCustomer> createState() => _LiveAuctionCustomerState();
}

Seafood fish = new Seafood(
    id: "0", productName: "Loading...", basePrice: 10, latestBid: 0, amount: 0);
double counter = fish.getBasePrice();

class _LiveAuctionCustomerState extends State<LiveAuctionCustomer> {
  int _currentStep = 0;
  var user = (getIt<UserController>().getUser as Customer);
  double latestBid = fish.getLatestBid();
  String fishName = fish.getproductName();
  double quantity = fish.getFishAmount();
  double basePrice = fish.getBasePrice();
  Map? latestBidMap;
  AuctionController auctionController = AuctionController();
  var auctionInfo = {};
  bool isFinished = false;
  //final CountdownController countdownController = new CountdownController(autoStart: true);

  TextEditingController _controller = TextEditingController(
    text: counter.toString(),
  );

  final YoutubePlayerController _YTcontroller = YoutubePlayerController(
    initialVideoId: 'vq3IvvNe7VY',
    params: const YoutubePlayerParams(
      startAt: Duration(seconds: 0),
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  @override
  void initState() {
    auctionController.listenLiveAuction(listenAuction: () {
      auctionController.getLiveAuction().then((value) {
        setState(() {
          auctionInfo = value;
          if (auctionInfo.isEmpty) {
            isFinished = true;
          } else {
            fish.setInfo(auctionInfo["currentSeafood"]);
            try {
              latestBidMap = value["bids"][(value["bids"] as Map).keys.last];
              latestBid = latestBidMap?["amount"];
              counter = latestBid;
              _controller.text = latestBid.toString();
            } catch (e) {
              latestBid = 0;
              counter = fish.getBasePrice();
              _controller.text = fish.getBasePrice().toString();
            }

            fishName = fish.getproductName();
            quantity = fish.getFishAmount();
            basePrice = fish.getBasePrice();
          }
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
        appBar: AppBar(title: const Text("Live Auction")),
        resizeToAvoidBottomInset: false,
        drawer: const navBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Builder(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: isFinished ? <Widget>[Center(
                    child:  AlertDialog(
                            title: new Text("Auction is finished."),
                            content: new Text("You have to return to home page."),
                            actions: <Widget>[
                              new ElevatedButton(
                                child: new Text("Return Home"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => const HomePage()));
                                },
                              ),
                            ],
                          ),
                  ),] : <Widget>[
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_back_sharp),
                          label: Text("Leave"),
                          onPressed: () {
                            user.leaveAuction();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shadowColor: Colors.white,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 10, height: 3),
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
                          label: Text("${auctionInfo["usersCount"]}"),
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: (MediaQuery.of(context).size.height) / 2.5,
                          width: (MediaQuery.of(context).size.width),
                          child: YoutubePlayerIFrame(
                            controller: _YTcontroller,
                            aspectRatio: 3 / 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Current Seafood",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 2,
                                fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                        height: 10,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Seafood: $fishName",
                                style: TextStyle(
                                    color: Colors.black,
                                    height: 2,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Quantity: $quantity kg",
                                style: TextStyle(
                                    color: Colors.black,
                                    height: 2,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Base Price: $basePrice ₺",
                                style: TextStyle(
                                    color: Colors.black,
                                    height: 2,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(12.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 5)),
                                child: SizedBox(
                                  child: Expanded(
                                    child: Text(
                                      latestBidMap == null
                                          ? "There is no bid yet."
                                          : "Latest Bid: $latestBid ₺, given by ${getLatestBidGiver()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          height: 1.5,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              /* ElevatedButton(
                                onPressed: onEnd,
                                child: Wrap(
                                  children: <Widget>[
                                    Icon(
                                      Icons.refresh,
                                      size: 24.0,
                                    ),
                                    Countdown(
                                      controller: countdownController,
                                      seconds: 9, //update time
                                      build: (_, double time) => Text(
                                        time.toStringAsPrecision(1),
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      interval: Duration(seconds: 1),
                                      onFinished: () {
                                        onEnd();
                                      },
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => setState(() => decreaseCounter()),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      SizedBox(
                        width: 60,
                        height: 50,
                        child: TextField(
                          autofocus: false,
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(
                              () {
                                setCounter(_controller.value.text);
                              },
                            );
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 6.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 6.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      FloatingActionButton(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => setState(() => increaseCounter()),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      new ElevatedButton.icon(
                        icon: Icon(Icons.local_offer_sharp),
                        label: Text("Make Bid"),
                        onPressed: isButtonActived() ? makeBidClicked : null,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  liveStreamFinished() {
    displayMessage("Live Stream Ended", context,
        "Live stream ended. Thank you for joining us!");
  }

  Widget buildItem(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return page;
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.blue,
        width: double.infinity,
        alignment: Alignment.center,
        height: 100,
        child: Text(
          title,
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  setCounter(String value) {
    double bid = double.parse(value);
    value = bid.toStringAsFixed(2);
    counter = double.parse(value);
  }

  decreaseCounter() {
    counter = counter - 1;
    this._controller = new TextEditingController(
      text: "$counter",
    );
  }

  increaseCounter() {
    counter = counter + 1;
    this._controller = new TextEditingController(
      text: "$counter",
    );
  }

  String getLatestBidGiver() {
    if (latestBidMap == null) {
      return "null";
    }
    return latestBidMap?["username"];
  }

  onEnd() {
    //10 saniyede bir databaseden yeni bid var mı diye çekmesi gerek
    //countdownController.restart();

    setState(() {});
  }

  bool checkBid() {
    if (counter > fish.latestBid) {
      return true;
    } else {
      return false;
    }
  }

  String getVideoID() {
    return "vq3IvvNe7VY";
  }

  void makeBid(double bid) {
    user.makeBid(bid, fish.id);
    fish.setLatestBid(bid);
    onEnd();
  }

  int getLiveUserCount() {
    return 10;
  }

  bool isButtonActived() {
    return auctionInfo["isButtonsActive"];
  }

  void makeBidClicked() {
    if (checkBid()) {
      makeBid(counter);
      setState(() {});
    } else {
      displayMessage("Invalid Bid", context,
          "You can not make bid lower than or equal to current bid.");
      setState(() {});
    }
  }

  void displayMessage(String title, BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("${title}"),
          content: new Text("${message}."),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
