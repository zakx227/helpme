import 'package:flutter/material.dart';

class HomeAidantScreen extends StatelessWidget {
  const HomeAidantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home Aidant',
          style: TextStyle(color: Colors.green, fontSize: 33),
        ),
      ),
    );
  }
}
