import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/contact.dart';

class ContactService {
  final String baseUrl = "http://10.0.2.2:3000";
  final AuthService auth = AuthService();

  Future<void> createContact({
    required String name,
    String? email,
    String? phone,
  }) async {
    final token = await auth.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/contacts"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"name": name, "email": email, "phone": phone}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        "Erro ao criar contato (${response.statusCode}): ${response.body}",
      );
    }
  }



  Future<List<Contact>> fetchContacts() async {
    final token = await auth.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/contacts"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;
      return jsonList.map((j) => Contact.fromJson(j)).toList();
    } else {
      throw Exception("Erro ao carregar contatos (${response.statusCode})");
    }
  }
  Future<void> updateContact({
    required int id,
    required String name,
    String? email,
    String? phone,
  }) async {
    final token = await auth.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/contacts/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"name": name, "email": email, "phone": phone}),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar contato");
    }
  }
  Future<void> deleteContact(int id) async {
    final token = await auth.getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/contacts/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception("Erro ao apagar contato: ${response.statusCode}");
    }
  }
}
