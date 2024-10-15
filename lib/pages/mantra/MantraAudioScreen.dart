import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/AudioPlayerState.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraAudioModel.dart';
import 'package:bhakti_bhoomi/singletons/AudioPlayerSingleton.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MantraAudioScreen extends StatefulWidget {
  final String title;
  final String mantraAudioId;

  const MantraAudioScreen(
      {super.key, required this.title, required this.mantraAudioId});

  @override
  State<MantraAudioScreen> createState() =>
      _MantraAudioScreenState();
}

class _MantraAudioScreenState extends State<MantraAudioScreen> {
  CancelToken? token;
  AudioPlayerState audioplayerState=AudioPlayerState();
  List<StreamSubscription> subscriptions=[];
  final audio=AudioPlayerSingleton();
  
  @override
  initState() {
    initAudioPlayerState();
    loadMantraAudio(mantraAudioId: widget.mantraAudioId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Mantra 🎧',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Kalam",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:  BlocBuilder<MantraBloc, MantraState>(
          buildWhen: (previous, current) => previous.allMantrasAudios[widget.mantraAudioId]!=current.allMantrasAudios[widget.mantraAudioId],
          builder: (_, mantraState) {
            final mantraAudio=mantraState.getMantraAudioById(mantraAudioId: widget.mantraAudioId);
            return mantraAudio!=null ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 24.0),
                  height: mediaQuery.size.height*0.5,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(mantraAudio.thumbnail,
                      loadingBuilder: (context, child, loadingProgress) => loadingProgress!=null ? const SpinKitDoubleBounce(color: Colors.green):child,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(mantraAudio.title['en']!,),
                    Column(
                      children: [
                        Slider(value: audio.isPlaying(url: mantraAudio.audioUrl) ? (audioplayerState.position?.inSeconds ?? 0).toDouble() : 0,
                          onChanged: audio.isPlaying(url: mantraAudio.audioUrl) && !audioplayerState.isPlayLoading && !audioplayerState.isSeekLoading ? (position){
                          setState(()=>audioplayerState=audioplayerState.copyWith(isSeekLoading: true));
                          audio.player.seek(Duration(milliseconds: (position*1000).toInt()));
                        }:null,max: audioplayerState.duration?.inSeconds.toDouble() ?? 0.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Utils.formatDuration(audio.isPlaying(url: mantraAudio.audioUrl) ? (audioplayerState.position?.inSeconds ?? 0):0)),
                              Text(Utils.formatDuration(audio.isPlaying(url: mantraAudio.audioUrl) ? (audioplayerState.duration?.inSeconds ?? 0):0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(onPressed: null, icon: const Icon(FontAwesomeIcons.backwardStep)),
                        if(audio.isPlaying(url: mantraAudio.audioUrl) && (audioplayerState.isPlayLoading || audioplayerState.isPauseLoading))
                          const SpinKitCircle(color: Colors.green,size: 48.0)
                        else IconButton(onPressed: (){
                          if(!audio.isPlaying(url: mantraAudio.audioUrl) || audioplayerState.playerState!=PlayerState.playing){
                            setState(()=>audioplayerState=audioplayerState.copyWith(isPlayLoading: true));
                            audio.player.play(UrlSource(mantraAudio.audioUrl));
                          }
                          else{
                            setState(()=>audioplayerState=audioplayerState.copyWith(isPauseLoading: true));
                            audio.player.pause();
                          }
                        }, icon: audio.isPlaying(url: mantraAudio.audioUrl) && audioplayerState.playerState==PlayerState.playing ? const Icon(FontAwesomeIcons.pause) : const  Icon(FontAwesomeIcons.play)),
                        IconButton(onPressed: null, icon: const Icon(FontAwesomeIcons.forwardStep)),
                      ],
                    ),
                  ],
                )
              ],
            ):Center(child: mantraState.isError(forr: Httpstates.MANTRA_AUDIO_BY_ID)
                ? RetryAgain(onRetry: ()=>this.loadMantraAudio(mantraAudioId: widget.mantraAudioId), error: mantraState.getError(forr: Httpstates.MANTRA_AUDIO_BY_ID)!.message)
                : Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitChasingDots(color: Theme.of(context).primaryColor, size: 24)));
          }),
        );
  }

  void loadMantraAudio({required String mantraAudioId}) {
    token?.cancel("cancelled");
    token=CancelToken();
    BlocProvider.of<MantraBloc>(context).add(FetchMantraAudioById(id: mantraAudioId, cancelToken: token));
  }
  
  void initAudioPlayerState() async{
    Duration? totalDuration=await audio.player.getDuration();
    if(totalDuration!=null){
      setState(()=>audioplayerState=audioplayerState.copyWith(duration: totalDuration));
    }
    subscriptions.add(audio.player.onSeekComplete.listen((_) => setState(()=>audioplayerState=audioplayerState.copyWith(isSeekLoading: false))));
    subscriptions.add(audio.player.onDurationChanged.listen((duration) => setState(()=>audioplayerState=audioplayerState.copyWith(duration: duration))));
    subscriptions.add(audio.player.onPositionChanged.listen((duration) => setState(()=>audioplayerState=audioplayerState.copyWith(position: duration))));
    subscriptions.add(audio.player.onPlayerStateChanged.listen((playerState) => setState(()=>audioplayerState=audioplayerState.copyWith(playerState: playerState,isPlayLoading: playerState==PlayerState.playing ? false:null,isPauseLoading: playerState==PlayerState.paused ? false:null))));
  }
  

  void loadNextAudio({required MantraAudioModel nextMantraAudio}) {

  }

  void loadPreviousAudio({required MantraAudioModel previousMantraAudio}) {
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}