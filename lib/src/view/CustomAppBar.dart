import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Bloc
import 'package:scoreboard/src/bloc/ScoreBloc.dart';

void endGame(){

  final ScoreBloc scoreBloc = new ScoreBloc();
  scoreBloc.endGame();

}

void addPlayers2( PlayersBloc playersBloc ){

  List players = [
    [ 'Alfredo', 'alfredo.jpg' ],
    [ 'Polanco', 'polanco.jpg' ],
    [ 'Marcos', 'marcos.jpg' ],
    [ 'Cach', 'cach.jpg' ],
  ];

  players.forEach( (p){

    final player = PlayerModel( name: p[0], image: p[1] );
    playersBloc.addPlayer(player);

  });

}

class HomeAppBarHome extends AppBar {

  final PlayersBloc playersBloc;

  HomeAppBarHome( { Key key, Widget title, this.playersBloc } ) : super(
    key: key,
    title: title,
    actions: <Widget>[
      IconButton(
        icon: Icon( Icons.stop ),
        onPressed: () => endGame(),
      ),
      IconButton(
        icon: Icon( Icons.add ),
        onPressed: () => addPlayers2( playersBloc ),
      )
    ],
  );

}