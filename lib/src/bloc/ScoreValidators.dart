import 'dart:async';



class ScoreValidators {

  final validateStreak = StreamTransformer<Map, Map>.fromHandlers(
      handleData: ( streak, sink ) {

        print( streak );
        print( sink );

        return sink.add( {} );
      }
  );

}
