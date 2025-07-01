import 'package:flutter/material.dart';

class HomeBeneficiaireScreen extends StatelessWidget {
  const HomeBeneficiaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home beneficiaire',
          style: TextStyle(color: Colors.green, fontSize: 33),
        ),
      ),
    );
  }
}
