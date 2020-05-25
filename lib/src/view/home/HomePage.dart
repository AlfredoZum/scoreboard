import 'package:flutter/material.dart';

//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//provider
import 'package:scoreboard/src/bloc/provider.dart';
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Bloc
//import 'package:scoreboard/src/bloc/PlayerBloc.dart';
//import 'package:scoreboard/src/bloc/ScoreBloc.dart';

//Model

//View
import 'package:scoreboard/src/view/appbar/CustomAppBar.dart';

//Components
import 'package:scoreboard/src/view/home/components/components.dart';

class HomePage extends StatelessWidget {

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

    final PlayersBloc playersBloc = Provider.of(context);
    final HomeBloc homeBloc = Provider.homeBloc(context);

    homeBloc.getInitGame();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HomeAppBarHome( title: Text('ScoreBoard'), playersBloc: playersBloc,  homeBloc: homeBloc, context: context ),
      body: _screenHome( playersBloc, homeBloc, context ),
    );

  }

  Widget _screenHome( PlayersBloc playersBloc, HomeBloc homeBloc, BuildContext context ){

    return StreamBuilder<List>(
        stream: homeBloc.getInfoHome,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<GameModel> game = snapshot.data[0] as List<GameModel>;
          final SettingModel setting = snapshot.data[1] as SettingModel;

          if( game.length == 0 ){

            if( setting.firstTime == 1 ){

              return BodyFirstTime();

            }



            return Container();
          }

          return _buildHome();

        }
    );

  }

  Widget _buildHome(){

    return Container(
      child: Text( 'Informacoon obtenida' ),
    );

  }

  Widget _screenHome2( PlayersBloc playersBloc, HomeBloc homeBloc ){

    return StreamBuilder<List<ScoreModel>>(

        stream: homeBloc.scoreStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScoreModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<ScoreModel> scores = snapshot.data;

          if (scores.length == 0) {
            return Center(
              child: Text('No hay información'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox( height: SizeConfig.padding10 ),
              _scoreboard( scores ),
              SizedBox( height: SizeConfig.padding20 ),
              _activePlayers( context, scores, homeBloc ),
              //_marker( players ),
            ],
          );

        }

    );

  }

  Widget _scoreboard( List<ScoreModel> scores ){

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
                  ],
                )
            )
        )
    );

  }

  Widget _activePlayers( BuildContext context, List<ScoreModel> scores, HomeBloc homeBloc ){

    int tempTotalPlayers = ( scores.length % 2 == 1 ) ? scores.length + 1 : scores.length;
    double totalPlayers = tempTotalPlayers / 2;

    return StreamBuilder<String>(
      stream: homeBloc.typeView,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        final String _typeView = snapshot.data == null ? 'grid' : snapshot.data ;

        return Expanded(
          child: _typeView == "grid" ? PlayersGrid( scores, homeBloc, totalPlayers ) : PlayersList( scores, homeBloc, scores.length ),
        );

      },
    );

  }

}