import 'package:flutter/material.dart';
import 'package:myapp/Views/login_page.dart';
import 'package:myapp/Views/register_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.isLoading = false}) : super(key: key);
  bool? isLoading = false;
  @override
  State<MainPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<StatefulWidget> screens = [];

  final appBarText = ["Login", "Sign Up"];
  @override
  void initState() {
    // TODO: implement initState
    screens = [
      Login(widget.isLoading),
      const SignUp(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      appBar: AppBar(
        title: Text(appBarText[_currentIndex]),
      ),
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
