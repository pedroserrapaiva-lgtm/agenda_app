class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    print("LoginRequest.toJson chamado!");
    print("Email enviado: $email");
    print("Senha enviada: $password");

    return {
      "user": {"email": email, "password": password},
    };
  }
}
