class UserModel {
  final int? id;
  final String username;
  final String password;
  final String role;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  // Konversi dari Map (dari SQLite) ke objek UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      role: map['role'],
    );
  }

  // Konversi dari objek UserModel ke Map (untuk insert/update SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
    };
  }
}
