import 'package:flutter/material.dart';
import 'package:myapp/controllers/LandingPageCustomerController.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    var user = getIt<LandingPageCustomerController>().getCustomer;
    String? name;
    if (user != null) {
      name = user.username;
    } else {
      name = "";
    }
    //getIt<LandingPageCustomerController>().getCustomer; user'ı alıyoruz.
    return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
        body: Center(
            child: MaterialButton(
                onPressed: () {
                  _authService.signOut();
                  print("Logged out");
                },
                color: Colors.blue[300],
                child: Text("Log out ${name}",
                    style: Theme.of(context).textTheme.bodyLarge))));
  }
}
