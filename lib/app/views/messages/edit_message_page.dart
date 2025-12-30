import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../services/message_service.dart';

class EditMessagePage extends StatefulWidget {
  final Message message;

  const EditMessagePage({super.key, required this.message});

  @override
  _EditMessagePageState createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final MessageService _service = MessageService();

  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.message.title);
    bodyController = TextEditingController(text: widget.message.body);
  }

  Future<void> saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    await _service.updateMessage(
      id: widget.message.id,
      title: titleController.text,
      body: bodyController.text,
      email: null,
      phone: null,
    );

    setState(() => loading = false);

    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Anotação")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o título" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: bodyController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Conteúdo"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o conteúdo" : null,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: loading ? null : saveChanges,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
