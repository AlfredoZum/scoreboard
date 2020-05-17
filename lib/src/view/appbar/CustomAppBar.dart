import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Bloc
import 'package:scoreboard/src/bloc/HomeBloc.dart';
import 'package:scoreboard/src/view/players/DialogAddPlayer.dart';

//View

void endGame(){

  final HomeBloc homeBloc = new HomeBloc();
  homeBloc.endGame();

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

  final HomeBloc homeBloc = new HomeBloc();
  homeBloc.getActiveScores();

}

class HomeAppBarHome extends AppBar {

  final PlayersBloc playersBloc;
  final HomeBloc homeBloc;
  final BuildContext context;

  HomeAppBarHome( { Key key, Widget title, this.playersBloc, this.homeBloc, this.context } ) : super(
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
      ),
      _iconTypeView()
    ],
  );

  static _iconTypeView(){

    final HomeBloc homeBloc = new HomeBloc();

    return StreamBuilder<String>(
      stream: homeBloc.typeView,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        final String _typeView = snapshot.data;

        final _icon = _typeView == null || _typeView == "grid" ? FontAwesomeIcons.list : FontAwesomeIcons.thLarge;

        return IconButton(
          icon: Icon( _icon ),
          onPressed: () => homeBloc.changeTypeView(),
        );

      },
    );

  }

}