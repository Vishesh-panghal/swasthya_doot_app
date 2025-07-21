class UserInfoModel {
  final String fullName;
  final String phoneNumber;
  final String village;
  final String area;
  final String role;

  UserInfoModel({
    required this.fullName,
    required this.phoneNumber,
    required this.village,
    required this.area,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'village': village,
      'area': area,
      'role': role,
      'createdAt': DateTime.now(),
    };
  }
}