import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Request',
          style: TextStyle(color: Colors.green, fontSize: 33),
        ),
      ),
    );
  }
}
