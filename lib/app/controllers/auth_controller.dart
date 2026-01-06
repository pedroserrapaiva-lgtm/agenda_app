import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/login_request.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool loading = false;
  String? error;

  // LOGIN
  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    final response = await _service.login(
      LoginRequest(email: email, password: password),
    );

    loading = false;

    if (response["success"] == true) {
      notifyListeners();
      return true;
    }

    error = response["message"];
    notifyListeners();
    return false;
  }

  // REGISTER
  Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    loading = true;
    error = null;
    notifyListeners();

    final response = await _service.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    loading = false;

    if (response["success"] == true) {
      notifyListeners();
      return true;
    }

    error = response["message"];
    notifyListeners();
    return false;
  }
}
