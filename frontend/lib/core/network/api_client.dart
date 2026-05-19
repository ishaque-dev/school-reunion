import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  static const String defaultBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://reunion-backend-yaob.onrender.com/api',
  );

  final String baseUrl;
  final http.Client _client;
  final Duration timeout;

  ApiClient({
    this.baseUrl = defaultBaseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: (query == null || query.isEmpty) ? null : query,
    );
    return _send(() => _client.get(uri, headers: _headers()));
  }

  Future<dynamic> post(String path, {required Object body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(
      () => _client.post(uri, headers: _headers(), body: jsonEncode(body)),
    );
  }

  Future<dynamic> put(String path, {required Object body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(
      () => _client.put(uri, headers: _headers(), body: jsonEncode(body)),
    );
  }

  Future<void> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    await _send(() => _client.delete(uri, headers: _headers()));
  }

  Map<String, String> _headers() => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(timeout);
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } catch (_) {
      throw NetworkException();
    }

    final body = response.body.isEmpty ? null : _safeDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = (body is Map && body['error'] != null) ? body['error'].toString() : 'Request failed';
    switch (response.statusCode) {
      case 404:
        throw NotFoundException(message);
      case 409:
        throw ConflictException(message);
      case 400:
      case 422:
        throw ValidationException(message);
      default:
        throw ServerException(message, statusCode: response.statusCode);
    }
  }

  dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}
