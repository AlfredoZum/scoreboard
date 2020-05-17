import 'package:flutter/material.dart';

//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//bloc
import 'package:scoreboard/src/bloc/HomeBloc.dart';

//model
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Components
import 'package:scoreboard/src/view/components/HomeComponents.dart';
import 'package:scoreboard/src/view/home/components/Alerts.dart';

class PlayersList extends StatelessWidget {

  final List<ScoreModel> scores;
  final HomeBloc homeBloc;
  final int totalPlayers;

  PlayersList( this.scores, this.homeBloc, this.totalPlayers );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: totalPlayers,
      itemBuilder: ( BuildContext cxt, int index ){
        return _cardPlayer( context, scores[index] );
      },
    );
  }

  //Show card by player
  Widget _cardPlayer( BuildContext context, ScoreModel score ){

    List<ScoreModel> maxScore = scores.toList();
    maxScore.sort((a,b) => b.getScore().compareTo(a.getScore()));

    List<ScoreModel> minScore = scores.toList();
    minScore.sort((a,b) => a.getScore().compareTo(b.getScore()));

    return GestureDetector(
      onLongPress: () => alertDeletePlayer( context, score, homeBloc ),
      child: Container(
        padding: EdgeInsets.all( SizeConfig.padding10 / 2 ),
        width: double.infinity,
        child: Card(
          child: Container(
            padding: EdgeInsets.all( SizeConfig.padding10 / 2 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _imagePlayer( homeBloc, score.playerImage, score.playerId ),
                SizedBox( width: SizeConfig.padding10 ),
                _iconScore( score, maxScore[0].getScore(), minScore[0].getScore() ),
                _namePlayer( score.playerName ),
                _scoreboardPlayer( homeBloc, score ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _iconScore( ScoreModel score, int maxScore, int minScore ){

    String imgIcon;

    if( score.getScore() == minScore ){
      imgIcon = "icons8-pavo-96.png";
    }else if( score.getScore() != 0 && score.getScore() == maxScore ){
      imgIcon = "trophy.png";
    }

    if( imgIcon == null ) return Container();

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only( right: 10.0, top: 5.0 ),
        child: Container(
          height: 25,
          width: 25,
          child: FadeInImage(
            image: AssetImage( 'assets/img/$imgIcon' ),
            placeholder: AssetImage('assets/img/loading.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

  }

  Expanded _namePlayer( String playerName ) => Expanded(
    child: Text( playerName ),
  );

  Widget _imagePlayer( HomeBloc homeBloc , String image, int playerId ) {

    return Stack(
      children: <Widget>[
        Container(
          width: SizeConfig.padding10 * 5,
          height: SizeConfig.padding10 * 5,
          child: ClipRRect(
            borderRadius: BorderRadius.all( Radius.circular(5.0) ),
            child: PlayerAvatar( image ),
          ),
        ),
        _streaksPlayer( homeBloc, playerId ),
      ],
    );

  }

  Widget _streaksPlayer( HomeBloc homeBloc, int playerId ){

    return StreamBuilder<Map<dynamic, dynamic>>(
        stream: homeBloc.streaksPlayer,
        builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {

          if (!snapshot.hasData) return Container();

          final Map streaks = snapshot.data;

          if( playerId != streaks['playerId'] ) return Container();

          return Positioned(
            top: -5.0,
            right: -5.0,
            child: Container(
                child: new Text( streaks['total'].toString(), style: TextStyle( color: Colors.white ), ),
                padding: const EdgeInsets.all(8.0), // borde width
                decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor, // border color
                  shape: BoxShape.circle,
                )
            ),
          );

        }

    );

  }

  Widget _scoreboardPlayer( HomeBloc homeBloc, ScoreModel score ){

    return Container(
      child: Row(
        children: <Widget>[
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () => homeBloc.updateScoreToPlayer( score.playerId, 'add', 'score' ),
            onLongPress: () => homeBloc.updateScoreToPlayer( score.playerId, 'remove', 'score' ),
            // The custom button
            child: scorePlayer( score.getScore() ),
          ),
          Container(
            color: Colors.black,
            width: 1.0,
            height: 30.0,
          ),
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () => homeBloc.updateScoreToPlayer( score.playerId, 'add', 'assistance' ),
            onLongPress: () => homeBloc.updateScoreToPlayer( score.playerId, 'remove', 'assistance' ),
            // The custom button
            child: scorePlayer( score.assistance ),
          ),
        ],
      )
    );

  }

  //reutilizar
  Widget scorePlayer( int score ){

    return Container(
      width: 50.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

}
