import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final fullName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  final phoneNumber = TextEditingController();
  final error = TextEditingController();

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
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: TextField(
            controller: fullName,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Full Name"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            controller: username,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "User Name"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            controller: address,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Address"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: TextField(
            controller: phoneNumber,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Phone Number"),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
          child: TextField(
            controller: password,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Password"),
          ),
        ),
        TextButton(
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            String res = await _auth.signUp(
                password: password.text,
                email: username.text,
                name: fullName.text,
                address: address.text,
                phoneNumber: phoneNumber.text);

              showDialog(
              context: context,
              builder: (contex) {
                return AlertDialog(
                  content: Text(res),
                );
              });
          },
        ),
      ],
    );
  }
}

Future signIn(
    context, fullName, password, phoneNumber, address, username) async {
  // showDialog(
  //     context: context,
  //     builder: (contex) {
  //       return AlertDialog(
  //         content: Text("${fullName.text} ${phoneNumber.text} ${username.text} ${address.text} ${password.text}")
  //       );
  //     });
}
