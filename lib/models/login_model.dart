class LoginModel {
  String? usernameOrEmail;
  String? password;
  LoginModel({this.usernameOrEmail, this.password});

  Map<String, dynamic> toJson() {
    return {'usernameOrEmail': usernameOrEmail, 'password': password};
  }
}
