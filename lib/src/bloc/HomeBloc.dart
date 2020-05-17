import 'dart:async';
import 'package:rxdart/rxdart.dart';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//validators
import 'package:scoreboard/src/bloc/ScoreValidators.dart';

class HomeBloc with ScoreValidators {

  static final HomeBloc _singleton = new HomeBloc._internal();

  factory HomeBloc() {
    return _singleton;
  }

  HomeBloc._internal() {
    getActiveScores();
  }

  final _scoreController = BehaviorSubject<List<ScoreModel>>();
  final _streaksPlayer = BehaviorSubject<Map>();

  final _typeView = BehaviorSubject<String>();

  Stream<List<ScoreModel>> get scoreStream => _scoreController.stream;
  Stream<Map> get streaksPlayer => _streaksPlayer.stream;

  Stream<String> get typeView => _typeView.stream;

  dispose() {
    _scoreController?.close();
    _streaksPlayer?.close();
    _typeView?.close();
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

  addStreaksPlayer(){

    //streaksPlayer

  }

  updateScoreToPlayer( int playerId, String type, String row ) async {
    await DBProvider.db.updateScoreToPlayer( playerId, type, DateTime.now().toString(), row );

    if( type == "add" && row == 'score' ){
      Map _streaks =  _streaksPlayer.value;
      if( _streaks == null ){
        _streaksPlayer.sink.add( { "playerId": playerId, "total": 1 } );
      }else{
        if( _streaks['playerId'] == playerId ){
          _streaksPlayer.sink.add( { "playerId": playerId, "total": _streaks['total'] + 1 } );
        }else{
          _streaksPlayer.sink.add( { "playerId": playerId, "total": 1 } );
        }
      }
    }

    getActiveScores();
  }

  endGame() async {
    await DBProvider.db.endGame();
    getActiveScores();
  }

  deletePlayer( int scoreId, int playerId ) async{
    await DBProvider.db.deletePlayerOdScore( scoreId );
    await DBProvider.db.deletePlayer( playerId );
    getActiveScores();
  }

  changeTypeView(){
    final String type = _typeView.value == 'list' ? 'grid' : 'list';
    _typeView.sink.add( type );
  }

}