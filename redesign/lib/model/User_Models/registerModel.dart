class RegisterModel {
  String name;
  String email;
  String password;

  RegisterModel({this.name = '', this.email = '', this.password = ''});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}
