class RegisterState {
  final String fullName;
  final String phoneNumber;
  final String village;
  final String area;
  final String? role;

  RegisterState({
    required this.fullName,
    required this.phoneNumber,
    required this.village,
    required this.area,
    required this.role,
  });

  factory RegisterState.initial() {
    return RegisterState(
      fullName: '',
      phoneNumber: '',
      village: '',
      area: '',
      role: null,
    );
  }

  RegisterState copyWith({
    String? fullName,
    String? phoneNumber,
    String? village,
    String? area,
    String? role,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      village: village ?? this.village,
      area: area ?? this.area,
      role: role ?? this.role,
    );
  }
}