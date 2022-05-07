class GeneralUser {
  final String uid;
  
  GeneralUser({ required this.uid });

}

class GeneralUserData{
  final String uid;
  String name;
  String surname;
  String username;
  String password;
  String phoneNumber;

  GeneralUserData({ required this.uid,
                    required this.name,
                    required this.surname, 
                    required this.username, 
                    required this.password, 
                    required this.phoneNumber});
}