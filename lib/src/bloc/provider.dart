import 'package:flutter/material.dart';

//Bloc
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
export 'package:scoreboard/src/bloc/PlayerBloc.dart';

import 'package:scoreboard/src/bloc/ScoreBloc.dart';
export 'package:scoreboard/src/bloc/ScoreBloc.dart';

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
  final _scoreBloc = new ScoreBloc();


  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PlayersBloc of ( BuildContext context ) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider ).playersBloc;
  }

  static ScoreBloc scoreBloc ( BuildContext context ) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider )._scoreBloc;
  }

}