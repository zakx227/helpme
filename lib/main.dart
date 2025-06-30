import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/onbording/onbording.dart';
import 'package:helpme/screens/auth/forgot_password_screen.dart';
import 'package:helpme/screens/auth/login_screen.dart';
import 'package:helpme/screens/auth/register_screen.dart';
import 'package:helpme/screens/home.dart';
import 'package:helpme/screens/home_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/onbording',
      onGenerateRoute: (settings) {
        //final argument = settings.arguments;
        final widget = switch (settings.name) {
          '/homeScreen' => HomeScreen(),
          '/login' => LoginScreen(),
          '/home' => Home(),
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
