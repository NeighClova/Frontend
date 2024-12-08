class LoginModel {
  final String email;
  final String password;

  LoginModel(this.email, this.password);

  LoginModel.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      password = json['password'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class EmailCheckModel {
  final String email;

  EmailCheckModel(this.email);

  EmailCheckModel.fromJson(Map<String, dynamic> json)
    : email = json['email'];

  Map<String, dynamic> toJson() => {
    'email' : email,
  };
}

class EmailCertificationModel {
  final String email;

  EmailCertificationModel(this.email);

  EmailCertificationModel.fromJson(Map<String, dynamic> json)
    : email = json['email'];

  Map<String, dynamic> toJson() => {
    'email' : email,
  };
}