import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Bloc
import 'package:scoreboard/src/bloc/ScoreBloc.dart';
import 'package:scoreboard/src/view/players/DialogAddPlayer.dart';

//View

void endGame(){

  final ScoreBloc scoreBloc = new ScoreBloc();
  scoreBloc.endGame();

}

Future addPlayers( PlayersBloc playersBloc, BuildContext context ){

  playersBloc.initEmptyPlayer();
  return showDialog(
      context: context,
      builder: ( context ) {
        return DialogAddPlayer();
      }
  );

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

  final ScoreBloc scoreBloc = new ScoreBloc();
  scoreBloc.getActiveScores();

}

class HomeAppBarHome extends AppBar {

  final PlayersBloc playersBloc;
  final BuildContext context;

  HomeAppBarHome( { Key key, Widget title, this.playersBloc, this.context } ) : super(
    key: key,
    title: title,
    actions: <Widget>[
      IconButton(
        icon: Icon( Icons.stop ),
        onPressed: () => endGame(),
      ),
      IconButton(
        icon: Icon( Icons.add ),
        onPressed: () => addPlayers( playersBloc, context ),
      )
    ],
  );

}