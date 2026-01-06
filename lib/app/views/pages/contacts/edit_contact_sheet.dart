import 'package:flutter/material.dart';
import 'package:agenda_app/app/models/contact.dart';
import 'package:agenda_app/app/services/contact_service.dart';

class EditContactSheet extends StatefulWidget {
  final Contact contact;

  const EditContactSheet({super.key, required this.contact});

  @override
  State<EditContactSheet> createState() => _EditContactSheetState();
}

class _EditContactSheetState extends State<EditContactSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool loading = false;
  final ContactService service = ContactService();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.contact.name);
    emailController = TextEditingController(text: widget.contact.email ?? "");
    phoneController = TextEditingController(text: widget.contact.phone ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await service.updateContact(
        id: widget.contact.id,
        name: nameController.text,
        email: emailController.text.isEmpty ? null : emailController.text,
        phone: phoneController.text.isEmpty ? null : phoneController.text,
      );

      if (!mounted) return;
      Navigator.pop(context, true); 
    } catch (e) {
      print("Erro ao atualizar contato: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar contato")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar Contato",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Informe o nome" : null,
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email (opcional)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Telefone (opcional)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : saveContact,
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
