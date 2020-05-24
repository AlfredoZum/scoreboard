import 'package:flutter/material.dart';
import 'package:scoreboard/src/bloc/provider.dart';
import 'package:scoreboard/src/config/SizeConfig.dart';

void _showDialogFirstTime( BuildContext context ){

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return DialogNameGameFirstTime();
    },
  );

}

class BodyFirstTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final HomeBloc homeBloc = Provider.homeBloc(context);

    return StreamBuilder<bool>(
        stream: homeBloc.initApp,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bool _initApp = snapshot.data;

          if( !_initApp ){
            WidgetsBinding.instance.addPostFrameCallback((_) => _showDialogFirstTime( context ) );

            homeBloc.changeInitApp( true );
            //_showDialog( context );
          }

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Upps!, No tienes ninguna juego registrado',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric( horizontal: SizeConfig.padding20 ),
                  height: SizeConfig.padding10 * 5,
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () => _showDialogFirstTime( context ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Crear juego",
                      style: TextStyle( fontSize: SizeConfig.safeBlockHorizontal * 5 ),
                    ),
                  ),
                ),
              ],
            ),
          );

        }
    );

  }
}


class DialogNameGameFirstTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: new Text("ScoreBoard"),
      content: _createBody( context ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Siguiente"),
          onPressed: () {
            Navigator.of(context).pop();

          },
        ),
      ],
    );

  }

  Widget _createBody( BuildContext context ){

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Parece que es tu primera vez aqui!!",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          SizedBox( height: SizeConfig.padding20 ),
          Text("Crear tu primera partida"),
          SizedBox( height: SizeConfig.padding20 ),
          _textFieldNameGame(),
        ],
      ),
    );

  }

  Widget _textFieldNameGame(){

    return TextField(
      decoration: InputDecoration(
          hintText: 'Nombre del juego'
      ),
    );

  }

}
