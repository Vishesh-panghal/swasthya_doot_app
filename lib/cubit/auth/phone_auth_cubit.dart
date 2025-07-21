import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swasthya_doot/models/user_info_model.dart'; // Make sure the path is correct

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserInfoModel? _pendingUser;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  // 🔹 Save pending user data before OTP verification
  void setPendingUser({
    required String fullName,
    required String phoneNumber,
    required String village,
    required String area,
    required String role,
  }) {
    _pendingUser = UserInfoModel(
      fullName: fullName,
      phoneNumber: phoneNumber,
      village: village,
      area: area,
      role: role,
    );
  }

  // 🔹 Send OTP
  void sendOtp(String phoneNumber) async {
    emit(PhoneAuthLoading());

    print("📲 Requesting OTP for $phoneNumber");

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _storeUserData(); // Store user info if credential is auto verified
        emit(PhoneAuthVerified());
      },
      verificationFailed: (FirebaseAuthException e) {
        print("❌ Verification Failed: ${e.message}");
        emit(PhoneAuthError(e.message ?? "Verification failed"));
      },
      codeSent: (String verificationId, int? resendToken) {
        print("✅ Code sent with verificationId: $verificationId");
        emit(PhoneAuthCodeSentWithId(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("⌛ Code auto retrieval timeout");
      },
    );
  }

  // 🔹 Verify OTP manually
  void verifyOtp(String otp, String verificationId) async {
    if (verificationId.isEmpty) {
      emit(PhoneAuthError("OTP session expired or invalid. Please retry."));
      return;
    }

    try {
      emit(PhoneAuthLoading());

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _storeUserData(); // Store after successful login
        emit(PhoneAuthVerified());
      } else {
        emit(PhoneAuthError("User not found after verification"));
      }
    } catch (e, stackTrace) {
      print("❌ OTP Verification Failed: $e");
      print("🧩 StackTrace: $stackTrace");
      emit(PhoneAuthError("Failed to verify OTP. Try again."));
    }
  }

  // 🔹 Store to Firestore
  Future<void> _storeUserData() async {
    final user = _auth.currentUser;
    if (user != null && _pendingUser != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      final exists = await docRef.get();
      if (!exists.exists) {
        await docRef.set(_pendingUser!.toMap());
        print("✅ User data stored for UID: ${user.uid}");
      } else {
        print("⚠️ User already exists in Firestore");
      }
    }
  }

  void reset() {
    _pendingUser = null;
    emit(PhoneAuthInitial());
  }
}