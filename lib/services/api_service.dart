import 'dart:convert';

import '../utils/app_navigator.dart';
import '../config/app_config.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = AppConfig.apiBaseUrl;

  final storage = FlutterSecureStorage();
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['access_token'];

      await storage.write(key: 'access_token', value: token);

      return token;
    }

    return null;
  }

  Future<bool> _handleUnauthorized(http.Response response) async {
    if (response.statusCode != 401) {
      return false;
    }

    await storage.delete(key: 'access_token');

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );

    return true;
  }

  Future<Map<String, dynamic>?> getMyAccount() async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/my-account');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (await _handleUnauthorized(response)) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<Map<String, dynamic>> deposit(double amount) async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/deposit');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (await _handleUnauthorized(response)) {
      return {
        'success': false,
        'message': 'Your session has expired. Please log in again.',
      };
    }

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }

    return {'success': false, 'message': _getErrorMessage(response)};
  }

  Future<Map<String, dynamic>?> createAccount({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required String accountType,
    required String pin,
  }) async {
    final url = Uri.parse('$baseUrl/accounts');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'account_type': accountType,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      return {'error': true, 'message': _getErrorMessage(response)};
    } catch (e) {
      return {'error': true, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>?> getRecipient(int accountNumber) async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/accounts/$accountNumber/recipient');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (await _handleUnauthorized(response)) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<Map<String, dynamic>> transfer({
    required int recipientAccountNumber,
    required double amount,
    required String pin,
  }) async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/transfer');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'recipient_account_number': recipientAccountNumber,
        'amount': amount,
        'pin': pin,
      }),
    );

    if (await _handleUnauthorized(response)) {
      return {
        'success': false,
        'message': 'Your session has expired. Please log in again.',
      };
    }

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }

    return {'success': false, 'message': _getErrorMessage(response)};
  }

  Future<Map<String, dynamic>> withdraw({
    required double amount,
    required String pin,
  }) async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/withdraw');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount, 'pin': pin}),
    );

    if (await _handleUnauthorized(response)) {
      return {
        'success': false,
        'message': 'Your session has expired. Please log in again.',
      };
    }

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }

    return {'success': false, 'message': _getErrorMessage(response)};
  }

  Future<Map<String, dynamic>?> getTransactions() async {
    final token = await storage.read(key: 'access_token');

    final url = Uri.parse('$baseUrl/transactions');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (await _handleUnauthorized(response)) {
      return null;
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return {'transactions': List<Map<String, dynamic>>.from(data)};
      }

      if (data is Map<String, dynamic>) {
        return data;
      }
    }

    return null;
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
  }

  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        if (body['detail'] != null) {
          return body['detail'].toString();
        }

        if (body['message'] != null) {
          return body['message'].toString();
        }
      }
    } catch (_) {
      // Ignore JSON parsing errors
    }

    return 'Something went wrong. Please try again.';
  }
}
