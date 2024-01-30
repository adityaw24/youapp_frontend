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

  Future<Map<String, dynamic>> getProfile() async {
    final token = await storage.readData('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/api/getProfile'),
      headers: {
        'Content-Type': header['Content-Type']!,
        'x-access-token': token!,
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return throw Exception(result['message']);
    }

    await storage.writeData(
      'profile_data',
      jsonEncode(response.body),
    );

    return result;
  }

  Future<http.Response> createProfile(
    String body,
  ) async {
    final token = await storage.readData('access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/createProfile'),
      headers: {
        'Content-Type': header['Content-Type']!,
        'x-access-token': token!,
        body: body,
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return throw Exception(result['message']);
    }

    await storage.deleteData('profile_data');
    await storage.writeData(
      'profile_data',
      response.body,
    );

    return response;
  }

  Future<http.Response> updateProfile(
    String body,
  ) async {
    final token = await storage.readData('access_token');

    final response = await http.put(
      Uri.parse('$baseUrl/api/updateProfile'),
      headers: {
        'Content-Type': header['Content-Type']!,
        'x-access-token': token!,
      },
      body: body,
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return throw Exception(result['message']);
    }

    await storage.deleteData('profile_data');
    await storage.writeData(
      'profile_data',
      response.body,
    );

    return response;
  }
}
