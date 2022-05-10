import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: const Text("Home Page")),
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
