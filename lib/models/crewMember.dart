import 'package:myapp/models/user.dart';
class CrewMember extends GeneralUserData{
  CrewMember({required String uid, required String name, required String surname, required String username, required String password, required String phoneNumber}) : super(uid: uid, name: name, surname: surname, username: username, password: password, phoneNumber: phoneNumber);
  
}