import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swasthya_doot/colors/color_constants.dart';
import 'package:swasthya_doot/cubit/auth/phone_auth_cubit.dart';
import 'package:swasthya_doot/cubit/register/register_cubit.dart';
import 'package:swasthya_doot/pages/auth/login_page.dart';
import 'package:swasthya_doot/pages/auth/otp_verify_page.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final villageController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    villageController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final registerState = context.watch<RegisterCubit>().state;
    final registerCubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: ColorConstants.background_color,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(size.height * 0.1),
                NameLogoWidget(size: size),
                Gap(
                  size.height < 700 ? size.height * 0.02 : size.height * 0.04,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width < 360 ? 16 : size.width * 0.04,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(width: 0.1, color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Gap(size.height * 0.02),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isSmall = constraints.maxWidth < 360;
                          return Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: isSmall ? 16 : size.width * 0.055,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      CustomTextField(
                        inData: 'Enter your full name',
                        title: 'Full Name',
                        size: 50,
                        icn: Icons.person_outline,
                        onChanged:
                            (value) =>
                                registerCubit.updateField(fullName: value),
                        initialValue: registerState.fullName,
                        controller: fullNameController,
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      CustomTextField(
                        inData: 'Enter your phone number',
                        title: 'Phone Number',
                        size: 50,
                        icn: Icons.phone,
                        onChanged:
                            (value) =>
                                registerCubit.updateField(phoneNumber: value),
                        initialValue: registerState.phoneNumber,
                        controller: phoneController,
                        keyboardType: TextInputType.number
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      CustomTextField(
                        inData: 'Enter your village',
                        title: 'Village',
                        size: 50,
                        icn: Icons.location_on_outlined,
                        onChanged:
                            (value) =>
                                registerCubit.updateField(village: value),
                        initialValue: registerState.village,
                        controller: villageController,
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.work_outline),
                        ),
                        value: registerState.role,
                        items:
                            ['ASHA', 'ANM'].map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                        onChanged: (value) => registerCubit.updateRole(value!),
                        hint: Text('Select your role'),
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      Opacity(
                        opacity: registerState.role == 'ANM' ? 0.5 : 1.0,
                        child: AbsorbPointer(
                          absorbing: registerState.role == 'ANM',
                          child: CustomTextField(
                            inData: 'Enter your area',
                            title: 'Area',
                            size: 50,
                            icn: Icons.location_city_outlined,
                            onChanged:
                                (value) =>
                                    registerCubit.updateField(area: value),
                            initialValue: registerState.area,
                            controller: areaController,
                          ),
                        ),
                      ),
                      Text(
                        'Enter the phone number registered with your health department',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.024,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.04,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          text: 'Register',
                          onPressed: () async {
                            final state = registerCubit.state;

                            if (state.fullName.isEmpty ||
                                state.phoneNumber.isEmpty ||
                                state.village.isEmpty ||
                                state.role == null ||
                                (state.role != 'ANM' && state.area.isEmpty) ||
                                !RegExp(
                                  r'^[6-9]\d{9}$',
                                ).hasMatch(state.phoneNumber)) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message: 'Please fill all required fields',
                                    contentType: ContentType.failure,
                                  ),
                                ),
                              );
                              return;
                            }

                            // ✅ Save user info to be used later after OTP verification
                            context.read<PhoneAuthCubit>().setPendingUser(
                              fullName: state.fullName,
                              phoneNumber: state.phoneNumber,
                              village: state.village,
                              area: state.area,
                              role: state.role!,
                            );

                            try {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+91${state.phoneNumber}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Verification failed: ${e.message}',
                                      ),
                                    ),
                                  );
                                },
                                codeSent: (
                                  String verificationId,
                                  int? resendToken,
                                ) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => OTPVerificationPage(
                                            verificationId: verificationId,
                                            phoneNumber: state.phoneNumber,
                                            fullName: state.fullName,
                                            village: state.village,
                                            area: state.area,
                                            role: state.role!,
                                          ),
                                    ),
                                  );
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message: 'Failed to send OTP: $e',
                                    contentType: ContentType.failure,
                                  ),
                                ),
                              );
                            }
                          },
                          backgroundClr: Colors.blue.shade700,
                          textClr: Colors.white,
                        ),
                      ),
                      Gap(
                        size.height < 700
                            ? size.height * 0.02
                            : size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          Gap(4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhoneLoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Login here",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(size.height * 0.02),
                    ],
                  ),
                ),
                Gap(size.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
