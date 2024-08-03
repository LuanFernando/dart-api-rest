// Json to dart : https://javiercbk.github.io/json_to_dart/
class UserEntity {
  int? id;
  String? name;
  String? user;
  String? password;

  UserEntity({this.id, this.name, this.user, this.password});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    user = json['user'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user'] = this.user;
    data['password'] = this.password;
    return data;
  }
}
