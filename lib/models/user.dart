class GeneralUser {
  final String uid;
  String? name;
  String username;
  String? phoneNumber;
  String? role;

  //ROLES: CUSTOMER, COOP_HEAD, COOP_CREW, COOP_CREW_MEMBER
  
  GeneralUser({
    required this.uid,
    required this.username,
    required String email,
    this.name,
    this.phoneNumber,
    this.role
  });

  
}
