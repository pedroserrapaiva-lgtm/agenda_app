import 'package:flutter/material.dart';
import 'package:agenda_app/app/services/contact_service.dart';
import 'package:agenda_app/app/models/contact_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<ContactModel> _contacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    setState(() => _loading = true);
    final contacts = await ContactService().getContacts();
    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  void _openCreateContactSheet() async {
    final created = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _CreateContactSheet(),
    );

    if (created == true) {
      loadContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Contatos")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text("Nenhum contato cadastrado ainda"))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (_, i) {
                final c = _contacts[i];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(c.name),
                  subtitle: Text(
                    "${c.phone ?? "sem telefone"} • ${c.email ?? "sem email"}",
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _openCreateContactSheet,
            child: const Text("Novo contato"),
          ),
        ),
      ),
    );
  }
}

class _CreateContactSheet extends StatefulWidget {
  const _CreateContactSheet();

  @override
  State<_CreateContactSheet> createState() => _CreateContactSheetState();
}

class _CreateContactSheetState extends State<_CreateContactSheet> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool loading = false;

  void _save() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("O nome é obrigatório")));
      return;
    }

    setState(() => loading = true);

    final ok = await ContactService().createContact(
      name: name,
      phone: phone.isEmpty ? null : phone,
      email: email.isEmpty ? null : email,
    );

    setState(() => loading = false);

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao criar contato")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Novo Contato",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nome *"),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Telefone"),
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 12),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: loading ? null : _save,
            child: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Salvar Contato"),
          ),
        ],
      ),
    );
  }
}
