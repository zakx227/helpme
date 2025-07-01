import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Response',
          style: TextStyle(color: Colors.green, fontSize: 33),
        ),
      ),
    );
  }
}
