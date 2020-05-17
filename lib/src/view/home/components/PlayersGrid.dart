import 'package:flutter/material.dart';

//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//provider
import 'package:scoreboard/src/bloc/provider.dart';

//model
import 'package:scoreboard/src/model/score_model.dart';

//Components
import 'package:scoreboard/src/view/components/HomeComponents.dart';
import 'package:scoreboard/src/view/home/components/Alerts.dart';

class PlayersGrid extends StatelessWidget {

  final List<ScoreModel> scores;
  final HomeBloc homeBloc;
  final double totalPlayers;

  PlayersGrid( this.scores, this.homeBloc, this.totalPlayers );

  void _alertDeletePlayer(BuildContext context, ScoreModel scores, HomeBloc homeBloc ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text('Eliminar al jugador'),
            content: Text('¿Deseas eliminar al jugador?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: ()=> Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Eliminar'),
                onPressed: () async{
                  await homeBloc.deletePlayer( scores.id, scores.playerId );
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Table(
        children: List.generate( totalPlayers.toInt(), (index) => _getDataRowGrid( context, index, scores, homeBloc )),
      ),
    );

  }

  TableRow _getDataRowGrid( BuildContext context, int i, List<ScoreModel> scores, HomeBloc homeBloc ) {

    int index = i * 2;

    var score2 = scores.toList();
    score2.sort((a,b) => b.updateAt.compareTo(a.updateAt));

    var maxScore = scores.toList();
    maxScore.sort((a,b) => b.getScore().compareTo(a.getScore()));

    var minScore = scores.toList();
    minScore.sort((a,b) => a.getScore().compareTo(b.getScore()));

    return TableRow(
        children: [
          ( scores[index] == null ) ? null : _cardPlayer( context, scores[index], homeBloc, score2[0].playerId, maxScore[0].getScore(), minScore[0].getScore() ),
          ( ( scores.length - 1 ) < index + 1 ) ? Container() : _cardPlayer( context, scores[index + 1], homeBloc, score2[0].playerId, maxScore[0].getScore(), minScore[0].getScore() ),
        ].where( ( item ) => item != null ).toList()
    );
  }

  Widget _cardPlayer( BuildContext context, ScoreModel scores, HomeBloc homeBloc, int playerId, int maxScore, int minScore ){

    final _borderSideWin = new BorderSide(color: Theme.of(context).primaryColor, width: 2.0);

    final _borderSide = new BorderSide(color: Colors.transparent);

    return Container(
      height: 230.0,
      padding: EdgeInsets.all( SizeConfig.padding10 ),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side:( playerId == scores.playerId ) ? _borderSideWin : _borderSide,
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _infoPlayer( context, scores, maxScore, minScore, homeBloc ),
            _scoreboardPlayer( homeBloc, scores ),
          ],
        ),
      ),
    );

  }

  Widget _infoPlayer( BuildContext context, ScoreModel scores, int maxScore, int minScore, HomeBloc homeBloc ){

    String imgIcon;

    if( scores.getScore() == minScore ){
      imgIcon = "icons8-pavo-96.png";
    }else if( scores.getScore() != 0 && scores.getScore() == maxScore ){
      imgIcon = "trophy.png";
    }

    return Expanded(
      child: GestureDetector(
        // When the child is tapped, show a snackbar.
        onLongPress: () => alertDeletePlayer( context, scores, homeBloc ),
        // The custom button
        child: Stack(
          children: <Widget>[
            _imagePlayer( scores.playerImage ),
            Column(
              children: <Widget>[
                Expanded( child: Container(), ),
                _namePlayer( context, scores.playerName ),
              ],
            ),
            _iconPlayer( image: imgIcon ),
            _streaksPlayer( homeBloc, scores.playerId ),
          ].where( ( item ) => item != null ).toList(),
          //color: Colors.red,
        ),
      ),
    );

  }

  Widget _imagePlayer( String image ) => Container(
    width: double.infinity,
    height: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0)
      ),
      /*child: CachedNetworkImage(
        imageUrl: 'assets/players/$image',
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),*/
      child: PlayerAvatar( image ),
    ),
  );

  Widget _namePlayer( BuildContext context, String name ) => Container(
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

  Widget _iconPlayer( { String image } ){

    if( image == null )
      return Container();

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only( right: 10.0, top: 5.0 ),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: FadeInImage(
            image: AssetImage( 'assets/img/$image' ),
            placeholder: AssetImage('assets/img/loading.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

  }

  Widget _streaksPlayer( HomeBloc homeBloc, int playerId ){

    return StreamBuilder<Map<dynamic, dynamic>>(
        stream: homeBloc.streaksPlayer,
        builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {

          if (!snapshot.hasData) {
            return Container();
          }

          final Map streaks = snapshot.data;

          if( playerId != streaks['playerId'] )
            return Container();

          return Container(
              child: new Text( streaks['total'].toString() ),
              margin: EdgeInsets.only( left: 5.0, top: 1.0 ),
              padding: const EdgeInsets.all(8.0), // borde width
              decoration: new BoxDecoration(
                color: const Color(0xFFFFFFFF), // border color
                shape: BoxShape.circle,
              )
          );

        }

    );

  }

  //ver si esto sirve o eliminar
  Widget _scoreboardPlayer( HomeBloc homeBloc, ScoreModel score ){

    return Container(
      //padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            width: 2.0,
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
      ),
    );

  }

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

    /*return GestureDetector(
      // When the child is tapped, show a snackbar.
      //onTap: () => scoreBloc.updateScoreToPlayer( scores.playerId, 'add' ),
      //onLongPress: () => scoreBloc.updateScoreToPlayer( scores.playerId, 'remove' ),
      // The custom button
      child: ,
    );*/
  }

}
