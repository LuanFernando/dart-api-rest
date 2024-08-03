import 'dart:io';
import 'service/service_route.dart';

void main() async {
  final IP = InternetAddress.anyIPv4;
  final server = await HttpServer.bind(IP, 8888);
  print("Server listening on port ${server.port}");

  await for (HttpRequest request in server) {
    final response = request.response;
    final serviceRoute = ServiceRoute(request: request, response: response);
    serviceRoute.handleRequest();
  }
}
