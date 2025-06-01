import 'dart:convert';
import 'package:hackathon/models/user.dart';
import 'package:hackathon/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/property.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() => _instance;

  static const String baseUrl = 'https://7dfa-146-120-90-6.ngrok-free.app/api';

  final AuthService authService = AuthService();

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/properties/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties: ${response.statusCode}');
    }
  }

  Future login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final String token = data['token'];
      authService.saveToken(token);

      return User.fromJson(data['user']);
    } else {
      throw Exception(data['error'] ?? 'Login failed: ${response.statusCode}');
    }
  }

  Future<User?> checkAuth() async {
    final token = await authService.getToken();

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/user/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return User.fromJson(data);
      } else {
        await authService.removeToken();
      }
    } catch (e) {
      await authService.removeToken();
    }

    return null;
  }
}
