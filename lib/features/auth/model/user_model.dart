class UserModel {
  final String name;
  final String email;
  final String password;
  final int? id;
  UserModel(
      {required this.email,
      this.id,
      required this.name,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        email: map['email'],
        name: map['name'],
        password: map['password']);
  }
}
