import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swasthya_doot/colors/color_constants.dart';
import 'package:swasthya_doot/pages/auth/otp_verify_page.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:swasthya_doot/cubit/auth/phone_auth_cubit.dart';
import 'package:swasthya_doot/cubit/register/register_cubit.dart';
import 'package:swasthya_doot/pages/auth/signup_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  late final TextEditingController phoneController;
  final FocusNode phoneFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
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
            child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
              listener: (context, state) {
                if (state is PhoneAuthCodeSentWithId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => OTPVerificationPage(
                            verificationId: state.verificationId,
                            phoneNumber: phoneController.text.trim(),
                          ),
                    ),
                  );
                }

                if (state is PhoneAuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }

                setState(() {
                  isLoading = state is PhoneAuthLoading;
                });
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NameLogoWidget(size: size),
                      Gap(size.height * 0.05),
                      Text(
                        'Login with Phone',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(size.height * 0.02),
                      AbsorbPointer(
                        absorbing: isLoading,
                        child: Opacity(
                          opacity: isLoading ? 0.6 : 1,
                          child: CustomTextField(
                            inData: 'Enter your phone number',
                            title: 'Phone Number',
                            size: size.height * 0.09,
                            icn: Icons.phone,
                            controller: phoneController,
                            focusNode: phoneFocusNode,
                          ),
                        ),
                      ),
                      Gap(size.height * 0.015),
                      Text(
                        'Enter the phone number registered with your health department',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Gap(size.height * 0.03),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  final phone = phoneController.text.trim();

                                  if (!RegExp(
                                    r'^[6-9]\d{9}$',
                                  ).hasMatch(phone)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Please enter a valid 10-digit phone number',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    final query =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .where(
                                              'phoneNumber',
                                              isEqualTo: phone,
                                            )
                                            .limit(1)
                                            .get();

                                    if (query.docs.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Phone number not registered. Please sign up.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<PhoneAuthCubit>().sendOtp(
                                      phone,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Something went wrong: ${e.toString()}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (isLoading) ...[
                              const SizedBox(width: 10),
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Gap(size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const Gap(4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider(
                                        create: (_) => RegisterCubit(),
                                        child: const RegisterPage(),
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              "Register here",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
