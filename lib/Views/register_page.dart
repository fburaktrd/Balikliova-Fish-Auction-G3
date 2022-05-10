import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/customer.dart';

bool checkAddress(String address) {
  List<String> acceptedAdresses = <String>[
    "MORDOĞAN",
    "BALIKLIOVA",
    "URLA",
    "ILDIR"
  ];

  bool found = false;
  final splitted = address.split(" ");

  for (var i = 0; i < splitted.length; i++) {
    if (acceptedAdresses.contains(splitted[i].toUpperCase())) {
      found = true;
    }
  }
  return found;
}

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
            //Address checking
            bool found = checkAddress(address.text);
            //Address checking

            if (password.text.isEmpty ||
                username.text.isEmpty ||
                fullName.text.isEmpty ||
                address.text.isEmpty ||
                phoneNumber.text.isEmpty) {
              showMessage(context, "Please fill the all input boxes.");
            } else if (found) {
              var  customer = await _auth.signUp(
                  password: password.text,
                  email: username.text,
                  name: fullName.text,
                  address: address.text,
                  phoneNumber: phoneNumber.text);

              if (customer != null) {
                showMessage(context,
                    "You have successfully registered. Welcome ${username.text} !");
              } else {
                // server exception

                showMessage(
                    context, "Something went wrong. Please try again later.");
              }
            } else {
              showMessage(context,
                  "Your address is not in the range.(Addresses that are in the range: Urla,Balıklıova,Mordoğan,Ildır");
            }
          },
        ),
      ],
    );
  }
}

void showMessage(contex, String message) {
  showDialog(
      context: contex,
      builder: (contex) {
        return AlertDialog(
          content: Text(message),
        );
      });
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
