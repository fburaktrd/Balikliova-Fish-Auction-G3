import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/Views/login_register_page.dart';
import 'package:myapp/Views/update_info.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/coopHead.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/controllers/LandingPageCustomerController.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/widgets/error_page.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<GeneralUser?> snapshot;

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  //TODO -> role göre kullanıcı verisi alınıp provider ile widgetlare pass edilecek (Getit flutter)
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Future.delayed(Duration(milliseconds: 1500)).then((value) => setState(() {
    }));
  }

  @override
  Widget build(BuildContext context) {
    //print("Inside auth widget ${snapshot.data!.role}");
    if (widget.snapshot.hasData) {
      return FutureBuilder(
        builder: (context, userData) {
          if (widget.snapshot.data!.role == "CUSTOMER") {
            //Sayfa yönlendirmeleri.... LandingPageCustomer()..
            return const HomePage();
          } else if (widget.snapshot.data!.role == "Coop Head") {}
          return  MainPage();
        },
        future: getUser(widget.snapshot.data!),
      );
    }
    return  MainPage();
  }

  dynamic getUser(GeneralUser user) async {
    //providing the user instance with getit
    //istek atıldı.
    var res;
    switch (user.role) {
      case "Customer":
        var user = Customer(
            uid: res.uid,
            name: res.name,
            username: res.username,
            phoneNumber: res.phoneNumber,
            address: res.address);
        getIt<LandingPageCustomerController>().fetchCust(user);

        return user;
        //TODO customer node'undan bilgi çekilecek...
        break;
      case "Coop Head":
        break;
    }
  }
}
