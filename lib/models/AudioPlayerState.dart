import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';

class AudioPlayerState extends Equatable{
  Duration? position;
  Duration? duration;
  PlayerState? playerState;
  bool isPauseLoading;
  bool isPlayLoading;
  bool isSeekLoading;

  AudioPlayerState({this.position,
    this.duration,
    this.playerState,
    this.isPauseLoading=false,
    this.isPlayLoading=false,
    this.isSeekLoading=false});

  AudioPlayerState copyWith({
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
    bool? isPauseLoading,
    bool? isPlayLoading,
    bool? isSeekLoading,
  }) {
    return AudioPlayerState(
        position:position ?? this.position,
        duration:duration ?? this.duration,
        playerState:playerState ?? this.playerState,
        isPauseLoading:isPauseLoading ?? this.isPauseLoading,
        isPlayLoading:isPlayLoading ?? this.isPlayLoading,
        isSeekLoading:isSeekLoading ?? this.isSeekLoading
    );
  }

  AudioPlayerState patchWith({
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
    bool? isPauseLoading,
    bool? isPlayLoading,
    bool? isSeekLoading,
  }) {
    this.position=position ?? this.position;
    this.duration=duration ?? this.duration;
    this.playerState=playerState ?? this.playerState;
    isPauseLoading=isPauseLoading ?? this.isPauseLoading;
    isPlayLoading=isPlayLoading ?? this.isPlayLoading;
    isSeekLoading=isSeekLoading ?? this.isSeekLoading;
    return this;
  }

  @override
  List<Object?> get props =>[isPlayLoading,isPauseLoading,isSeekLoading,playerState,duration,position];
}