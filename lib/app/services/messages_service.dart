import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/message.dart';

class MessagesService {
  final String baseUrl = "http://10.0.2.2:3000";
  final AuthService auth = AuthService();

  // GET /contacts/:contact_id/messages
  Future<List<Message>> fetchMessages(int contactId) async {
    final token = await auth.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/contacts/$contactId/messages"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;

      return jsonList.map((j) => Message.fromJson(j)).toList();
    } else {
      throw Exception("Erro ao carregar mensagens (${response.statusCode})");
    }
  }

  // POST /contacts/:contact_id/messages
  Future<Message> createMessage({
    required int contactId,
    required String title,
    required String body,
    String? email,
    String? phone,
  }) async {
    final token = await auth.getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/contacts/$contactId/messages"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": {
          "title": title,
          "body": body,
          "email": email,
          "phone": phone,
        },
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao criar mensagem (${response.statusCode})");
    }
  }

  Future<Message> updateMessage({
    required int contactId,
    required int messageId,
    required String title,
    required String body,
    String? email,
    String? phone,
  }) async {
    final token = await auth.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/contacts/$contactId/messages/$messageId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": {
          "title": title,
          "body": body,
          "email": email,
          "phone": phone,
        },
      }),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao atualizar mensagem (${response.statusCode})");
    }
  }

  Future<void> deleteMessage({
    required int contactId,
    required int messageId,
  }) async {
    final token = await auth.getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/contacts/$contactId/messages/$messageId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception("Erro ao deletar mensagem (${response.statusCode})");
    }
  }


}
