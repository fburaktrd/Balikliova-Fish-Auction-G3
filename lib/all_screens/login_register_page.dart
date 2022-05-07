import 'package:flutter/material.dart';
import 'package:myapp/all_screens/login_page.dart';
import 'package:myapp/all_screens/register_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<StatefulWidget> screens = [
    const Login(),
    const SignUp(),
  ];

  final appBarText = ["Login", "Sign Up"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      appBar: AppBar(
        title: Text(appBarText[_currentIndex]),
      ),
      drawer: const Drawer(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedFontSize: 20,
        unselectedFontSize: 20,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Text(""), label: "Log In", backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Text(""), label: "Sign Up", backgroundColor: Colors.blue),
        ],
      ),
    );
  }
}
