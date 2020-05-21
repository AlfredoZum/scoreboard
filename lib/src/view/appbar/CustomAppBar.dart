import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoreboard/src/bloc/PlayerBloc.dart';

//Bloc
import 'package:scoreboard/src/bloc/HomeBloc.dart';
import 'package:scoreboard/src/view/players/DialogAddPlayer.dart';
import 'package:scoreboard/src/view/home/components/DialogStopGame.dart';

//View

//Muestra un dialogo para finalizar la partida
Future showDialogEndGame( BuildContext context ){

  return showDialog(
      context: context,
      builder: ( context ) {
        return DialogStopGame();
      }
  );

}

//Muestra un dialogo para agregar jugadores
Future addPlayers( PlayersBloc playersBloc, BuildContext context ){

  playersBloc.initEmptyPlayer();
  return showDialog(
      context: context,
      builder: ( context ) {
        return DialogAddPlayer();
      }
  );

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
        onPressed: () => showDialogEndGame( context ),
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