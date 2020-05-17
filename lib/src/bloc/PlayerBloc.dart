import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';

class PlayersBloc {

  final _playerController    = BehaviorSubject<List<PlayerModel>>();
  final _activeplayerController = BehaviorSubject<List<PlayerModel>>();

  final _addPlayersController = BehaviorSubject<List<PlayerModel>>();

  final _pathController = BehaviorSubject<String>();

  Stream<List<PlayerModel>> get playersStream     => _playerController.stream;
  Stream<List<PlayerModel>> get activeplayersStream     => _activeplayerController.stream;

  Stream<List<PlayerModel>> get addPlayersStream     => _addPlayersController.stream;

  Stream<String> get pathStream     => _pathController.stream;

  dispose() {
    _playerController?.close();
    _activeplayerController?.close();
    _addPlayersController?.close();
  }

  //get the player active in the current game
  getActivePlayers() async {
    _activeplayerController.sink.add( await DBProvider.db.getActivePlayers()  );
  }

  //Add a player to the db
  addPlayer( PlayerModel player ) async{
    await DBProvider.db.newPlayer( player );
    getActivePlayers();
  }

  //add players
  addPlayers() async {
    List<PlayerModel> players = _addPlayersController.value;

    for(final PlayerModel p in players){

      if( p.name != null && p.name != '' ){
        if( p.fileImage == null ){
          p.image = 'default.jpg';
        }else{

          final Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String path = documentsDirectory.path;

          if( await Directory(path + '/avatar').exists() ){
            path = join( documentsDirectory.path, 'avatar' );
          }else{
            var dr = Directory(path + '/avatar')..create(recursive: true);
            path = dr.path;
          }

          String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();

          p.image = '${p.name}_$timestamp.jpg';

          final File newImage = await p.fileImage.copy('$path/${p.image}');

        }

        await DBProvider.db.newPlayer( p );
        getActivePlayers();
      }

    }

  }

  initEmptyPlayer() async{
    List<PlayerModel> players = _addPlayersController.value;
    if( players == null )
      _addPlayersController.add( null );
    _addPlayersController.add( [ PlayerModel() ] );
  }

  addTempPlayer() async {
    List<PlayerModel> players = _addPlayersController.value;
    players.add( PlayerModel() );
    _addPlayersController.add( players );
  }

  deletePlayerTemp( int index ) async {

    List<PlayerModel> players = _addPlayersController.value;
    players.removeAt( index );
    _addPlayersController.add( players );

  }

  changeImgAddPlayer( image, int index ) async{
    List<PlayerModel> players = _addPlayersController.value;
    players[index].fileImage = image;
    _addPlayersController.add( players );
  }

  getPathDirectory() async{
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join( documentsDirectory.path, 'avatar' );
    _pathController.add( path );
    //return path;
  }

}