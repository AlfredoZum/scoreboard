import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


//Config
import 'package:scoreboard/src/config/SizeConfig.dart';

//Provider
import 'package:scoreboard/src/bloc/provider.dart';

class DialogImagePickerType extends StatelessWidget {

  final int index;
  final PlayersBloc playersBloc;
  DialogImagePickerType( this.playersBloc, this.index );

  _imagePickerByType( BuildContext context, String type ) async{

    Navigator.of(context).pop();

    File image;
    if( type == 'Galeria' ){
      image = await ImagePicker.pickImage(source: ImageSource.gallery);

      //player.fileImage = image;
    }else if( type == 'Camara' ){
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      //player.fileImage = image;
    }
    playersBloc.changeImgAddPlayer( image, index );

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Tipo de imagen'),
      content: _buildTypeImage( context ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
      ],
    );

  }

  Widget _buildTypeImage( BuildContext context ){

    return Container(
      height: SizeConfig.screenHeight / 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildType( context, FontAwesomeIcons.images, 'Galeria' ),
          _buildType( context, FontAwesomeIcons.camera, 'Camara' )
        ],
      ),
    );

  }

  Widget _buildType( BuildContext context, IconData type, String title ){

    final TextStyle styleTitle = TextStyle( fontSize: SizeConfig.blockSizeVertical * 1.7, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600 );

    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(width: 0.5, color: Theme.of(context).primaryColorLight),
        borderRadius: BorderRadius.all(
            Radius.circular(15.0) //         <--- border radius here
        ),
      );
    }

    return InkWell(
      onTap: () => _imagePickerByType( context, title ),
      child: Container(
        padding: EdgeInsets.all(  SizeConfig.padding20 ),
        decoration: myBoxDecoration(),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                radius: 32.0,
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Container(
                  child: Icon( type, size: SizeConfig.blockSizeVertical * 3.6, color: Theme.of(context).primaryColorDark ),
                ),
              ),
              SizedBox( height: SizeConfig.padding20 ),
              Text( title, style: styleTitle,),
            ],
          ),
        ),
      ),
    );

  }

}
