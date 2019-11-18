import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/provider.dart';

//View
import 'package:scoreboard/src/view/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ScoreBoard',
        initialRoute: 'home',
        routes: {
          'home' : (BuildContext context) => HomePage(),
        },
        theme: ThemeData(
            primaryColor: Colors.green[800]
          //primaryColor: Colors.green[700]
        ),
      ),
    );

    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRReader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
      },
      theme: ThemeData(
        primaryColor: Colors.green[800]
          //primaryColor: Colors.green[700]
      ),
    );*/
  }
}