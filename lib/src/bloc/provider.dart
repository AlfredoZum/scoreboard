import 'package:flutter/material.dart';

//Bloc
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
export 'package:scoreboard/src/bloc/PlayerBloc.dart';

import 'package:scoreboard/src/bloc/HomeBloc.dart';
export 'package:scoreboard/src/bloc/HomeBloc.dart';

import 'package:scoreboard/src/bloc/GameBloc.dart';
export 'package:scoreboard/src/bloc/GameBloc.dart';

//DB
import 'package:scoreboard/src/db_provider/DBProvider.dart';

class Provider extends InheritedWidget {

  static Provider _instancia;

  factory Provider({ Key key, Widget child }) {

    if ( _instancia == null ) {
      _instancia = new Provider._internal(key: key, child: child );
    }

    return _instancia;

  }

  Provider._internal({ Key key, Widget child }) : super(key: key, child: child );

  final dbProvider = DBProvider.db.database;
  final playersBloc = new PlayersBloc();
  final _homeBloc = new HomeBloc();
  final _gameBloc = new GameBloc();

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PlayersBloc of ( BuildContext context ) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() ).playersBloc;
  }

  static HomeBloc homeBloc ( BuildContext context ) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() )._homeBloc;
  }

  static GameBloc gameBloc ( BuildContext context ) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() )._gameBloc;
  }

}