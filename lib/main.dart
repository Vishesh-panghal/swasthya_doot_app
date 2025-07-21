
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swasthya_doot/colors/color_constants.dart';
import 'package:swasthya_doot/cubit/auth/phone_auth_cubit.dart';
import 'package:swasthya_doot/cubit/register/register_cubit.dart';
import 'package:swasthya_doot/firebase_options.dart';

import 'package:swasthya_doot/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(
    '✅ Firebase initialized: ${app.name} (projectId=${app.options.projectId})',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PhoneAuthCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: MaterialApp(
        title: 'Swasthya Doot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: GoogleFonts.robotoTextTheme(),
          scaffoldBackgroundColor: ColorConstants.background_color,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
