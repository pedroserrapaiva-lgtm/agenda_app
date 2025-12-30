import 'package:agenda_app/app/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  bool isSecret = true;
  bool isSecretConfirm = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: passController,
              obscureText: isSecret,
              decoration: InputDecoration(
                labelText: "Senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    isSecret ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isSecret = !isSecret;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passConfirmController,
              obscureText: isSecretConfirm,
              decoration: InputDecoration(
                labelText: "Confirmar senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    isSecretConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isSecretConfirm = !isSecretConfirm;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final pass = passController.text.trim();
                  final passConfirm = passConfirmController.text.trim();

                  if (name.isEmpty ||
                      email.isEmpty ||
                      pass.isEmpty ||
                      passConfirm.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preencha todos os campos")),
                    );
                    return;
                  }

                  if (pass != passConfirm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("As senhas não coincidem")),
                    );
                    return;
                  }

                  try {
                    final auth = AuthService();
                    await auth.register(
                      name: name,
                      email: email,
                      password: pass,
                      passwordConfirmation: passConfirm,
                    );

                    Navigator.pushReplacementNamed(context, '/tabs');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao cadastrar: $e")),
                    );
                  }
                },

                child: const Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
