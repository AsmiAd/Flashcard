class AppUser {
  final String uid;
  final String email;
  final String username;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}
