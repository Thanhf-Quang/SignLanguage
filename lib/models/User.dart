class Users{
  static Users? currentUser;

  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String phone;
  final String? avtURL;
  final String? birthday;
  final String? role;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.phone,
    this.avtURL,
    this.birthday,
    this.role,
  });


  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      id: data['id'],
      username: data['name'],
      email: data['email'],
      passwordHash: data['passwordHash'],
      phone: data['phone'],
      role: data['role'],
      birthday: data['birthday'],
      avtURL: data['avtURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'phone': phone,
      'avtURL': avtURL ?? '',
      'birthday': birthday ?? '',
      'role': role ?? 'user',
    };
  }

  Users copyWith({
    String? id,
    String? username,
    String? email,
    String? passwordHash,
    String? phone,
    String? avtURL,
    String? birthday,
    String? role,
  }) {
    return Users(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      phone: phone ?? this.phone,
      avtURL: avtURL ?? this.avtURL,
      birthday: birthday ?? this.birthday,
      role: role ?? this.role,
    );
  }

}