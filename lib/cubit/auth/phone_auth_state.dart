part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthVerified extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {
  final String message;
  PhoneAuthError(this.message);
}

class PhoneAuthCodeSentWithId extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSentWithId(this.verificationId);
}