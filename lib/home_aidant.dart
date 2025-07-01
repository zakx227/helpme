import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helpme/screens/aidant/home_aidant_screen.dart';
import 'package:helpme/screens/aidant/response_screen.dart';
import 'package:helpme/screens/profile/profile_screen.dart';

class HomeAidant extends StatefulWidget {
  const HomeAidant({super.key});

  @override
  State<HomeAidant> createState() => _HomeState();
}

class _HomeState extends State<HomeAidant> {
  final pages = [HomeAidantScreen(), ResponseScreen(), ProfileScreen()];
  int index = 0;
  final items = [
    Icon(Icons.home, size: 30),
    Icon(Icons.history, size: 30),
    Icon(Icons.person, size: 30),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Text(''),
          centerTitle: true,
          title: Text(
            'HelpMe Aidant',
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
