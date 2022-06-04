import 'package:flutter/material.dart';
import 'package:myapp/Views/navBar.dart';
import 'package:myapp/controllers/UserController.dart';
import 'package:myapp/controllers/auctionController.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/locator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    //AuctionController().getCurrentAuctionTableAsList();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    var user = getIt<UserController>().getUser;
    String? name;
    if (user != null) {
      name = user.username;
    } else {
      name = "";
    }
    //getIt<LandingPageCustomerController>().getCustomer; user'ı alıyoruz.
    return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        drawer: const navBar(),
        body: Center(
            child: MaterialButton(
                onPressed: () {
                  _authService.signOut();
                  print("Logged out");
                },
                color: Colors.blue[300],
                child: Text("Log out",
                    style: Theme.of(context).textTheme.bodyLarge))));
  }
}
