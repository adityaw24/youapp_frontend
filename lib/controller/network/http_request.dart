import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youapp_frontend/service/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const header = {
  'Content-Type': 'application/json',
};

const baseUrl = 'https://techtest.youapp.ai';

final storage = StorageService();

class HttpRequest {
  const HttpRequest();

  Future<http.Response> register(String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: header,
      body: body,
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      // print(result['message'][0]);
      return throw Exception(result['message'][0]);
    }
    return response;
  }

  Future<http.Response> login(
    String body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: header,
      body: body,
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return throw Exception(result['message'][0]);
    }

    final userData = JwtDecoder.decode(result['access_token']);

    await storage.writeData(
      'access_token',
      result['access_token'],
    );

    await storage.writeData(
      'user_data',
      jsonEncode(userData),
    );

    return response;
  }
}
