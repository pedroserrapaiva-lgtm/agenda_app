import 'api_service.dart';

class MessageService {
  final ApiService api = ApiService();

  Future<List<Map<String, dynamic>>> getMessages() async {
    final response = await api.get("/messages", auth: true);
    return List<Map<String, dynamic>>.from(response);
  }

 Future<Map<String, dynamic>> createMessage({
    required String title,
    required String body,
    String? email,
    String? phone,
  }) async {
    final messageMap = {
      "message": {"title": title, "body": body, "email": email, "phone": phone},
    };

    return await api.post('/messages', body: messageMap, auth: true);
  }

Future<Map<String, dynamic>> updateMessage({
  required int id,
  required String title,
  required String body,
  String? email,
  String? phone,
}) async {
  return await api.put(
    "/messages/$id",
    {
      "message": {
        "title": title,
        "body": body,
        "email": email,
        "phone": phone,
      }
    },
    auth: true,
  );
}

Future<void> deleteMessage(int id) async {
  await api.delete("/messages/$id", auth: true);
}
}