import 'package:flutter/material.dart';

//View
import 'package:scoreboard/src/view/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRReader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
      },
      theme: ThemeData(
          primaryColor: Colors.green
      ),
    );
  }
}