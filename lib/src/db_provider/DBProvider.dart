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
                  ' date TEXT,'
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
    final res = await db.rawQuery("SELECT * FROM players INNER JOIN score on score.playerId = players.id where score.status = 1;");

    List<PlayerModel> list = res.isNotEmpty
        ? res.map( (c) => PlayerModel.fromJson(c) ).toList()
        : [];
    return list;
  }

  Future<List<ScoreModel>> getActiveScores() async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM score WHERE status = '1';");

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

}