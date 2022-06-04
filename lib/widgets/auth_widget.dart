import 'package:flutter/material.dart';
import 'package:myapp/Views/home_page.dart';
import 'package:myapp/Views/login_register_page.dart';
import 'package:myapp/locator.dart';
import 'package:myapp/models/coopHead.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/controllers/UserController.dart';
import 'package:myapp/models/database.dart';
import 'package:myapp/models/user.dart';

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

    Future.delayed(const Duration(milliseconds: 1000))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    //print("Inside auth widget ${snapshot.data!.role}");
    if (widget.snapshot.hasData) {
      return FutureBuilder(
        builder: (context, userData) {
          if (widget.snapshot.data!.role == "CUSTOMER") {
            //Sayfa yönlendirmeleri.... User()..
            return const HomePage();
          } else if (widget.snapshot.data!.role == "COOP_HEAD") {
            return const HomePage();
          }
          return MainPage(isLoading: false);
        },
        future: getUser(widget.snapshot.data!),
      );
    }
    return MainPage();
  }

  dynamic getUser(GeneralUser user) async {
    //providing the user instance with getit
    //istek atıldı.
    var res;
    var inScopeUser = user.uid;
    switch (user.role) {
      case "CUSTOMER":
        res = await Database().ref.child("Customer").child(inScopeUser).get();
        res = res.value;
        var user = Customer(
            email:res["email"],
            uid: res["uid"],
            name: res["name"],
            username: res["username"],
            phoneNumber: res["phoneNumber"],
            address: res["address"]);
        getIt<UserController>().fetchCust(user);

        return user;
      //TODO customer node'undan bilgi çekilecek...

      case "COOP_HEAD":
        res = await Database().ref.child("Cooperative_Head").child(inScopeUser).get();
        res = res.value;
         var user = CoopHead(
           email:res["email"],
            uid: res["uid"],
            name: res["name"],
            username: res["username"],
            phoneNumber: res["phoneNumber"]);
        getIt<UserController>().fetchCust(user);
        return user;
        
    }
  }
}
