import 'package:flutter/material.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.onPageBuilder})
      : super(key: key);
  final Widget Function(
      BuildContext context, AsyncSnapshot<GeneralUser?> snapshot) onPageBuilder;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<GeneralUser?>(
      stream: _authService.onAuthStateChanged,
      builder: (context, AsyncSnapshot<GeneralUser?> snapShot) {
        final _userData = snapShot.data;
        if (_userData != null) {
          return MultiProvider(
              providers: [
                Provider.value(value: _userData),
              ], child: onPageBuilder(context, snapShot));
        } else {
          return onPageBuilder(context, snapShot);
        }
      },
    );
  }
}
