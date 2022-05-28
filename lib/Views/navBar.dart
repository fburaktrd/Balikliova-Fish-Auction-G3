import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:myapp/Views/auctionTableScreen.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/Views/update_info.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/database.dart';

import 'AuctionTablePage.dart';
import 'package:myapp/controllers//CoopHeadController.dart';

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

  @override
  Widget build(BuildContext context) {
    checkUserTypes();
    return Container(
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
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10,
                                    height: 12,
                                  ),
                                  Text(
                                    getName(),
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  Text(
                                    getUserType(),
                                    style: TextStyle(fontSize: 18),
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
                            leading: Icon(Icons.arrow_forward_ios_rounded),
                            horizontalTitleGap: 1,
                            title: Text('Join Live Auction'),
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
                            leading: Icon(Icons.flag_rounded),
                            horizontalTitleGap: 1,
                            title: Text('Start Live Auction'),
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
                            leading: Icon(Icons.create_new_folder_rounded),
                            horizontalTitleGap: 1,
                            title: Text('Create Auction Table'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AuctionTableScreen())); // olamlı
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopHead,
                          child: ListTile(
                            //if user is coop head, views all auction tables
                            leading: Icon(Icons.view_comfortable_sharp),
                            horizontalTitleGap: 1,
                            title: Text('View Auction Tables'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage())); //AuctionTableScreen()
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopMember,
                          child: ListTile(
                            //if user is coop member
                            leading: Icon(Icons.payments_outlined),
                            horizontalTitleGap: 1,
                            title: Text('Payrolls'),
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
                            leading: Icon(Icons.double_arrow_outlined),
                            horizontalTitleGap: 1,
                            title: Text('Enter Live Auction'),
                            onTap: () {
                              // Update the state of the app
                              // ...
                              // Then close the drawer
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Visibility(
                          visible: _coopMember | _coopCrew | _customer,
                          child: ListTile(
                            // if user is coop member, coop crew, customer
                            leading: Icon(Icons.view_day),
                            horizontalTitleGap: 1,
                            title: Text('View Auction Table'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage())); //AuctionTableScreen()
                            },
                          ),
                        ),
                        Visibility(
                          // if user is customer
                          visible: _customer,
                          child: ListTile(
                            leading: Icon(Icons.point_of_sale),
                            horizontalTitleGap: 1,
                            title: Text('Order Information'),
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
                            leading: Icon(Icons.delivery_dining),
                            horizontalTitleGap: 1,
                            title: Text('Delivery Information'),
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
                            leading: Icon(Icons.person),
                            horizontalTitleGap: 1,
                            title: Text('Profile Settings'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InformationScreen()));
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
                            Divider(),
                            Visibility(
                              visible: true,
                              child: ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Log Out'),
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
                  ),
                  Visibility(
                    visible: _coopCrew | _coopMember,
                    //if user is coop crew
                    child: ListTile(
                      leading: Icon(Icons.arrow_forward_ios_rounded),
                      horizontalTitleGap: 1,
                      title: Text('Join Live Auction'),
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
                      leading: Icon(Icons.flag_rounded),
                      horizontalTitleGap: 1,
                      title: Text('Start Live Auction'),
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
                      leading: Icon(Icons.create_new_folder_rounded),
                      horizontalTitleGap: 1,
                      title: Text('Create Auction Table'),
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
                      //if user is coop head, views all auction tables
                      leading: Icon(Icons.view_comfortable_sharp),
                      horizontalTitleGap: 1,
                      title: Text('View Auction Tables'),
                      onTap: () {
                        setState() {
                          CoopHeadController().viewAuctionTables();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: _coopMember,
                    child: ListTile(
                      //if user is coop member
                      leading: Icon(Icons.payments_outlined),
                      horizontalTitleGap: 1,
                      title: Text('Payrolls'),
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
                      leading: Icon(Icons.double_arrow_outlined),
                      horizontalTitleGap: 1,
                      title: Text('Enter Live Auction'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: _coopMember | _coopCrew | _customer,
                    child: ListTile(
                      // if user is coop member, coop crew, customer
                      leading: Icon(Icons.view_day),
                      horizontalTitleGap: 1,
                      title: Text('View Auction Table'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: _coopMember | _coopCrew | _customer,
                    child: ListTile(
                      // if user is coop member, coop crew, customer
                      leading: Icon(Icons.view_day),
                      horizontalTitleGap: 1,
                      title: Text('View Auction Table'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    // if user is customer
                    visible: _customer,
                    child: ListTile(
                      leading: Icon(Icons.point_of_sale),
                      horizontalTitleGap: 1,
                      title: Text('Order Information'),
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
                      leading: Icon(Icons.delivery_dining),
                      horizontalTitleGap: 1,
                      title: Text('Delivery Information'),
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
                      leading: Icon(Icons.person),
                      horizontalTitleGap: 1,
                      title: Text('Profile Settings'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ),
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
