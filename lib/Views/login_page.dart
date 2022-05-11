import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final username = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Image.asset("assets/balikova.PNG"),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25, left: 50, right: 50),
        child: TextField(
          controller: username,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Username"),
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
        child: TextField(
          controller: password,
          obscureText: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Password'),
        ),
      ),
      TextButton(
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          String res =
              await _auth.login(email: username.text, password: password.text);
              // showDialog(
              // context: context,
              // builder: (contex) {
              //   return AlertDialog(
              //     content: Text(res),
              //   );
              // });
        },
      ),
    ]);
  }
}
