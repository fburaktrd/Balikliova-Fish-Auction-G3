import 'package:flutter/material.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/Views/login_register_page.dart';
import 'package:myapp/Views/update_info.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/widgets/error_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<GeneralUser?> snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.active) {
      return snapshot.hasData ?  LandingPage(snapshot: snapshot) : const MainPage();
    }
    return const ErrorPage();
  }
}
