import 'package:flutter/material.dart';

//Bloc
import 'package:scoreboard/src/bloc/PlayerBloc.dart';
import 'package:scoreboard/src/bloc/ScoreBloc.dart';

//Model
import 'package:scoreboard/src/model/player_model.dart';

//View
import 'package:scoreboard/src/view/CustomAppBar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final playersBloc = new PlayersBloc();
    final scoreBloc = new ScoreBloc();

    //scoreBloc.getActiveScores();

    return Scaffold(
      appBar: HomeAppBarHome( title: Text('ScoreBoard'), playersBloc: playersBloc, ),
      body: pintarUsuarios( playersBloc ),
    );

  }

  Widget pintarUsuarios( playersBloc ){

    //playersBloc.playersStream.length
    return StreamBuilder<List<PlayerModel>>(
      stream: playersBloc.playersStream,
      builder: (BuildContext context, AsyncSnapshot<List<PlayerModel>> snapshot) {

        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final player = snapshot.data;

        if ( player.length == 0 ) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
            itemCount: player.length,
            itemBuilder: (context, i ) => Dismissible(
                key: UniqueKey(),
                background: Container( color: Colors.red ),
                //onDismissed: ( direction ) => scansBloc.borrarScan(scans[i].id),
                child: ListTile(
                  leading: Icon( Icons.map, color: Theme.of(context).primaryColor ),
                  title: Text( player[i].name ),
                  subtitle: Text('ID: ${ player[i].image }'),
                  trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey ),
                  onTap: () => {},
                )
            )
        );


      },
    );

  }

}
