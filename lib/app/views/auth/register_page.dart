import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSecretPassword = true;
  bool isSecretConfirm = true;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: Consumer<AuthController>(
        builder: (context, auth, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),

            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              centerTitle: true,
              title: const Text(
                "Cadastro",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [
                    const Text(
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Preencha os dados abaixo",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 32),

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
                            "Nome",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Digite seu nome",
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
                            obscureText: isSecretPassword,
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
                                  isSecretPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () => setState(
                                  () => isSecretPassword = !isSecretPassword,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Confirmar Senha",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          TextField(
                            controller: confirmPasswordController,
                            obscureText: isSecretConfirm,
                            decoration: InputDecoration(
                              hintText: "Repita sua senha",
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
                                  isSecretConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () => setState(
                                  () => isSecretConfirm = !isSecretConfirm,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: auth.loading
                                  ? null
                                  : () async {
                                      final ok = await auth.register(
                                        nameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        confirmPasswordController.text.trim(),
                                      );

                                      if (!mounted) return;

                                      if (ok) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Cadastro realizado com sucesso!",
                                            ),
                                          ),
                                        );

                                        Navigator.pop(context);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text(
                                              "Erro no cadastro",
                                            ),
                                            content: Text(
                                              auth.error ??
                                                  "Não foi possível cadastrar.",
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
                                  : const Text("Cadastrar"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Já tem conta? Fazer login",
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
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
