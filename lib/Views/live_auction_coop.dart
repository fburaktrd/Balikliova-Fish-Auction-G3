import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'navBar.dart';

class LiveAuctionCoop extends StatefulWidget {
  const LiveAuctionCoop({Key? key}) : super(key: key);

  @override
  State<LiveAuctionCoop> createState() => _LiveAuctionCoopState();
}

class _LiveAuctionCoopState extends State<LiveAuctionCoop> {
  
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'vq3IvvNe7VY',
    params: YoutubePlayerParams (
      startAt: Duration(seconds: 0),
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  
  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      alignment: Alignment.topRight,
                      height: (MediaQuery.of(context).size.height) / 2,
                      width: MediaQuery.of(context).size.width - 45,
                      child: YoutubePlayerIFrame(
                        controller: _controller,
                        aspectRatio: 3/2,
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
                            onPressed: () {},
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
                              'Change Base Price',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
                            minWidth: MediaQuery.of(context).size.width - 45,
                            height: 50))
                  ],
                )
              ])),
    );
  }
}
