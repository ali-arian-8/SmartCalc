import 'package:flutter/material.dart';
import 'package:smartcalc/screen/smart_calc_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu, color: Colors.white),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 58, 58, 58),
          title: Text('SmartCalc', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(child: SmartCalc()),
      ),
    );
  }
}
