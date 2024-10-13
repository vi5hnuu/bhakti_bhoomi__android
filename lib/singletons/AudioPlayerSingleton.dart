import 'package:audioplayers/audioplayers.dart';
import 'package:bhakti_bhoomi/constants/IdGenerators.dart';

class AudioPlayerSingleton {
  //assign this key to topmost widget
  final AudioPlayer audioPlayer=AudioPlayer(playerId: IdGenerators.generateId());
  static final AudioPlayerSingleton _instance=AudioPlayerSingleton._();

  AudioPlayerSingleton._();

  factory AudioPlayerSingleton(){
    return _instance;
  }

}
