import 'package:flutter/material.dart';
import 'package:agenda_app/app/services/contact_service.dart';
import 'package:agenda_app/app/services/messages_service.dart';
import 'package:agenda_app/app/views/pages/contacts/contact_notes_page.dart';
import 'package:agenda_app/app/views/pages/contacts/edit_contact_sheet.dart';

import '../../../models/contact.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class CreateContactSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const CreateContactSheet({super.key, required this.onSaved});

  @override
  State<CreateContactSheet> createState() => _CreateContactSheetState();
}

class _CreateContactSheetState extends State<CreateContactSheet> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  bool saving = false;

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      final service = ContactService();

      await service.createContact(
        name: name.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
      );

      widget.onSaved();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erro ao criar contato")));
      }
    }

    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Novo Contato",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: name,
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Nome obrigatório" : null,
                decoration: input("Nome"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: email,
                decoration: input("Email (opcional)"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phone,
                decoration: input("Telefone (opcional)"),
              ),
              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Criar Contato",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF1565C0)),
      ),
    );
  }
}


class _ContactsPageState extends State<ContactsPage> {
  late ContactService contactsService;
  late MessagesService messagesService;

  List<Contact> contacts = [];
  bool loading = true;

  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    contactsService = ContactService();
    messagesService = MessagesService();
    loadContacts();
  }

Future<void> loadContacts() async {
    try {
      final data = await contactsService.fetchContacts();

      data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {
        contacts = data;
        loading = false;
      });
    } catch (e) {
      print("Erro ao buscar contatos: $e");
      setState(() => loading = false);
    }
  }


  void openEditContactSheet(Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditContactSheet(contact: contact),
    ).then((updated) {
      if (updated == true) loadContacts();
    });
  }

void openCreateContactSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateContactSheet(onSaved: loadContacts),
    );
  }

  void deleteContact(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir contato"),
        content: const Text("Tem certeza que deseja excluir este contato?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await contactsService.deleteContact(id);
      loadContacts();
    } catch (e) {
      print("Erro ao deletar contato: $e");
    }
  }

  List<Contact> get _filteredContacts {
    if (_search.isEmpty) return contacts;
    final query = _search.toLowerCase();
    return contacts.where((c) => c.name.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1565C0); 

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "Minha Agenda",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de busca arredondada
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Buscar contatos',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              
              Row(
              children: [
                Expanded(
                  child: _ActionPillButton(
                    color: primaryBlue,
                    icon: Icons.add,
                    label: 'Novo',
                    onPressed: openCreateContactSheet,
                  ),
                ),
              ],
            ),

              const SizedBox(height: 20),

              const Text(
                'Meus contatos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredContacts.isEmpty
                    ? const Center(child: Text("Nenhum contato encontrado"))
                    : ListView.separated(
                        itemCount: _filteredContacts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            _buildContactCard(_filteredContacts[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    const Color primaryBlue = Color(0xFF1565C0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactNotesPage(
              contactId: contact.id,
              contactName: contact.name,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: primaryBlue.withOpacity(0.12),
              foregroundColor: primaryBlue,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : "?",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Toque para ver anotações",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: primaryBlue),
              onPressed: () => openEditContactSheet(contact),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteContact(contact.id),
            ),
          ],
        ),
      ),
    );
  }
}

// Botão pill reutilizável
class _ActionPillButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionPillButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), 
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
