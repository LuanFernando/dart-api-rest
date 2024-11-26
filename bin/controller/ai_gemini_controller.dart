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
    // Corpo da requisição
    final body = jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': "${prompt}"}
          ]
        },
        {
          'role': 'model',
          'parts': [
            {
              'text':
                  "Sou uma calculadora avançada, especializada exclusivamente em operações matemáticas. Respondo apenas com o resultado numérico. Exemplos: 'Quanto é 5 x 3?' -> '15'; 'Qual é a raiz quadrada de 16?' -> '4'. Para qualquer pergunta que não seja matemática, responderei apenas: 'Eu não sei'."
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
