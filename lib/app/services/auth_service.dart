import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  int _extractStatus(dynamic status) {
    if (status is int) return status;
    if (status is Map && status["code"] is int) return status["code"];
    return -1;
  }

  // LOGIN
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await ApiService().post(
        "/users/login",
        body: request.toJson(),
      );

      final statusCode = _extractStatus(response["status"]);

      if (statusCode != 200 || !response.containsKey("token")) {
        return {
          "success": false,
          "message": response["message"] ?? "Credenciais inválidas.",
        };
      }

      final data = response["data"];
      await _storage.write(key: "token", value: response["token"]);
      await _storage.write(key: "email", value: data["email"]);
      await _storage.write(key: "name", value: data["name"] ?? "");

      return {
        "success": true,
        "message": response["message"] ?? "Login realizado com sucesso!",
      };
    } catch (e) {
      return {"success": false, "message": "Erro inesperado ao fazer login."};
    }
  }

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final body = {
        "user": {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      };

      final response = await ApiService().post("/users", body: body);

      final statusCode = _extractStatus(response["status"]);

      if (statusCode != 200 && statusCode != 201) {
        String message = response["message"] ?? "Erro ao cadastrar.";

        if (response["errors"] is List && response["errors"].isNotEmpty) {
          final backendMsg = response["errors"][0];

          if (backendMsg.contains("already been taken")) {
            message = "O email informado já está em uso.";
          }
        }

        return {"success": false, "message": message};
      }

      // Sucesso
      if (response.containsKey("token")) {
        await _storage.write(key: "token", value: response["token"]);
      }

      return {
        "success": true,
        "message": response["message"] ?? "Cadastro realizado!",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Erro inesperado ao registrar usuário.",
      };
    }
  }

  Future<String?> getToken() => _storage.read(key: "token");
  Future<String?> getName() => _storage.read(key: "name");
  Future<String?> getEmail() => _storage.read(key: "email");

  Future<void> logout() async {
    await _storage.delete(key: "token");
  }
}
