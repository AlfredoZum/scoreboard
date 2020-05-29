import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//validator
import 'package:scoreboard/src/bloc/validator/validatior_game.dart';
import 'package:scoreboard/src/model/games_played_model.dart';

class GameBloc with ValidatorsGame {

  final TextEditingController  _textNameGameController    = TextEditingController();
  TextEditingController get textNameGameController => _textNameGameController;

  final  _nameGameController    = BehaviorSubject<String>();

  Stream<String> get nameGameStream     => _nameGameController.stream;

  Function(String) get changeNameGame    => _nameGameController.sink.add;

  Future<int> createGame( String type ) async {

    if( _textNameGameController.text.toString().isEmpty ){
      _nameGameController.addError( 'Escriba el nombre del juego' );

      return 0;

    }else{
      _nameGameController.sink.add( _textNameGameController.text );

      String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> _game = {
        "name" : _textNameGameController.text,
        "create_at": timestamp,
        "update_at": timestamp,
        "status": 1,
      };

      final int _gameId = await DBProvider.db.insertGame( GameModel.fromJson( _game ) );

      if( type == "first_game" ){

        final int _gamesPlayedId = await createGamesPlayed( _gameId );
      }

      return _gameId;

    }

  }

  Future<int> createGamesPlayed( int gameId ) async {

    String _timestamp = new DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> _gamesPlayed = {
      "gamesId" : gameId,
      "create_at": _timestamp,
      "update_at": _timestamp,
      "status": 1,
    };

    final int _gamesPlayedId = await DBProvider.db.insertGamesPlayed( GamesPlayedModel.fromJson( _gamesPlayed ) );

  }

}