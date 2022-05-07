import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Icon(
              Icons.upload,
              size: 100,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Full Name"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "User Name"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Address"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Phone Number"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Password"),
          ),
        ),
        TextButton(
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
