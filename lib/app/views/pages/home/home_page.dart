import 'package:agenda_app/app/models/message.dart';
import 'package:agenda_app/app/services/auth_service.dart';
import 'package:agenda_app/app/services/message_service.dart';
import 'package:agenda_app/app/views/messages/edit_message_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MessageService _service = MessageService();
  final AuthService authService = AuthService();

  bool loading = false;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    setState(() => loading = true);

    final data = await _service.getMessages();
    messages = data.map((e) => Message.fromJson(e)).toList();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Anotações"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma mensagem ainda.\nCrie sua primeira anotação!",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Card(
                  child: ListTile(
                    title: Text(msg.title),
                    subtitle: Text(msg.body),
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditMessagePage(message: msg),
                        ),
                      );

                      if (updated == true) {
                        await loadMessages();
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Excluir"),
                            content: const Text(
                              "Tem certeza que deseja excluir esta anotação?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _service.deleteMessage(msg.id);
                          await loadMessages();
                        }
                      },
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final saved = await Navigator.pushNamed(context, '/new_message');
              if (saved == true) {
                await loadMessages();
              }
            },
            child: const Text("Nova anotação"),
          ),
        ),
      ),
    );
  }
}
