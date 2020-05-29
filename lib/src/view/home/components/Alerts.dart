import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/provider.dart';
import 'package:scoreboard/src/model/score_model.dart';

void alertDeletePlayer(BuildContext context, ScoreModel score, HomeBloc homeBloc ) {

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
                await homeBloc.deletePlayer( score.id, score.playerId );
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );

}

