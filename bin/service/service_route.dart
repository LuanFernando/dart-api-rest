import 'dart:convert';
import 'dart:io';
import '../controller/user_controller.dart';

class ServiceRoute {
  late String _path;
  late String _method;
  final String _prefix = '/api';
  late String _route;

  late HttpRequest request;
  late HttpResponse response;
  ServiceRoute({required this.request, required this.response}) {
    _method = request.method;
  }

  void handleRequest() {
    final prefix = _validatePrefix();
    // Prefix inválido retorna mensagem de erro
    if (!prefix) {
      response
        ..statusCode = HttpStatus.badRequest
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'message': 'prefix inválido'}));
      response.close();
      return;
    }
    // Redireciona para as rotas mapeadas
    _router();
  }

  // Valida se o prefix /api é encontrado na uri.path da requisição
  bool _validatePrefix() {
    _path = request.uri.path;
    if (_path.startsWith(_prefix)) {
      // Armazena parte da path se o prefixo
      _route = _path.replaceFirst(_prefix, '');
      return true;
    }
    return false;
  }

  //
  void _router() {
    switch (_method) {
      case 'GET':
        _get();
        break;
      case 'POST':
        _post();
        break;
      case 'PUT':
        _put();
        break;
      case 'DELETE':
        _delete();
        break;
      default:
        _notFound();
    }
  }

  // GET
  // route , function
  void _get() {
    Map<String, Function> _routerGet = {
      '/users': UserController.getAll,
      '/users/active': UserController.getActive,
      '/users/vip': UserController.getVip
    };

    if (_routerGet.containsKey(_route)) {
      _routerGet[_route]!(request);
    } else {
      _notFound();
    }
  }

  // POST
  // route , function
  void _post() {
    Map<String, Function> _routerPost = {
      '/users/new': UserController.newUser,
      '/users/auth': UserController.auth
    };
    if (_routerPost.containsKey(_route)) {
      _routerPost[_route]!(request);
    } else {
      _notFound();
    }
  }

  // PUT
  void _put() {}
  // DELETE
  void _delete() {}

  // NOT FOUND
  void _notFound() {
    final response = request.response;
    response
      ..statusCode = HttpStatus.notFound
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'message': 'Not found'}));
    response.close();
  }
}
