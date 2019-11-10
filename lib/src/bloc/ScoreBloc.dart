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
  //Stream<List<ScoreModel>> get scoreLastWin => _scoreController.stream.transform( getLastWin );

  dispose() {
    _scoreController?.close();
  }

  getActiveScores() async {

    final _activeScore = await DBProvider.db.getActiveScores();

    if( _activeScore.length == 0 ){
      int numInterval = 1;
      final _lastScore = await DBProvider.db.getLastScore();
      if( _lastScore.length > 0 ){
        numInterval = _lastScore[0].interval + 1;
      }

      final _players = await DBProvider.db.getAllPlayers();
      _players.forEach( ( p ){

        final score = ScoreModel( playerId: p.id, score: 0, assistance: 0, createAt: DateTime.now().toString(), updateAt: DateTime.now().toString(), interval: numInterval, status: 1 );
        DBProvider.db.addScore( score );

      });

    }

    _scoreController.sink.add( await DBProvider.db.getActiveScores()  );
  }

  getLastPlayerWin( int playerId, String type ) async {

  }

  updateScoreToPlayer( int playerId, String type, String table ) async {
    await DBProvider.db.updateScoreToPlayer( playerId, type, DateTime.now().toString(), table );
    getActiveScores();
  }

  endGame() async {

    await DBProvider.db.endGame();
    getActiveScores();

  }

}