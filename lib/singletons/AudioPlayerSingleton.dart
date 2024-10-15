import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bhakti_bhoomi/constants/IdGenerators.dart';

class SSAudioPlayer extends AudioPlayer{
  SSAudioPlayer({super.playerId});

  @override
  Future<void> seek(Duration position) {
    return super.seek(position);
  }

  @override
  Future<void> play(Source source, {double? volume, double? balance, AudioContext? ctx, Duration? position, PlayerMode? mode}) {
    return super.play(source, volume: volume, balance: balance, ctx: ctx, position: position, mode: mode);
  }

  @override
  Future<void> pause() {
    return super.pause();
  }

  @override
  Stream<void> get onSeekComplete{
    return super.onSeekComplete.map((event){
      return event;
    });
  }

  @override
  Stream<PlayerState> get onPlayerStateChanged{
   return super.onPlayerStateChanged.map((event){
     return event;
   });
  }
}

class AudioPlayerSingleton {
  final SSAudioPlayer player=SSAudioPlayer(playerId: IdGenerators.generateId());
  static final AudioPlayerSingleton _instance=AudioPlayerSingleton._();

  AudioPlayerSingleton._();

  factory AudioPlayerSingleton(){
    return _instance;
  }

  isPlaying({required String url}){
    final source=player.source;
    if(source==null) return false;
    if(source is UrlSource){
      return source.url==url;
    }else if(source is AssetSource){
      return source.path==url;
    } else if(source is BytesSource){
      return source.bytes.toString()==url;
    }else if(source is DeviceFileSource){
      return source.path==url;
    }
    throw Exception("Invalid source type");
  }

}
