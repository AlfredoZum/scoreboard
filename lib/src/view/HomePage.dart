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

    //scoreBloc.getActiveScores();

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
        _activePlayers( playersBloc ),
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
                      ],
                    )
                )
            )
        );

      },
    );

  }



  Widget _activePlayers( PlayersBloc playersBloc ){

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

        return Expanded(
          child: SingleChildScrollView(
            child: Table(
              children: List.generate( totalPlayers.toInt(), (index) => _getDataRow( index, players )),
            ),
          ),
        );

        /*return Table(
          children: List.generate( totalPlayers.toInt(), (index) => _getDataRow(players[index])),
        );*/

        /*return Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (BuildContext context, int index){

              var player = players[index];

              print( 'assets/players/${player.image}' );
              print( "'assets/players/'" );

              return DataTable(
                rows: List.generate(results.length, (index) => Container() ),
              );


              return Container();

              return Container(
                child: FadeInImage(
                  image: AssetImage( 'assets/players/${player.image}' ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fadeInDuration: Duration(microseconds: 150),
                  fit: BoxFit.cover,
                ),
              );
              //return _cardPlayer( players[index] );
            },
          ),
        );*/

        /*return Expanded(
          child: GridView.builder(
              itemCount: players.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //childAspectRatio: SizeConfig.blockSizeVertical * .083,
                //childAspectRatio: SizeConfig.blockSizeVertical * 1,
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.6),
              ),
              itemBuilder: (BuildContext context, int index){
                return _cardPlayer( players[index] );
              }
          ),
        );*/

      },
    );

  }

  TableRow _getDataRow( int i, List<PlayerModel> players ) {

    int index = i * 2;

    return TableRow(
        children: [
          if( players[index] == null ) Container() else _cardPlayer( players[index] ),
          if( ( players.length - 1 ) < index + 1 ) Container() else _cardPlayer( players[index + 1] ),
        ]
    );
  }

  Widget _cardPlayer( PlayerModel player ){

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
            _infoPlayer( player.name, player.image ),
            _scoreboardPlayer(  ),
          ],
        ),
      ),
    );

  }

  Widget _infoPlayer( String name, String image ){

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

    /*return Expanded(
      child: Container(
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
        ),
      ),
    );*/

    return Expanded(
      //height: SizeConfig.blockSizeVertical * 22,
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
      ),
    );

  }

  Widget _imagePlayer( String image ){

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0)
      ),
      child: FadeInImage(
        image: AssetImage( 'assets/players/$image' ),
        placeholder: AssetImage('assets/img/loading.gif'),
        fadeInDuration: Duration(microseconds: 150),
        fit: BoxFit.cover,
      ),
    );

    return Container(
      width: 100.0,
      height: 100.0,
      color: Colors.green,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0)
        ),
        child: FadeInImage(
          image: AssetImage( 'assets/players/$image' ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(microseconds: 150),
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

  Widget _scoreboardPlayer(  ){

    return Container(
      padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
      child: Center(
        child: Text(
          '0',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

  }

}
