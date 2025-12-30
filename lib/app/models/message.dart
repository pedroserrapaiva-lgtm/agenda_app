class Message {
  final int id;
  final String title;
  final String body;
  final int userId;

  Message({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      title: json["title"],
      body: json["body"],
      userId: json["user_id"],
    );
  }
}
