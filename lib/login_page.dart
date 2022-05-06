import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Image.asset("assets/balikova.PNG"),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25, left: 50, right: 50),
        child: TextField(
          decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: "Email"),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Password'),
        ),
      ),
      TextButton(
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {},
      ),
    ]);
  }
}
