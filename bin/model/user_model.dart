import 'dart:convert';
import 'dart:io';
import '../entity/user_entity.dart';

class UserModel {
  //
  Map<String, String> auth(Map<String, String> data) {
    Map<String, String> auth = {};
    if (data['user'] == 'admin' && data['password'] == '123456789') {
      auth = {'message': 'usuário autenticado com sucesso'};
    } else {
      auth = {'message': 'usuário ou senha incorretos'};
    }
    return auth;
  }

  Future<List<UserEntity>> getAll() async {
    final file = File('lib/users.json');
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);
    //
    List<dynamic> usersJson = jsonMap['users'];
    List<UserEntity> userEntities = usersJson.map((userJson) {
      return UserEntity.fromJson(userJson);
    }).toList();
    return userEntities;
  }
}
