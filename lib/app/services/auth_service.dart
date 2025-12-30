import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final body = request.toJson();
    final response = await ApiService().post("/users/login", body: body);

    if (response.containsKey("token")) {
      await _storage.write(key: "token", value: response["token"]);

      final data = response["data"];
      await _storage.write(key: "email", value: data["email"]);
      await _storage.write(key: "name", value: data["name"] ?? "");
    } else {
      throw Exception("Token não encontrado na resposta do servidor");
    }

    return response;
  }


  Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }
  Future<String?> getName() async {
    return await _storage.read(key: "name");
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: "email");
  }

  Future<void> logout() async {
    await _storage.delete(key: "token");
  }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final body = {
      "user": {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      },
    };

    final response = await ApiService().post("/users", body: body);

    if (response.containsKey("token")) {
      await _storage.write(key: "token", value: response["token"]);
    }

    return response;
  }
}
