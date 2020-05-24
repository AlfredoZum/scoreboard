import 'dart:async';
import 'package:rxdart/rxdart.dart';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//validators
import 'package:scoreboard/src/bloc/ScoreValidators.dart';
import 'package:scoreboard/src/model/game_model.dart';

class HomeBloc with ScoreValidators {

  static final HomeBloc _singleton = new HomeBloc._internal();

  factory HomeBloc() {
    return _singleton;
  }

  HomeBloc._internal() {
    getActiveScores();
  }

  final _gamesController = BehaviorSubject<List<GameModel>>();
  final _settingController = BehaviorSubject<SettingModel>();
  final _scoreController = BehaviorSubject<List<ScoreModel>>();
  final _streaksPlayer = BehaviorSubject<Map>();

  final _typeView = BehaviorSubject<String>();
  final _initApp = BehaviorSubject<bool>();

  Stream<List<GameModel>> get gamesStream => _gamesController.stream;
  Stream<SettingModel> get settingStream => _settingController.stream;
  Stream<List<ScoreModel>> get scoreStream => _scoreController.stream;
  Stream<Map> get streaksPlayer => _streaksPlayer.stream;

  Stream<String> get typeView => _typeView.stream;
  Stream<bool> get initApp => _initApp.stream;

  Stream<List> get getInfoHome  =>
      Rx.combineLatest3(gamesStream, settingStream, initApp,  ( g, s, i ) => [ g, s, i ] );

  dispose() {
    _scoreController?.close();
    _streaksPlayer?.close();
    _typeView?.close();
  }

  changeInitApp( bool value ){
    _initApp.sink.add( value );
  }

  getInitGame() async {

    final _activeGame = await DBProvider.db.getActiveGame();
    final _setting = await DBProvider.db.getSetting();

    if( _initApp.value == null ){
      _initApp.sink.add( false );
    }

    if( _activeGame.length == 0 ){

    }

    _settingController.sink.add( _setting );
    _gamesController.sink.add( _activeGame );

  }


  //Get the player and score of current game
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

  /*
  * updatebthe score of player
  * @params playerId id of player ( user )
  * @params type add or remove score
  * @params row type score ( score or assistance )
  * */

  updatePlayerScore( int playerId, String type, String row ) async {
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

  //finish the game
  endGame() async {
    await DBProvider.db.endGame();
    getActiveScores();
  }

  //get the score of player ( max, min, )
  List<List<ScoreModel>> getScores(){

    List<ScoreModel> scores = _scoreController.value;
    //List<ScoreModel> score2 = scores.toList();
    //score2.sort((a,b) => b.updateAt.compareTo(a.updateAt));

    List<ScoreModel> maxScore = scores.toList();
    maxScore.sort((a,b) => b.getScore().compareTo(a.getScore()));

    List<ScoreModel> minScore = scores.toList();
    minScore.sort((a,b) => a.getScore().compareTo(b.getScore()));

    return [ maxScore, minScore ];

  }

  //get the player winners and losers in the active game
  List<List<ScoreModel>> getFinalScore(){

    List<List<ScoreModel>> finalScores = getScores();

    List<ScoreModel> maxScore = finalScores[0];
    List<ScoreModel> minScore = finalScores[1];

    List<ScoreModel> winners = maxScore.where( ( s ) => s.score == maxScore[0].score ).toList();
    List<ScoreModel> losers = minScore.where( ( s ) => s.score == minScore[0].score ).toList();

    return [winners, losers];

  }

  //delete the selected player
  deletePlayer( int scoreId, int playerId ) async{
    await DBProvider.db.deletePlayerOdScore( scoreId );
    await DBProvider.db.deletePlayer( playerId );
    getActiveScores();
  }

  //change the type of view in the score home ( list or grid )
  changeTypeView(){
    final String type = _typeView.value == 'list' ? 'grid' : 'list';
    _typeView.sink.add( type );
  }

}