class ModalUser {
  String? userName;
  String? email;
  String? password;

  ModalUser(
      {required this.userName, required this.email, required this.password});

  bool get validation =>
      email != null &&
      password != null &&
      email!.isNotEmpty &&
      password!.isNotEmpty;
}
