import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swasthya_doot/colors/color_constants.dart';
import 'package:swasthya_doot/cubit/auth/phone_auth_cubit.dart';
import 'package:swasthya_doot/pages/dashboard.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String? phoneNumber;
  final String? fullName;
  final String? village;
  final String? area;
  final String? role;

  const OTPVerificationPage({
    super.key,
    required this.verificationId,
    this.phoneNumber,
    this.fullName,
    this.village,
    this.area,
    this.role,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isVerifying = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _goBackToLogin() {
    context.read<PhoneAuthCubit>().reset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorConstants.background_color,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: BlocListener<PhoneAuthCubit, PhoneAuthState>(
              listener: (context, state) {
                if (state is PhoneAuthLoading) {
                  setState(() => isVerifying = true);
                }
    
                if (state is PhoneAuthVerified) {
                  setState(() => isVerifying = false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                }
    
                if (state is PhoneAuthCodeSentWithId) {
                  setState(() => isVerifying = false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => OTPVerificationPage(
                            verificationId: state.verificationId,
                            phoneNumber: widget.phoneNumber,
                            fullName: widget.fullName,
                            village: widget.village,
                            area: widget.area,
                            role: widget.role,
                          ),
                    ),
                  );
                }
    
                if (state is PhoneAuthError) {
                  setState(() => isVerifying = false);
                  otpController.clear();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Container(
                key: const ValueKey('otp_page'),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter OTP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(size.height * 0.02),
                    CustomTextField(
                      controller: otpController,
                      inData: '6-digit OTP',
                      title: 'One Time Password',
                      size: size.height * 0.087,
                      icn: Icons.lock_outline,
                    ),
                    Gap(size.height * 0.008),
                    Text(
                      'Enter the 6-digit code sent to your phone (Eg. 123456)',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.openSans(
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Gap(size.height * 0.02),
                    CustomElevatedButton(
                      text: isVerifying ? 'Verifying...' : 'Verify & Login',
                      onPressed:
                          isVerifying
                              ? null
                              : () {
                                final otp = otpController.text.trim();
                                FocusScope.of(context).unfocus();
                                if (otp.length == 6) {
                                  context.read<PhoneAuthCubit>().verifyOtp(
                                    otp,
                                    widget.verificationId,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid 6-digit OTP',
                                      ),
                                    ),
                                  );
                                }
                              },
                      backgroundClr: Colors.blue.shade700,
                      textClr: Colors.white,
                    ),
                    Gap(size.height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.background_color,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _goBackToLogin,
                      child: Text(
                        'Change phone',
                        style: TextStyle(
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
