import 'package:flutter/material.dart';
import '../../services/message_service.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final MessageService _service = MessageService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Anotação")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o título" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Conteúdo"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o conteúdo" : null,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => loading = true);

                        final data = {
                          "title": _titleController.text,
                          "body": _bodyController.text,
                        };

                        await _service.createMessage(
                          title: data["title"]!,
                          body: data["body"]!,
                        );
                        
                        Navigator.pop(context, true);
                      },
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
