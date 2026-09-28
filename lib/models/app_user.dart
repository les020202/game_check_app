class AppUser {
  final String id; 
  final String nickname;
  final String email;
  final String? profileImageUrl;
  final bool emailVerified;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.nickname,
    required this.email,
    this.profileImageUrl,
    this.emailVerified = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}