import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  late final AuthService _authService = AuthService();

  Future<Map<String, String>> _authHeaders(bool auth) async {
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json",
    };

    if (auth) {
      final token = await _authService.getToken();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

 Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("POST → $url");

    final headers = await _authHeaders(auth);

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse("POST", url.toString(), response);
  }

  Future<dynamic> get(String endpoint, {bool auth = false}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("GET → $url");

    final headers = await _authHeaders(auth);

    final response = await http.get(url, headers: headers);

    return _handleResponse("GET", url.toString(), response);
  }

  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("PUT → $url");

    final headers = await _authHeaders(auth);

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse("PUT", url.toString(), response);
  }

  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("PATCH → $url");

    final headers = await _authHeaders(auth);

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse("PATCH", url.toString(), response);
  }

  Future<dynamic> delete(String endpoint, {bool auth = false}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("DELETE → $url");

    final headers = await _authHeaders(auth);

    final response = await http.delete(url, headers: headers);

    return _handleResponse("DELETE", url.toString(), response);
  }

  dynamic _handleResponse(String method, String url, http.Response response) {
    print("RESPONSE [$method $url] → ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    throw Exception(
      "Erro na API ($method $url) → ${response.statusCode}: ${response.body}",
    );
  }
}
