import 'dart:convert';
import 'dart:io';
import 'package:dart_api_rest/keys.dart';
import 'package:http/http.dart' as http;

class AiGeminiController {
  // Gemini calculadora
  static void geminiCalc(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    final data = jsonDecode(content) as Map;
    final response = request.response;

    final responseGemini =
        // ignore: prefer_interpolation_to_compose_strings
        await fetchGeminiAIResponse('Calcule os valores: ' + data['prompt']);

    if (responseGemini.isNotEmpty) {
      response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'response': responseGemini}));
      response.close();
    } else {
      response
        ..statusCode = HttpStatus.internalServerError
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'response': 'Falha na requisição'}));
      response.close();
    }
  }

  // Chatbot Gemini
  static void geminiChat(HttpRequest request) async {
    // Adicionando cabeçalhos CORS
    request.response.headers
        .add('Access-Control-Allow-Origin', '*'); // Permitir todas as origens
    request.response.headers.add('Access-Control-Allow-Methods',
        'GET, POST, OPTIONS'); // Métodos permitidos
    request.response.headers.add('Access-Control-Allow-Headers',
        'Content-Type'); // Cabeçalhos permitidos

    // Verificar se a requisição é uma preflight request (OPTIONS)
    if (request.method == 'OPTIONS') {
      // Responder imediatamente para requisições OPTIONS
      request.response
        ..statusCode = HttpStatus.ok
        ..close();
      return;
    }

    final content = await utf8.decoder.bind(request).join();
    final data = jsonDecode(content) as Map;
    final response = request.response;
    final responseGemini = await fetchGeminiAIResponse(data['prompt']);

    if (responseGemini.isNotEmpty) {
      response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'response': responseGemini}));
      response.close();
    } else {
      response
        ..statusCode = HttpStatus.internalServerError
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'response': 'Falha na requisição'}));
      response.close();
    }
  }

  static Future<String> fetchGeminiAIResponse(String prompt) async {
    // Caminho da imagem que será codificada
    final imgPath = './img/images3.jpg';

    // Lendo a imagem e convertendo para Base64
    final bytes = await File(imgPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    // Corpo da requisição
    final body = jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': "${prompt}"},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image,
              }
            }
          ]
        },
        {
          'role': 'model',
          'parts': [
            {
              'text':
                  "Sou um nutricionista, especializado exclusivamente e dar sugestões de dietas para atetlas de alta performace. Respondo apenas com sugestões. Exemplo: 'Suco de laranja com 1 laranja , 1 copo de agua gelada e açucar; 1 abacate e 1 banana picamos e fazemos uma salada de fruta. Para qualquer pergunta que não seja sobre informática, responderei apenas: 'Eu posso te ajudar apenas com sugestões de dietas.'.' "
              // "Sou um atendende de suporte de uma soft house, especializado exclusicamente em dúvidas sobre informática. Respondo apenas com o sugestões. Exemplos: 'Reinicie o seu computador; Atualize o software. Para qualquer pergunta que não seja sobre informática, responderei apenas: 'Eu não posso te ajudar com isso.'. "
            }
          ]
        }
      ],
    });

    try {
      final response = await http.post(Uri.parse(endPointGemini),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return '$data';
      } else {
        return 'Erro: ${response.statusCode}';
      }
    } catch (e) {
      return 'Ocorreu um erro $e';
    }
  }
}
