import 'package:agenda_app/app/views/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSecret = true;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: Consumer<AuthController>(
        builder: (context, auth, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),

            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bem‑vindo",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Faça login para continuar",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),

                    const SizedBox(height: 32),

                    // CARD BRANCO
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Digite seu email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDDDDDD),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Senha",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: passwordController,
                            obscureText: isSecret,
                            decoration: InputDecoration(
                              hintText: "Digite sua senha",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDDDDDD),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: primaryBlue,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isSecret
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () =>
                                    setState(() => isSecret = !isSecret),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // BOTÃO ENTRAR
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: auth.loading
                                  ? null
                                  : () async {
                                      final ok = await auth.login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );

                                      if (!mounted) return;

                                      if (ok) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/tabs',
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Erro no login"),
                                            content: Text(
                                              auth.error ??
                                                  "Email ou senha inválidos.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: auth.loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Text("Entrar"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // LINK PARA CADASTRO
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Não tem conta? Cadastre-se",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
