import 'dart:async';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

class PlayersBloc {

  static final PlayersBloc _singleton = new PlayersBloc._internal();

  factory PlayersBloc() {
    return _singleton;
  }

  PlayersBloc._internal() {
    getActivePlayers();
  }

  final _playerController = StreamController<List<PlayerModel>>.broadcast();
  final _activeplayerController = StreamController<List<PlayerModel>>.broadcast();


  Stream<List<PlayerModel>> get playersStream     => _playerController.stream;
  Stream<List<PlayerModel>> get activeplayersStream     => _activeplayerController.stream;

  dispose() {
    _playerController?.close();
  }

  getActivePlayers() async {
    _activeplayerController.sink.add( await DBProvider.db.getActivePlayers()  );
  }

  addPlayer( PlayerModel player ) async{
    await DBProvider.db.newPlayer( player );
    getActivePlayers();
  }

}