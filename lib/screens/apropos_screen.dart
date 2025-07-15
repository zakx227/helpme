import 'package:flutter/material.dart';

class AproposScreen extends StatelessWidget {
  const AproposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "A propos",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
              child: Icon(
                Icons.volunteer_activism,
                size: 90,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "HelpMe",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Une application d'entraide communautaire qui connecte les personnes dans le besoin avec celles qui souhaitent aider .",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
