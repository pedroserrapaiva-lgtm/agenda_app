import 'package:agenda_app/app/models/message.dart';
import 'package:agenda_app/app/services/messages_service.dart';
import 'package:flutter/material.dart';

class ContactNotesPage extends StatefulWidget {
  final int contactId;
  final String contactName;

  const ContactNotesPage({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<ContactNotesPage> createState() => _ContactNotesPageState();
}

class _ContactNotesPageState extends State<ContactNotesPage> {
  final ScrollController _scrollController = ScrollController();
  late MessagesService messagesService;

  List<Message> messages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    messagesService = MessagesService();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final data = await messagesService.fetchMessages(widget.contactId);
      setState(() {
        messages = data;
        loading = false;
      });

      Future.delayed(Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      debugPrint("Erro ao carregar mensagens: $e");
      setState(() => loading = false);
    }
  }

 
  void confirmDeleteMessage(Message msg) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Excluir anotação"),
        content: Text("Tem certeza que deseja excluir esta anotação?"),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await messagesService.deleteMessage(
        contactId: widget.contactId,
        messageId: msg.id,
      );

      loadMessages();
    } catch (e) {
      debugPrint("Erro ao excluir mensagem: $e");
    }
  }


  void openEditMessageSheet(Message msg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditMessageForm(
        message: msg,
        contactId: widget.contactId,
        onSaved: () async {
          Navigator.pop(context);
          await loadMessages();
        },
      ),
    );
  }


  Widget buildMessageCard(Message msg) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (msg.title != null && msg.title!.isNotEmpty)
            Text(
              msg.title!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

          SizedBox(height: 6),

          Text(msg.body ?? "", style: TextStyle(fontSize: 15)),

          
          if (msg.email != null && msg.email!.isNotEmpty) ...[
            SizedBox(height: 10),
            Text(
              "Email: ${msg.email}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],

          
          if (msg.phone != null && msg.phone!.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              "Telefone: ${msg.phone}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () => openEditMessageSheet(msg),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => confirmDeleteMessage(msg),
              ),
            ],
          ),
        ],
      ),
    );
  }



  void openCreateMessageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateMessageForm(
        contactId: widget.contactId,
        onSaved: () async {
          Navigator.pop(context);
          await loadMessages();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contactName)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 80, top: 8),
              itemCount: messages.length,
              itemBuilder: (_, i) => buildMessageCard(messages[i]),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: openCreateMessageSheet,
            icon: Icon(Icons.add, color: Colors.white, size: 20),
            label: Text(
              "Nova Anotação",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}


class _EditMessageForm extends StatefulWidget {
  final Message message;
  final int contactId;
  final VoidCallback onSaved;

  const _EditMessageForm({
    required this.message,
    required this.contactId,
    required this.onSaved,
  });

  @override
  State<_EditMessageForm> createState() => _EditMessageFormState();
}

class _EditMessageFormState extends State<_EditMessageForm> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.message.title);
    bodyController = TextEditingController(text: widget.message.body);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Editar anotação",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Título"),
          ),

          SizedBox(height: 12),

          TextField(
            controller: bodyController,
            decoration: InputDecoration(labelText: "Mensagem"),
            maxLines: 4,
          ),

          SizedBox(height: 20),

          saving
              ? CircularProgressIndicator()
              : ElevatedButton(
                  child: Text("Salvar"),
                  onPressed: () async {
                    setState(() => saving = true);

                    await MessagesService().updateMessage(
                      contactId: widget.contactId,
                      messageId: widget.message.id,
                      title: titleController.text,
                      body: bodyController.text,
                    );

                    widget.onSaved();
                  },
                ),
        ],
      ),
    );
  }
}


class _CreateMessageForm extends StatefulWidget {
  final int contactId;
  final VoidCallback onSaved;

  const _CreateMessageForm({required this.contactId, required this.onSaved});

  @override
  State<_CreateMessageForm> createState() => _CreateMessageFormState();
}

class _CreateMessageFormState extends State<_CreateMessageForm> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nova anotação",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

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
                  child: Text("Salvar"),
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        bodyController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Título e mensagem são obrigatórios."),
                        ),
                      );
                      return;
                    }

                    setState(() => saving = true);

                    await MessagesService().createMessage(
                      contactId: widget.contactId,
                      title: titleController.text,
                      body: bodyController.text,
                      email: emailController.text.isEmpty
                          ? null
                          : emailController.text,
                      phone: phoneController.text.isEmpty
                          ? null
                          : phoneController.text,
                    );

                    widget.onSaved();
                  },
                ),
        ],
      ),
    );
  }
}
