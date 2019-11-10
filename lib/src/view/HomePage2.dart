import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

//Bloc
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
import 'package:scoreboard/src/bloc/ScoreBloc.dart';

//Model
import 'package:scoreboard/src/model/player_model.dart';

//View
import 'package:scoreboard/src/view/CustomAppBar.dart';

import 'package:scoreboard/src/config/SizeConfig.dart';

import '../config/SizeConfig.dart';
import '../config/SizeConfig.dart';
import '../config/SizeConfig.dart';
import '../db_provider/DBProvider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int getScoreBoard( List<ScoreModel> players ){

    int total = 0;
    players.forEach( ( p ) {
      total = total + p.score;
    });
    return total;

  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    final playersBloc = new PlayersBloc();
    final scoreBloc = new ScoreBloc();

    scoreBloc.getActiveScores();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HomeAppBarHome( title: Text('ScoreBoard'), playersBloc: playersBloc, ),
      body: _screenHome( playersBloc, scoreBloc ),
    );

  }

  Widget _screenHome( PlayersBloc playersBloc, ScoreBloc scoreBloc ){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox( height: SizeConfig.padding10 ),
        _scoreboard( scoreBloc ),
        SizedBox( height: SizeConfig.padding20 ),
        _activePlayers( playersBloc, scoreBloc ),
        //_marker( players ),
      ],
    );

  }

  Widget _scoreboard( ScoreBloc scoreBloc ){

    return StreamBuilder<List<ScoreModel>>(
      stream: scoreBloc.scoreStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScoreModel>> snapshot) {

        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final scores = snapshot.data;

        if ( scores.length == 0 ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        var score2 = scores;

        score2.sort((a,b) => b.updateAt.compareTo(a.updateAt));

        return Center(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                    padding: EdgeInsets.symmetric( horizontal: SizeConfig.padding20, vertical: SizeConfig.padding10 ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Partidas jugadas',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        SizedBox( width: 5.0 ),
                        Text(
                          getScoreBoard( scores ).toString(),
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.4,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox( width: 10.0 ),
                        Tooltip(
                          message: ( getScoreBoard( scores ) <= 0 ) ? "" : score2[0].playerName,
                          child: Icon( Icons.info ),
                        ),
                      ],
                    )
                )
            )
        );

      },
    );

  }



  Widget _activePlayers( PlayersBloc playersBloc, ScoreBloc scoreBloc ){

    return StreamBuilder<List<PlayerModel>>(
      stream: playersBloc.activeplayersStream,
      builder: (BuildContext context, AsyncSnapshot<List<PlayerModel>> snapshot) {

        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final players = snapshot.data;

        if ( players.length == 0 ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        int tempTotalPlayers = ( players.length % 2 == 1 ) ? players.length + 1 : players.length;
        double totalPlayers = tempTotalPlayers / 2;

        print( totalPlayers );
        print( "hey que ondaaa" );

        return Expanded(
          child: SingleChildScrollView(
            child: Table(
              children: List.generate( totalPlayers.toInt(), (index) => _getDataRow( index, players, scoreBloc )),
            ),
          ),
        );


      },
    );

  }

  TableRow _getDataRow( int i, List<PlayerModel> players, ScoreBloc scoreBloc ) {

    int index = i * 2;

    return TableRow(
        children: [
          if( players[index] == null ) Container() else _cardPlayer( players[index], scoreBloc ),
          if( ( players.length - 1 ) < index + 1 ) Container() else _cardPlayer( players[index + 1], scoreBloc ),
        ]
    );
  }

  Widget _cardPlayer( PlayerModel player, ScoreBloc scoreBloc ){

    return GestureDetector(
      // When the child is tapped, show a snackbar.
      //onTap: () => scoreBloc.updateScoreToPlayer( player.id, 'add' ),
      //onLongPress: () => scoreBloc.updateScoreToPlayer( player.id, 'remove' ),
      // The custom button
      child: Container(
        height: 250.0,
        padding: EdgeInsets.all( SizeConfig.padding10 ),
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _infoPlayer( player.name, player.image, scoreBloc ),
              _scoreboardPlayer( scoreBloc, player.id ),
            ],
          ),
        ),
      ),
    );

    /*
    return Container(
      height: 250.0,
      padding: EdgeInsets.all( SizeConfig.padding10 ),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _infoPlayer( player.name, player.image, scoreBloc ),
            _scoreboardPlayer( scoreBloc, player.id ),
          ],
        ),
      ),
    );
    */

  }

  Widget _infoPlayer( String name, String image, ScoreBloc scoreBloc ){

    return Expanded(
      child: Stack(
        children: <Widget>[
          _imagePlayer( image ),
          Column(
            children: <Widget>[
              Expanded( child: Container(), ),
              _namePlayer( name ),
            ],
          ),
        ],
        //color: Colors.red,
      ),
    );

  }

  Widget _imagePlayer( String image ){

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0)
        ),
        child: FadeInImage(
          image: AssetImage( 'assets/players/$image' ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _namePlayer( String name ){

    return Container(
      padding: EdgeInsets.all( SizeConfig.padding10 / 2 ),
      //height: 40.0,
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.w700,
              fontSize: 12.0
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

  }

  Widget _scoreboardPlayer( ScoreBloc scoreBloc, int playerId ){

    return StreamBuilder<List<ScoreModel>>(
      stream: scoreBloc.scoreStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScoreModel>> snapshot) {

        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final scores = snapshot.data;

        if ( scores.length == 0 ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        ScoreModel playerScore = scores.where( ( s ) => s.playerId == playerId ).toList()[0];

        return Container(
          padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
          child: Center(
            child: Text(
              playerScore.score.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );

      },
    );

  }

}
