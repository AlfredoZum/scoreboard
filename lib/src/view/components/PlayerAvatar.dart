import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoreboard/src/config/Utils.dart';

class PlayerAvatar extends StatelessWidget {

  final String image;

  PlayerAvatar( this.image );

  @override
  Widget build(BuildContext context) {

    return FadeInImage(
      image: AssetImage( '$urlImageLocal/avatar/$image' ),
      placeholder: AssetImage('assets/img/no-image.jpg'),
      fit: BoxFit.cover,
    );
  }
}
