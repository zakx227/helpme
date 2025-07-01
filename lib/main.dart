import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/onbording/onbording.dart';
import 'package:helpme/screens/aidant/home_aidant_screen.dart';
import 'package:helpme/screens/aidant/response_screen.dart';
import 'package:helpme/screens/auth/forgot_password_screen.dart';
import 'package:helpme/screens/auth/login_screen.dart';
import 'package:helpme/screens/auth/register_screen.dart';
import 'package:helpme/home_aidant.dart';
import 'package:helpme/home_beneficiaire.dart';
import 'package:helpme/screens/profile/profile_screen.dart';

import 'screens/beneficiaire/request_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HelpMe",
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        //final argument = settings.arguments;
        final widget = switch (settings.name) {
          '/login' => LoginScreen(),
          '/profil' => ProfileScreen(),
          '/homeAidant' => HomeAidantScreen(),
          '/homeBeneficiaire' => HomeBeneficiaire(),
          '/response' => ResponseScreen(),
          '/request' => RequestScreen(),
          '/beneficiaire' => HomeBeneficiaire(),
          '/aidant' => HomeAidant(),
          '/forgot' => ForgotPasswordScreen(),
          '/register' => RegisterScreen(),
          '/onbording' => Onbording(),
          _ => LoginScreen(),
        };
        return MaterialPageRoute(builder: (context) => widget);
      },
    );
  }
}
