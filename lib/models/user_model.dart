class UserModel {
  final String? id;
  final String? name;
  final String? mobile;
  final String? email;

  UserModel({this.id, this.name, this.mobile, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }
}
