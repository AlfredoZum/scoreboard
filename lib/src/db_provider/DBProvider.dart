import 'dart:io';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//Model
import 'package:scoreboard/src/model/player_model.dart';
export 'package:scoreboard/src/model/player_model.dart';
import 'package:scoreboard/src/model/score_model.dart';
export 'package:scoreboard/src/model/score_model.dart';
import 'package:scoreboard/src/model/game_model.dart';
export 'package:scoreboard/src/model/game_model.dart';
import 'package:scoreboard/src/model/games_played_model.dart';
export 'package:scoreboard/src/model/games_played_model.dart';
import 'package:scoreboard/src/model/setting_model.dart';
export 'package:scoreboard/src/model/setting_model.dart';

//Config
import 'package:scoreboard/src/config/Utils.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    urlImageLocal = documentsDirectory.path;

    final path = join( documentsDirectory.path, 'ScoreboardDB.db' );
    print( path );

    return await openDatabase(
        path,
        version: 1,
        //onOpen: _onOpen,
        //onUpgrade: _onUpdate,
        onOpen: (db) {},
        onCreate: ( Database db, int version ) async {

          await db.execute(
              'CREATE TABLE setting ('
                  ' id INTEGER PRIMARY KEY,'
                  ' firstTime INTEGER,'
                  ' activeGame INTEGER'
                  ')'
          );

          await db.execute(
              'CREATE TABLE games ('
                  ' id INTEGER PRIMARY KEY,'
                  ' name TEXT,'
                  ' create_at TEXT,'
                  ' update_at TEXT,'
                  ' status INTEGER'
                  ')'
          );

          await db.execute(
              'CREATE TABLE gamesPlayed ('
                  ' id INTEGER PRIMARY KEY,'
                  ' gamesId INTEGER,'
                  ' create_at TEXT,'
                  ' update_at TEXT,'
                  ' status INTEGER'
                  ')'
          );

          await db.execute(
              'CREATE TABLE players ('
                  ' id INTEGER PRIMARY KEY,'
                  ' name TEXT,'
                  ' image TEXT'
                  ' create_at TEXT,'
                  ' update_at TEXT, '
                  ' status INTEGER'
                  ')'
          );

          await db.execute(
              'CREATE TABLE score ('
                  ' id INTEGER PRIMARY KEY,'
                  ' gamesPlayedId INTEGER,'
                  ' playerId INTEGER,'
                  ' score INTEGER,'
                  ' create_at TEXT,'
                  ' update_at TEXT,'
                  ' interval INTEGER,'
                  ' assistance INTEGER DEFAULT 0,'
                  ' status INTEGER'
                  ')'
          );

          await db.insert('setting',  { "id"   : null, "firstTime" : 1, "activeGame": 0 } );

        }

    );

  }

  //////////////////////////
  //        setting       //
  //////////////////////////

  Future<SettingModel> getSetting() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM setting");

    SettingModel setting = SettingModel.fromJson(res[0]);

    return setting;

  }

  updateSetting( int firstTime ) async {

    final db  = await database;
    final res = await db.rawQuery("UPDATE setting SET firstTime = $firstTime");
    return res;

  }

  //////////////////////////
  //        games         //
  //////////////////////////

  Future<List<GameModel>> getActiveGame() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM games WHERE games.status = '1';");

    List<GameModel> list = res.isNotEmpty
        ? res.map( (c) => GameModel.fromJson(c) ).toList()
        : [];
    return list;
  }


  Future<int> insertGame( GameModel gameModel ) async {
    final db  = await database;
    final res = await db.insert('games',  gameModel.toJson() );
    return res;
  }



  //////////////////////////
  //     games played     //
  //////////////////////////

  Future<int> insertGamesPlayed( GamesPlayedModel gamesPlayedModel ) async {
    final db  = await database;
    final res = await db.insert('gamesPlayed',  gamesPlayedModel.toJson() );
    return res;
  }

  //////////////////////////

  //inserta los nuevos jugadores
  newPlayer( PlayerModel playerModel ) async {
    final db  = await database;
    final res = await db.insert('players',  playerModel.toJson() );
    return res;
  }

  Future<List<PlayerModel>> getAllPlayers() async {

    final db  = await database;
    final res = await db.query('players');

    List<PlayerModel> list = res.isNotEmpty
        ? res.map( (c) => PlayerModel.fromJson(c) ).toList()
        : [];
    return list;
  }

  Future<List<PlayerModel>> getActivePlayers() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT players.*, score.score FROM players INNER JOIN score on score.playerId = players.id where score.status = 1;");

    List<PlayerModel> list = res.isNotEmpty
        ? res.map( (c) => PlayerModel.fromJson(c) ).toList()
        : [];
    return list;
  }

  Future<List<ScoreModel>> getActiveScores() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT score.*, players.name as playerName, players.image as playerImage  FROM score  INNER JOIN players on players.id = score.playerId WHERE score.status = '1';");

    List<ScoreModel> list = res.isNotEmpty
        ? res.map( (c) => ScoreModel.fromJson(c) ).toList()
        : [];
    return list;
  }

  Future<List<ScoreModel>> getLastScore() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM score ORDER BY id DESC LIMIT 1;");

    List<ScoreModel> list = res.isNotEmpty
        ? res.map( (c) => ScoreModel.fromJson(c) ).toList()
        : [];
    return list;
  }

  //inserta los nuevos jugadores
  addScore( ScoreModel scoreModel ) async {
    final db  = await database;
    final res = await db.insert('score',  scoreModel.toJson() );
    return res;
  }

  //agrega un punto al marcador del jugador
  updateScoreToPlayer( int playerId, String type, String updateAt, String row ) async {

    String mathType = ( type == "add" ) ? "+" : "-";

    String setUpdate = "";
    switch (row) {
      case "score":
        setUpdate = "score = ( score $mathType 1 ), update_at = '$updateAt'";
        break;
      case "assistance":
        setUpdate = "assistance = ( assistance $mathType 1 )";
        break;
    }

    final db  = await database;
    final res = await db.rawQuery("UPDATE Score SET $setUpdate WHERE playerId = $playerId and status = 1");
    //final res = await db.insert('score',  scoreModel.toJson() );
    return res;
  }

  //inserta los nuevos jugadores
  endGame() async {

    final db  = await database;
    final res = await db.rawQuery("UPDATE Score SET status = 2 where status = 1;");
    return res;

  }

  deletePlayerOdScore( int scoreId ) async {

    final db  = await database;
    final res = await db.rawQuery("UPDATE Score SET status = 0 where id = $scoreId;");
    return res;

  }

  deletePlayer( int playerId ) async {

    final db  = await database;
    final res = await db.rawQuery("delete from players where id = $playerId;");
    return res;

  }


}