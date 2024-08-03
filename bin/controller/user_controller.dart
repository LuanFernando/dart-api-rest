import 'dart:convert';
import 'dart:io';
import '../model/user_model.dart';

class UserController {
  UserModel userModel;
  UserController({required this.userModel});

  static void getAll(HttpRequest request) {
    final response = request.response;
    UserModel().getAll().then((value) {
      if (value.isNotEmpty) {
        response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'message': value}));
        response.close();
      }
    });
  }

  static void getActive(HttpRequest request) {
    final response = request.response;

    response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'message': 'Users getActive'}));
    response.close();
  }

  static void getVip(HttpRequest request) {
    final response = request.response;
    response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'message': 'Users getVip'}));
    response.close();
  }

  static void newUser(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    final data = jsonDecode(content) as Map;

    final response = request.response;

    response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'message': 'POST received newUser', 'data': data}));
    response.close();
  }

  static void auth(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    final data = jsonDecode(content) as Map;
    final response = request.response;

    final returnAuth =
        UserModel().auth({'user': data['user'], 'password': data['password']});

    if (returnAuth['message']!.isNotEmpty) {
      response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'message': returnAuth['message'], 'data': data}));
      response.close();
    }
  }
}
