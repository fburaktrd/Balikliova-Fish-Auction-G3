import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';

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
          child: buildFormFullName(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: buildUserName(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: buildFormAdress(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
          child: buildFormPhoneNumber(),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
          child: buildFormPassword(),
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
              var customer = await _auth.signUp(
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

  Form buildFormAdress() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return value!.isNotEmpty &&
                checkAddress(value)
              ? null
              : "Your address is not in the range.(Addresses that are in the range: Urla,Balıklıova,Mordoğan,Ildır).";
        },
        controller: address,
        keyboardType: TextInputType.streetAddress,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Address"),
      ),
    );
  }

  Form buildUserName() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return value!.isNotEmpty &
                  value.contains(RegExp(r'^(?=.{8,20}$)[a-zA-Z0-9._]+$'))
              ? null
              : "Invalid User Name. Username should be 8-20 characters long and should only contain letters, numbers, underscore(_) or a dot (.)";
        },
        controller: username,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "User Name"),
      ),
    );
  }

  Form buildFormFullName() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return value!.isNotEmpty &
                  value.contains(RegExp(r'^[a-zA-Z ğüşöçİĞÜŞÖÇı]+$'))
              ? null
              : "Invalid Full Name. Your should be consists of letters (A-Z). Turkish characters are supported";
        },
        controller: fullName,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Full Name"),
      ),
    );
  }

  Form buildFormPhoneNumber() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return value!.isNotEmpty & value.contains(RegExp(r'^[0-9]{10}$'))
              ? null
              : "Invalid phone number. Example: 5386491750";
        },
        controller: phoneNumber,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Phone Number"),
      ),
    );
  }

  Form buildFormPassword() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return (value!.isNotEmpty &&
                  value.length < 6)
              ? "Password must contain minimum six characters."
              : null;
        },
        obscureText: true,
        controller: password,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Password"),
      ),
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
