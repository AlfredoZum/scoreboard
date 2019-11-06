import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//Model
import '../model/player_model.dart';
export '../model/player_model.dart';
import '../model/score_model.dart';
export '../model/score_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScoreboardDB.db' );
    print( path );

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: ( Database db, int version ) async {
          await db.execute(
              'CREATE TABLE players ('
                  ' id INTEGER PRIMARY KEY,'
                  ' name TEXT,'
                  ' image TEXT'
                  ')'
          );

          await db.execute(
              'CREATE TABLE score ('
                  ' id INTEGER PRIMARY KEY,'
                  ' playerId INTEGER,'
                  ' score INTEGER,'
                  ' create_at TEXT,'
                  ' update_at TEXT,'
                  ' interval INTEGER,'
                  ' status INTEGER'
                  ')'
          );

        }

    );

  }

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
    final res = await db.rawQuery("SELECT score.*, players.name as playerName, players.image as playerImage  FROM score  INNER JOIN players on players.id = score.playerId WHERE status = '1';");

    print( res );

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
  updateScoreToPlayer( int playerId, String type, String updateAt ) async {

    String mathType = ( type == "add" ) ? "+" : "-";

    final db  = await database;
    final res = await db.rawQuery("UPDATE Score SET score = ( score $mathType 1 ), update_at = '$updateAt' WHERe playerId = $playerId;");
    //final res = await db.insert('score',  scoreModel.toJson() );
    return res;
  }

  //inserta los nuevos jugadores
  endGame() async {

    final db  = await database;
    final res = await db.rawQuery("UPDATE Score SET status = 2 where status = 1;");
    return res;

  }


}