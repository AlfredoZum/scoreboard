import 'dart:async';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

class PlayersBloc {

  static final PlayersBloc _singleton = new PlayersBloc._internal();

  factory PlayersBloc() {
    return _singleton;
  }

  PlayersBloc._internal() {
    getPlayers();
  }

  final _playerController = StreamController<List<PlayerModel>>.broadcast();

  Stream<List<PlayerModel>> get playersStream     => _playerController.stream;

  dispose() {
    _playerController?.close();
  }

  getPlayers() async {
    print( "entra aqui" );
    _playerController.sink.add( await DBProvider.db.getAllPlayers()  );
  }

  addPlayer( PlayerModel player ) async{
    await DBProvider.db.newPlayer( player );
    getPlayers();
  }

}