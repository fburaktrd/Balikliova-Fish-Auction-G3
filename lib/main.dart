import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/controllers/authService.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/widgets/auth_widget.dart';
import 'package:myapp/widgets/auth_widget_builder.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setupLocators();
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthService(),
        )
      ],
      child: AuthWidgetBuilder(
        onPageBuilder: (context, AsyncSnapshot<GeneralUser?> snapShot) =>
            MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthWidget(snapshot: snapShot),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData.light(),
  //     home: const AuctionTableScreen(),
  //   );
  // }
}
