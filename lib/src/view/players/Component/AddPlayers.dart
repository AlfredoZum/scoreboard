import 'dart:io';

import 'package:flutter/material.dart';

//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//provider
import 'package:scoreboard/src/db_provider/DBProvider.dart';
import 'package:scoreboard/src/bloc/provider.dart';
import 'package:scoreboard/src/view/players/Component/DialogImagePickerType.dart';

//Bloc
//import 'package:scoreboard/src/bloc/PlayerBloc.dart';

class AddPlayers extends StatelessWidget {

  //List _items = [];
  _showImageType( BuildContext context, PlayersBloc playersBloc, int index ){
    //ImagePickerType
    return showDialog(
        context: context,
        builder: ( context ) {
          return DialogImagePickerType( playersBloc, index );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    //final PlayersBloc playersBloc = new PlayersBloc();
    final PlayersBloc playersBloc = Provider.of(context);

    //playersBloc.initEmptyPlayer();

    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        height: SizeConfig.screenHeight / 2,
        child: Column(
          children: <Widget>[
            _btnAddNewPlayer( playersBloc ),
            _screenHomeAddPlayer( playersBloc ),
          ],
        ),
      ),
    );
  }

  Widget _btnAddNewPlayer( PlayersBloc playersBloc ){

    void _addNewTempPlayer( PlayersBloc playersBloc ){
      playersBloc.addTempPlayer();
    }

    return FlatButton(
      child: Text('Agregar'),
      onPressed: () => _addNewTempPlayer( playersBloc ),
    );

  }

  Widget _screenHomeAddPlayer( PlayersBloc playersBloc ){

    return StreamBuilder<List<PlayerModel>>(

        stream: playersBloc.addPlayersStream,
        builder: (BuildContext context, AsyncSnapshot<List<PlayerModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<PlayerModel> players = snapshot.data;

          if (players.length == 0) {
            return Center(
              child: Text('No hay información'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(top: 0.0),
            itemCount: players.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => _formAddPlayer( context, playersBloc, players[index], index ),
          );

        }

    );

  }

  Widget _formAddPlayer( BuildContext context, PlayersBloc playersBloc, PlayerModel player, int index ){

    final _myController = TextEditingController();

    _myController.text = player.name;

    final _deletePlayer = ( index == 0 ) ? Container() : Container(
      child: IconButton(
        icon: Icon(Icons.delete, color: Colors.red,),
        tooltip: 'Increase volume by 10',
        onPressed: () => playersBloc.deletePlayerTemp( index ),
      ),
    );

    String imgProfile = ( player.image == null ) ? 'assets/img/usuario.png' : player.image;

    return Container(
      margin: EdgeInsets.only( bottom: SizeConfig.padding20 ),
      width: double.maxFinite,
      height: 50.0,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only( right: SizeConfig.padding10 ),
            width: 50.0,
            height: 50.0,
            //color: Colors.blue,
            //child: Image.asset('assets/images/lake.jpg'),
            child: GestureDetector(
              // When the child is tapped, show a snackbar.
              onTap: () => _showImageType( context, playersBloc, index ),
              child: ( player.fileImage == null ) ? _imgAssest( imgProfile ) : _imgFile( player.fileImage ) ,
              //child: Image.file( player.fileImage ),
              // The custom button
              /*child: FadeInImage(
                image: ( player.fileImage == null ) ? AssetImage( imgProfile ) : FileImage( player.fileImage ),
                //image: FileImage(  ),
                placeholder: AssetImage('assets/img/usuario.png'),
                fit: BoxFit.cover,
              ),*/
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                //prefixIcon: Icon(Icons.print),
                hintText: 'Nombre',
              ),
              onChanged: ( String name ) => player.name = name,
              controller: _myController,
            ),
          ),
          _deletePlayer
        ],
      ),
    );

  }

  Widget _imgAssest( String imgProfile ){

    return FadeInImage(
      image: AssetImage( imgProfile ),
      //image: FileImage(  ),
      placeholder: AssetImage('assets/img/usuario.png'),
      fit: BoxFit.cover,
    );

  }

  Widget _imgFile( File fileImage ){

    return Image.file( fileImage );

  }

}
