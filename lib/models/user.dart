class User {
  final String id; // Firebase Auth uid
  final String nickname;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    this.profileImageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}