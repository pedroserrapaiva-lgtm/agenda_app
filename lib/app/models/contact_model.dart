class ContactModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;

  ContactModel({required this.id, required this.name, this.phone, this.email});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
