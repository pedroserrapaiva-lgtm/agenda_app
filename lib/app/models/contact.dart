class Contact {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  Contact({required this.id, required this.name, this.email, this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"],
      phone: json["phone"],
    );
  }
}
