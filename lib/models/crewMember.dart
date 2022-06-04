import 'package:myapp/models/user.dart';
class CrewMember extends GeneralUser{
  CrewMember({required String uid, required String name, required String username, required String phoneNumber}) : super(uid: uid, name: name, username: username, phoneNumber: phoneNumber,email:"");
  
}