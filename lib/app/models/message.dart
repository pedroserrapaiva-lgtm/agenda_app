class Message {
  final int id;
  final String? title;
  final String? body;
  final String? email;
  final String? phone;

  Message({required this.id, this.title, this.body, this.email, this.phone});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      email: json["email"],
      phone: json["phone"],
    );
  }
}
