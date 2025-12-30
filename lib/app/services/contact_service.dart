import 'package:agenda_app/app/models/contact_model.dart';
import 'package:agenda_app/app/services/api_service.dart';

class ContactService {
  final api = ApiService();

  Future<List<ContactModel>> getContacts() async {
    final response = await api.get('/contacts', auth: true);

    final list = response as List;
    return list.map((c) => ContactModel.fromJson(c)).toList();
  }

  Future<bool> createContact({
    required String name,
    String? phone,
    String? email,
  }) async {
    final response = await api.post('/contacts', body: {
      "contact": {
        "name": name,
        "phone": phone,
        "email": email,
      }
    }, auth: true);

    return response != null;
  }
}
