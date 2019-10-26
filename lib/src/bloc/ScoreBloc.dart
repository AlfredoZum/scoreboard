import 'dart:async';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

class ScoreBloc {

  static final ScoreBloc _singleton = new ScoreBloc._internal();

  factory ScoreBloc() {
    return _singleton;
  }

  ScoreBloc._internal() {
    getActiveScores();
  }

  final _scoreController = StreamController<List<ScoreModel>>.broadcast();

  Stream<List<ScoreModel>> get scoreStream => _scoreController.stream;

  dispose() {
    _scoreController?.close();
  }

  getActiveScores() async {

    final _activeScore = await DBProvider.db.getActiveScores();
    final _lastScore = await DBProvider.db.getLastScore();

    if( _activeScore.length == 0 ){
      int numInterval = 1;
      final _lastScore = await DBProvider.db.getLastScore();
      if( _lastScore.length > 0 ){



      }

      final _players = await DBProvider.db.getAllPlayers();
      _players.forEach( ( p ){

        final score = ScoreModel( playerId: p.id, score: 0, date: DateTime.now().toString(), interval: numInterval, status: 1 );
        DBProvider.db.addScore( score );

      });

    }

    _scoreController.sink.add( await DBProvider.db.getActiveScores()  );
  }

  /*addPlayer( PlayerModel player ) async{
    await DBProvider.db.newPlayer( player );
    getActiveScores();
  }*/

}