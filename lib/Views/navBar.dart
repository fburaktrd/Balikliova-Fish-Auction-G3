import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/AuctionTablePageForCoopHead.dart';
import 'package:myapp/Views/updateAuctionTable.dart';
import 'package:myapp/Views/CreateAuctionTablePage.dart';
import 'package:myapp/Views/live_auction_coop.dart';
import 'package:myapp/Views/update_info.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/database.dart';

import 'package:myapp/Views/AuctionTableForCrew.dart';
import 'package:myapp/Views/AuctionTableForCustomerMember.dart';

//import 'package:another_flushbar/flushbar.dart';

import 'CreateAuctionTablePage.dart';

class navBar extends StatefulWidget {
  const navBar({Key? key}) : super(key: key);

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  bool _customer = false;
  bool _coopMember = false;
  bool _coopHead = false;
  bool _coopCrew = false;
  bool _crewMember = false;
  bool loading = true;
  var userInfo;

  @override
  void initState() {
    // TODO: implement initState
    Database()
        .ref
        .child("Roles")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      Database()
          .ref
          .child(res.value == "CUSTOMER" ? "Customer" : "Cooperative_Head")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((userRes) {
        userInfo = userRes.value;
        print(FirebaseAuth.instance.currentUser!.uid);
        checkUserTypes();
        print(_coopHead);
        setState(() {
          loading = false;
          print(userInfo);
        });
      });
    });
    super.initState();
  }

  double toDouble(TimeOfDay givenTime) =>
      givenTime.hour + givenTime.minute / 60.0;

  String timeToString(TimeOfDay givenTime) =>
      givenTime.hour.toString() + ":" + givenTime.minute.toString();
  @override
  Widget build(BuildContext context) {
    checkUserTypes();
    return SizedBox(
      width: 250,
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        child: (loading == true
            ? const CircularProgressIndicator(color: Colors.blue)
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: 135,
                          width: 250,
                          child: DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                    height: 12,
                                  ),
                                  Text(
                                    getName(),
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  Text(
                                    getUserType(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _coopCrew | _coopMember,
                          //if user is coop crew
                          child: ListTile(
                            leading:
                                const Icon(Icons.arrow_forward_ios_rounded),
                            horizontalTitleGap: 1,
                            title: const Text('Join Live Auction'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopHead,
                          child: ListTile(
                            //if user is coop head
                            leading: const Icon(Icons.flag_rounded),
                            horizontalTitleGap: 1,
                            title: const Text('Start Live Auction'),
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      helpText: "Current Time: " +
                                          timeToString(TimeOfDay.now()),
                                      initialTime: TimeOfDay.now())
                                  .then((value) => {
                                        if (value != null)
                                          {
                                            if (toDouble(TimeOfDay.now()) <
                                                toDouble(value))
                                              {
                                                Navigator.pop(context),
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const LiveAuctionCoop()))
                                              }
                                            else
                                              {
                                                Flushbar(
                                                        title:
                                                            "Past Time Error",
                                                        message:
                                                            "Please choose a future time",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3))
                                                    .show(context)
                                              }
                                          }
                                      })
                                  .catchError((onError) {
                                //TODO pop-up snackbar//
                                /*
                                Flushbar(
                                        title: "Error while setting time",
                                        message: "Please try again.",
                                        duration: const Duration(seconds: 3))
                                    .show(context);
                                    */
                              });
                            },
                          ),
                        ),
                        //Visibility(
                        //  visible: _coopHead,
                        //  child: ListTile(
                        //    //if user is coop head
                        //    leading: Icon(Icons.flag_rounded),
                        //    horizontalTitleGap: 1,
                        //    title: Text('Start Live Auction'),
                        //    onTap: () {
                        //      Navigator.pop(context);
                        //      Navigator.of(context).push(MaterialPageRoute(
                        //          builder: (BuildContext context) =>
                        //              LiveAuctionCoop()));
                        //      // Update the state of the app
                        //      // ...
                        //      // Then close the drawer
                        //    },
                        //  ),
                        //),
                        Visibility(
                          visible: _coopHead,
                          child: ListTile(
                            //if user is coop head
                            leading:
                                const Icon(Icons.create_new_folder_rounded),
                            horizontalTitleGap: 1,
                            title: const Text('Create Auction Table'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CreateAuctionTableScreen())); // olamlı
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopHead,
                          child: ListTile(
                            //if user is coop head, views all auction tables
                            leading: const Icon(Icons.view_comfortable_sharp),
                            horizontalTitleGap: 1,
                            title: const Text('View Auction Tables'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewAuctionTableCoopHead())); //AuctionTableScreen()
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopMember,
                          child: ListTile(
                            //if user is coop member
                            leading: const Icon(Icons.payments_outlined),
                            horizontalTitleGap: 1,
                            title: const Text('Payrolls'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _customer,
                          child: ListTile(
                            leading: const Icon(Icons.double_arrow_outlined),
                            horizontalTitleGap: 1,
                            title: const Text('Enter Live Auction'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopMember | _customer,
                          child: ListTile(
                            // if user is coop member, coop crew, customer
                            leading: const Icon(Icons.view_day),
                            horizontalTitleGap: 1,
                            title: const Text('View Auction Table'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewAuctionTableCustomerMember())); //AuctionTableScreen()
                            },
                          ),
                        ),
                        Visibility(
                          visible: _crewMember,
                          child: ListTile(
                            // if user is coop member, coop crew, customer
                            leading: const Icon(Icons.view_day),
                            horizontalTitleGap: 1,
                            title: const Text('View Auction Table'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewAuctionTableCrew())); //AuctionTableScreen()
                            },
                          ),
                        ),
                        Visibility(
                          // if user is customer
                          visible: _customer,
                          child: ListTile(
                            leading: const Icon(Icons.point_of_sale),
                            horizontalTitleGap: 1,
                            title: const Text('Order Information'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopCrew,
                          child: ListTile(
                            //if user is coop crew
                            leading: const Icon(Icons.delivery_dining),
                            horizontalTitleGap: 1,
                            title: const Text('Delivery Information'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: ListTile(
                            // for everyone
                            leading: const Icon(Icons.person),
                            horizontalTitleGap: 1,
                            title: const Text('Profile Settings'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const InformationScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: [
                            const Divider(),
                            Visibility(
                              visible: true,
                              child: ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Log Out'),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  // Then close the drawer
                                  AuthService().signOut();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
      ),
    );
  }

  void checkUserTypes() {
    if (checkUserTypeCustomer()) {
      _customer = true;
      _coopMember = false;
      _coopHead = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCoopCrew()) {
      _coopCrew = true;
      _customer = false;
      _coopMember = false;
      _coopHead = false;
      _crewMember = false;
    } else if (checkUserTypeCoopHead()) {
      _coopHead = true;
      _customer = false;
      _coopMember = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCoopMember()) {
      _coopMember = true;
      _customer = false;
      _coopHead = false;
      _coopCrew = false;
      _crewMember = false;
    } else if (checkUserTypeCrewMember()) {
      _crewMember = true;
      _customer = false;
      _coopMember = false;
      _coopHead = false;
      _coopCrew = false;
    }
  }

  String getName() {
    return (userInfo != null ? userInfo["name"] : "");
  }

  String getUserType() {
    // return "COOP_HEAD";
    return (userInfo != null ? userInfo["role"] : "");
  }

  bool checkUserType(String userType) {
    if (getUserType() == userType) {
      return true;
    } else {
      return false;
    }
  }

  bool checkUserTypeCustomer() {
    return checkUserType("CUSTOMER");
  }

  bool checkUserTypeCoopHead() {
    return checkUserType("COOP_HEAD");
  }

  bool checkUserTypeCoopCrew() {
    return checkUserType("Cooperative Crew");
  }

  bool checkUserTypeCoopMember() {
    return checkUserType("Cooperative Member");
  }

  bool checkUserTypeCrewMember() {
    return checkUserType("Crew Member");
  }
}
