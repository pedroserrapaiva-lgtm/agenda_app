import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/login_request.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service = AuthService();
  bool loading = false;
  String? error;

  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();

    try {
      final req = LoginRequest(email: email, password: password);

      final response = await _service.login(req);

      final token = response['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);

      loading = false;
      notifyListeners();
      return true;
    } catch (e, stack) {
      loading = false;
      print("Erro no login: $e");
      print(stack);

      error = "Email ou senha incorretos.";
      notifyListeners();
      return false;
    }
  }
}
