class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? home;
  String? logtime;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.home,
      this.logtime});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    home = json['home'];
    logtime = json['logtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['home'] = home;
    data['logtime'] = logtime;
    return data;
  }
}
