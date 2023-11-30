class User {
  String? uid;
  String username;
  String? password;
  String email;
  String? phone = "";
  String? createdAt = "";
  String? updatedAt = "";

  User({
    this.uid,
    required this.username,
    this.password,
    required this.email,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap([bool includeId = false]) {
    return {
      if (includeId) 'uid': uid,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
