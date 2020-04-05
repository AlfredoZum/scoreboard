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
import 'package:scoreboard/src/view/CustomAppBar.dart';

class HomePage extends StatelessWidget {

  int getScoreBoard( List<ScoreModel> players ){

    int total = 0;
    players.forEach( ( p ) {
      total = total + p.score;
    });
    return total;

  }

  void _alertDeletePlayer(BuildContext context, ScoreModel scores, ScoreBloc scoreBloc ) {

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
                  await scoreBloc.deletePlayer( scores.id, scores.playerId );
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

    SizeConfig().init(context);

    /*final playersBloc = new PlayersBloc();
    final scoreBloc = new ScoreBloc();*/

    final PlayersBloc playersBloc = Provider.of(context);
    final ScoreBloc scoreBloc = Provider.scoreBloc(context);

    scoreBloc.getActiveScores();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HomeAppBarHome( title: Text('ScoreBoard'), playersBloc: playersBloc, context: context ),
      body: _screenHome( playersBloc, scoreBloc ),
    );

  }

  Widget _screenHome( PlayersBloc playersBloc, ScoreBloc scoreBloc ){

    return StreamBuilder<List<ScoreModel>>(

        stream: scoreBloc.scoreStream,
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

          /*var score2 = scores;

          score2.sort((a, b) => b.updateAt.compareTo(a.updateAt));*/

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox( height: SizeConfig.padding10 ),
              _scoreboard( scores ),
              SizedBox( height: SizeConfig.padding20 ),
              _activePlayers( context, scores, scoreBloc ),
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

  Widget _activePlayers( BuildContext context, List<ScoreModel> scores, ScoreBloc scoreBloc ){

    int tempTotalPlayers = ( scores.length % 2 == 1 ) ? scores.length + 1 : scores.length;
    double totalPlayers = tempTotalPlayers / 2;

    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          children: List.generate( totalPlayers.toInt(), (index) => _getDataRow( context, index, scores, scoreBloc )),
        ),
      ),
    );

  }

  TableRow _getDataRow( BuildContext context, int i, List<ScoreModel> scores, ScoreBloc scoreBloc ) {

    int index = i * 2;

    var score2 = scores.toList();
    score2.sort((a,b) => b.updateAt.compareTo(a.updateAt));

    var maxScore = scores.toList();
    maxScore.sort((a,b) => b.getScore().compareTo(a.getScore()));

    var minScore = scores.toList();
    minScore.sort((a,b) => a.getScore().compareTo(b.getScore()));

    return TableRow(
        children: [
          ( scores[index] == null ) ? null : _cardPlayer( context, scores[index], scoreBloc, score2[0].playerId, maxScore[0].getScore(), minScore[0].getScore() ),
          ( ( scores.length - 1 ) < index + 1 ) ? Container() : _cardPlayer( context, scores[index + 1], scoreBloc, score2[0].playerId, maxScore[0].getScore(), minScore[0].getScore() ),
        ].where( ( item ) => item != null ).toList()
    );
  }

  Widget _cardPlayer( BuildContext context, ScoreModel scores, ScoreBloc scoreBloc, int playerId, int maxScore, int minScore ){

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
            _infoPlayer( context, scores, maxScore, minScore, scoreBloc ),
            _scoreboardPlayer( scoreBloc, scores ),
          ],
        ),
      ),
    );

  }

  Widget _infoPlayer( BuildContext context, ScoreModel scores, int maxScore, int minScore, ScoreBloc scoreBloc ){

    String imgIcon;

    if( scores.getScore() == minScore ){
      imgIcon = "icons8-pavo-96.png";
    }else if( scores.getScore() != 0 && scores.getScore() == maxScore ){
      imgIcon = "trophy.png";
    }

    return Expanded(
      child: GestureDetector(
        // When the child is tapped, show a snackbar.
        onLongPress: () => _alertDeletePlayer( context, scores, scoreBloc ),
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
            _streaksPlayer( scoreBloc, scores.playerId ),
          ].where( ( item ) => item != null ).toList(),
          //color: Colors.red,
        ),
      ),
    );

    /*return Expanded(
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
          _streaksPlayer( scoreBloc, scores.playerId ),
        ].where( ( item ) => item != null ).toList(),
        //color: Colors.red,
      ),
    );*/

  }

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

  Widget _streaksPlayer( ScoreBloc scoreBloc, int playerId ){

    return StreamBuilder<Map<dynamic, dynamic>>(
        stream: scoreBloc.streaksPlayer,
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
      child: ( image == 'alfredo.jpg' || image == 'polanco.jpg' || image == 'marcos.jpg' || image == 'cach.jpg' ) ? imaAssest( image ) : imgFile(),
    ),
  );

  Widget imaAssest( String image ){

    /*return StreamBuilder<List<ScoreModel>>(

        stream: scoreBloc.scoreStream,
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

          /*var score2 = scores;

          score2.sort((a, b) => b.updateAt.compareTo(a.updateAt));*/

          return ;

        }

    );*/

    return FadeInImage(
      image: AssetImage( 'assets/players/$image' ),
      placeholder: AssetImage('assets/img/no-image.jpg'),
      fit: BoxFit.cover,
    );
  }

  Widget imgFile(){
    return FadeInImage(
      image: AssetImage( 'assets/img/no-image.jpg' ),
      placeholder: AssetImage('assets/img/no-image.jpg'),
      fit: BoxFit.cover,
    );
  }

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

  Widget _scoreboardPlayer( ScoreBloc scoreBloc, ScoreModel score ){

    return Container(
      //padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () => scoreBloc.updateScoreToPlayer( score.playerId, 'add', 'score' ),
            onLongPress: () => scoreBloc.updateScoreToPlayer( score.playerId, 'remove', 'score' ),
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
            onTap: () => scoreBloc.updateScoreToPlayer( score.playerId, 'add', 'assistance' ),
            onLongPress: () => scoreBloc.updateScoreToPlayer( score.playerId, 'remove', 'assistance' ),
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


/*
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

    return StreamBuilder<List<ScoreModel>>(

        stream: scoreBloc.scoreStream,
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

          /*var score2 = scores;

          score2.sort((a, b) => b.updateAt.compareTo(a.updateAt));*/

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox( height: SizeConfig.padding10 ),
              _scoreboard( scores ),
              SizedBox( height: SizeConfig.padding20 ),
              _activePlayers( scores, scoreBloc ),
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

  Widget _activePlayers( List<ScoreModel> scores, ScoreBloc scoreBloc ){

    int tempTotalPlayers = ( scores.length % 2 == 1 ) ? scores.length + 1 : scores.length;
    double totalPlayers = tempTotalPlayers / 2;

    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          children: List.generate( totalPlayers.toInt(), (index) => _getDataRow( index, scores, scoreBloc )),
        ),
      ),
    );

  }

  TableRow _getDataRow( int i, List<ScoreModel> scores, ScoreBloc scoreBloc ) {

    int index = i * 2;

    var score2 = scores.toList();
    score2.sort((a,b) => b.updateAt.compareTo(a.updateAt));

    var maxScore = scores.toList();
    maxScore.sort((a,b) => b.score.compareTo(a.score));

    return TableRow(
        children: [
          ( scores[index] == null ) ? null : _cardPlayer( scores[index], scoreBloc, score2[0].playerId, maxScore[0].score ),
          ( ( scores.length - 1 ) < index + 1 ) ? null : _cardPlayer( scores[index + 1], scoreBloc, score2[0].playerId, maxScore[0].score  ),
        ].where( ( item ) => item != null ).toList()
    );
  }

  Widget _cardPlayer( ScoreModel scores, ScoreBloc scoreBloc, int playerId, int maxScore ){

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
            _infoPlayer( scores.playerName, scores.playerImage, scores.score, maxScore, scoreBloc ),
            _scoreboardPlayer( scoreBloc, scores ),
          ],
        ),
      ),
    );

  }

  Widget _infoPlayer( String name, String image, int score, int maxScore, ScoreBloc scoreBloc ){

    IconData icon = null;
    Color colorIcon = Colors.white;
    if( score == 0 ){
      icon = FontAwesomeIcons.kiwiBird;
      colorIcon = Colors.blue;
    }else if( score == maxScore ){
      icon = FontAwesomeIcons.trophy;
      colorIcon = Colors.yellow;
    }

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
          _iconPlayer( icon: icon, color : colorIcon ),
        ].where( ( item ) => item != null ).toList(),
        //color: Colors.red,
      ),
    );

  }

  Widget _iconPlayer( { IconData icon, Color color } ){

    if( icon == null )
      return Container();

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only( right: 10.0, top: 5.0 ),
        child: Icon(
          icon,
          size: 30.0,
          color: color,
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
      child: FadeInImage(
        image: AssetImage( 'assets/players/$image' ),
        placeholder: AssetImage('assets/img/loading.gif'),
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _namePlayer( String name ) => Container(
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

  Widget _scoreboardPlayer( ScoreBloc scoreBloc, ScoreModel score ){

    return Container(
      //padding: EdgeInsets.symmetric( vertical: SizeConfig.padding10 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () => scoreBloc.updateScoreToPlayer( score.playerId, 'add', 'score' ),
            onLongPress: () => scoreBloc.updateScoreToPlayer( score.playerId, 'remove', 'score' ),
            // The custom button
            child: scorePlayer( score.score ),
          ),
          Container(
            color: Colors.black,
            width: 2.0,
            height: 30.0,
          ),
          GestureDetector(
            // When the child is tapped, show a snackbar.
            onTap: () => scoreBloc.updateScoreToPlayer( score.playerId, 'add', 'assistance' ),
            onLongPress: () => scoreBloc.updateScoreToPlayer( score.playerId, 'remove', 'assistance' ),
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
*/