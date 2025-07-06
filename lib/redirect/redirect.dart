import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/home_aidant.dart';
import 'package:helpme/home_beneficiaire.dart';
import 'package:helpme/provider/provider.dart';
import 'package:helpme/screens/auth/login_screen.dart';

class Redirect extends ConsumerWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return user.when(
      data: (data) {
        if (data == null) {
          return LoginScreen();
        }
        if (data.role == 'aidant') {
          return HomeAidant();
        } else {
          return HomeBeneficiaire();
        }
      },
      error: (error, stackTrace) => LoginScreen(),

      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
