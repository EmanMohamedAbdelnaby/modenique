class UserModel {
  final String name;
  final String email;
  final String phone;
  final String? imagePath; // nullable علشان ممكن مفيش صورة

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
  });
}
