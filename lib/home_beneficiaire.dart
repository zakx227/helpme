import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helpme/screens/beneficiaire/home_beneficiaire_screen.dart';
import 'package:helpme/screens/profile/profile_screen.dart';

class HomeBeneficiaire extends StatefulWidget {
  const HomeBeneficiaire({super.key});

  @override
  State<HomeBeneficiaire> createState() => _HomeState();
}

class _HomeState extends State<HomeBeneficiaire> {
  final pages = [HomeBeneficiaireScreen(), ProfileScreen()];
  int index = 0;
  final items = [Icon(Icons.home, size: 30), Icon(Icons.person, size: 30)];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Text(''),
          centerTitle: true,
          title: Text(
            'HelpMe beneficiair',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.green,
            ),
          ),
        ),
        body: pages[index],
        bottomNavigationBar: Theme(
          data: Theme.of(
            context,
          ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            color: Colors.green,
            backgroundColor: Colors.transparent,
            height: 60,
            index: index,
            items: items,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            onTap: (value) => setState(() {
              index = value;
            }),
          ),
        ),
      ),
    );
  }
}
