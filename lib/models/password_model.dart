class Password {
  String id;
  String title;
  String encryptedPassword;

  Password({
    required this.id,
    required this.title,
    required this.encryptedPassword,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'encryptedPassword': encryptedPassword,
      };

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      title: json['title'],
      encryptedPassword: json['encryptedPassword'],
    );
  }
}
