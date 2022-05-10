import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<GeneralUser?> snapshot;
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    String? name;
    if (snapshot.hasData) {
      name = snapshot.data!.username;
    } else {
      name = "";
    }
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
