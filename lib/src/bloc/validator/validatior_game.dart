import 'dart:async';

class ValidatorsGame {

  //validate that the field nameGame don't be empty
  final validateNameGame = StreamTransformer<String, String>.fromHandlers(
      handleData: ( nameGame, sink ) {

        if ( nameGame.isEmpty ) {
          sink.addError( 'Escriba el nombre del juego' );
        } else {
          sink.add(nameGame);
        }

      }
  );

}
