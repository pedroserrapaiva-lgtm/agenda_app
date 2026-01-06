import 'package:agenda_app/app/models/message.dart';
import 'package:agenda_app/app/services/messages_service.dart';
import 'package:flutter/material.dart';

class EditMessagePage extends StatefulWidget {
  final Message message;
  final int contactId;

  const EditMessagePage({
    super.key,
    required this.message,
    required this.contactId,
  });

  @override
  State<EditMessagePage> createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  late MessagesService messagesService;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    messagesService = MessagesService();

    titleController.text = widget.message.title ?? "";
    bodyController.text = widget.message.body ?? "";
    emailController.text = widget.message.email ?? "";
    phoneController.text = widget.message.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar anotação")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Título *"),
            ),
            SizedBox(height: 12),

            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: "Mensagem *"),
              maxLines: 4,
            ),

            SizedBox(height: 12),

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email (opcional)"),
            ),

            SizedBox(height: 12),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Telefone (opcional)"),
            ),

            SizedBox(height: 20),

            saving
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          bodyController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Título e mensagem são obrigatórios.",
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() => saving = true);

                      await messagesService.updateMessage(
                        contactId: widget.contactId,
                        messageId: widget.message.id,
                        title: titleController.text,
                        body: bodyController.text,
                        email: emailController.text.isEmpty
                            ? null
                            : emailController.text,
                        phone: phoneController.text.isEmpty
                            ? null
                            : phoneController.text,
                      );

                      if (!mounted) return;
                      Navigator.pop(context, true);
                    },
                    child: Text("Salvar"),
                  ),
          ],
        ),
      ),
    );
  }
}
