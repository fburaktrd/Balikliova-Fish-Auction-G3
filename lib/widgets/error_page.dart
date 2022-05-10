import 'package:flutter/material.dart';


class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Something went wrong..")),
    );
  }
}