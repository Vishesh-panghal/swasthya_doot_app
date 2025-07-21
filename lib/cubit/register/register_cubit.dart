import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState.initial());

  void updateRole(String role) {
    emit(state.copyWith(role: role));
  }

  void updateField({
    String? fullName,
    String? phoneNumber,
    String? village,
    String? area,
  }) {
    emit(state.copyWith(
      fullName: fullName ?? state.fullName,
      phoneNumber: phoneNumber ?? state.phoneNumber,
      village: village ?? state.village,
      area: area ?? state.area,
    ));
  }

  void resetForm() {
    emit(RegisterState.initial());
  }
}