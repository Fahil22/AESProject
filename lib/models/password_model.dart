class Password {
  int? id;
  int userId;
  String title;
  String encryptedPassword;

  Password({
    this.id,
    required this.userId,
    required this.title,
    required this.encryptedPassword,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'encrypted_password': encryptedPassword,
      };

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      encryptedPassword: json['encrypted_password'] as String,
    );
  }
}
