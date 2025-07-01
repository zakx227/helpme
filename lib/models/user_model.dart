class UserModel {
  final String uid;
  final String name;
  final String email;
  final String quartier;
  final String tel;
  final String role;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.quartier,
    required this.tel,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'quartier': quartier,
      'tel': tel,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['id'],
      name: map['name'],
      email: map['email'],
      quartier: map['quartier'],
      tel: map['tel'],
      role: map['role'],
    );
  }
}
