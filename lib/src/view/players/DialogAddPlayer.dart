import 'package:flutter/material.dart';


//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//provider
import 'package:scoreboard/src/bloc/provider.dart';

//Bloc
//import 'package:scoreboard/src/bloc/PlayerBloc.dart';

//Component
import 'package:scoreboard/src/view/players/Component/AddPlayers.dart';

class DialogAddPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final PlayersBloc playersBloc = Provider.of(context);

    return AlertDialog(
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
