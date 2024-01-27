import 'dart:convert';

import 'package:http/http.dart' as http;

const header = {
  'Content-Type': 'application/json',
};

const baseUrl = 'https://techtest.youapp.ai';

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

  Future<http.Response> login(String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: header,
      body: body,
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return throw Exception(result['message'][0]);
    }
    return response;
  }
}
