import 'package:flutter/material.dart';

//provider
import 'package:scoreboard/src/bloc/provider.dart';
import 'package:scoreboard/src/db_provider/DBProvider.dart';

//Show dialog about finish the game
class DialogStopGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final HomeBloc homeBloc = Provider.homeBloc(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text('¿Deseas finalizar la partida?'),
      //content: AddPlayers(),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Finalizar'),
          //onPressed: () => homeBloc.endGame(),
          //stop game
          onPressed: () {
            Navigator.of(context).pop();
            //get result about score
            List<List<ScoreModel>> results = homeBloc.getFinalScore();
            return showDialog(
                context: context,
                builder: ( context ) {
                  return DialogShowWinner( results );
                }
            );
          },
        )
      ],
    );
  }
}

//Show the result of the player in the last game
class DialogShowWinner extends StatelessWidget {

  final List<List<ScoreModel>> results;

  DialogShowWinner( this.results );

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text('Partida finalizada'),
      content: _content( results ),
      actions: <Widget>[
        FlatButton(
          child: Text('Aceptar'),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
      ],
    );

  }

  Widget _content( List<List<ScoreModel>> results ){

    final String _textWinners = results.length == 1 ? 'Ganador:' : "Ganadores:";

    final String _textLosers = results.length == 1 ? 'Perdedor:' : "Perdedor:";

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text( 'Felicidades' ),
          Text( _textWinners ),
          Text( _textLosers ),
        ],
      ),
    );

  }

}
