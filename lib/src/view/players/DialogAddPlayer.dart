import 'package:flutter/material.dart';

//provider
import 'package:scoreboard/src/bloc/provider.dart';

//Bloc
//import 'package:scoreboard/src/bloc/PlayerBloc.dart';

//Component
import 'package:scoreboard/src/view/players/Component/AddPlayers.dart';

//Muestra un dialogo para agregar jugadores
Future ShowDialogAddPlayers(  BuildContext context ){

  final PlayersBloc playersBloc = Provider.of(context);

  playersBloc.initEmptyPlayer();
  return showDialog(
      context: context,
      builder: ( context ) {
        return DialogAddPlayer();
      }
  );

}

class DialogAddPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final PlayersBloc playersBloc = Provider.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text('Añadir Jugadores'),
      content: AddPlayers(),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Agregar'),
          onPressed: () async{

            await playersBloc.addPlayers();
            Navigator.of(context).pop();

          },
        )
      ],
    );
  }
}
