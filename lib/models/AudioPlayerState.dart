import 'package:audioplayers/audioplayers.dart';

class Audioplayerstate{
  Duration? position;
  Duration? duration;
  PlayerState? playerState;
  bool isPlayLoading;
  bool isPauseLoading;

  Audioplayerstate({this.position,this.duration,this.playerState,this.isPauseLoading=false,this.isPlayLoading=false});

  Audioplayerstate copyWith({
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
    bool? isPlayLoading,
    bool? isPauseLoading,
  }) {
    return Audioplayerstate(
        position:position ?? this.position,
        duration:duration ?? this.duration,
        playerState:playerState ?? this.playerState,
        isPlayLoading:isPlayLoading ?? this.isPlayLoading,
        isPauseLoading:isPauseLoading ?? this.isPauseLoading,
    );
  }

  Audioplayerstate patchWith({
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
    bool? isPlayLoading,
    bool? isPauseLoading,
  }) {
    this.position=position ?? this.position;
    this.duration=duration ?? this.duration;
    this.playerState=playerState ?? this.playerState;
    this.isPlayLoading=isPlayLoading ?? this.isPlayLoading;
    this.isPauseLoading=isPauseLoading ?? this.isPauseLoading;
    return this;
  }
}