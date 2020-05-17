import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/provider.dart';

//View
import 'package:scoreboard/src/view/home/HomePage.dart';

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
            primaryColor: Colors.green[800],
            primaryColorDark: Colors.green[900],
            primaryColorLight: Colors.green[400]
            //primaryColorDark: Colors.green
          //primaryColor: Colors.green[700]
        ),
      ),
    );
  }
}