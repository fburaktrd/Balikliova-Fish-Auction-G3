import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';

class Login extends StatefulWidget {
  Login(this.isLoading, {Key? key}) : super(key: key);
  bool? isLoading;
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
        child: buildFormUserName(),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 25),
        child: buildFormPassword(),
      ),
      widget.isLoading == false
          ? TextButton(
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                setState(() {
                  widget.isLoading = true;
                });
                String res = await _auth.login(
                    email: username.text, password: password.text);
              },
            )
          : CircularProgressIndicator(
              color: Colors.red[800],
            ),
    ]);
  }

  Form buildFormPassword() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: (value) {
          return value!.isNotEmpty &
                  value.contains(RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$'))
              ? null
              : "Password must contain minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character (?=.*?[#?!@\$%^&*-])";
        },
        controller: password,
        obscureText: true,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Password'),
      ),
    );
  }

  Form buildFormUserName() {
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
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: "Username"),
      ),
    );
  }
}
