import 'dart:async';
import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/AudioPlayerState.dart';
import 'package:bhakti_bhoomi/singletons/AudioPlayerSingleton.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  final audioPlayer= AudioPlayerSingleton().audioPlayer;
  Audioplayerstate? audioPlayerState;
  List<StreamSubscription> subscriptions=[];

  @override
  initState() {
    loadMantraAudio(mantraAudioId: widget.mantraAudioId);
    initPlayerState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Mantra 🎧',
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Kalam",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:  BlocBuilder<MantraBloc, MantraState>(
          buildWhen: (previous, current) => previous.allMantrasAudios!=current.allMantrasAudios,
          builder: (context, state) {
            final mantraAudio=state.getMantraAudioById(mantraAudioId: widget.mantraAudioId);
            final isThisAudioPlaying=mantraAudio!=null && (audioPlayer.source.toString()==UrlSource(mantraAudio.audioUrl).toString());

            return mantraAudio!=null ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(mantraAudio.thumbnail,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress!=null ? const SpinKitDoubleBounce(color: Colors.green):child,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined),
                        fit: BoxFit.cover,
                      ),
                  ),
                  height: mediaQuery.size.height*0.5,
                  width: double.infinity,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(mantraAudio.title['en']!,),
                    Column(
                      children: [
                        Slider(value: isThisAudioPlaying ? (audioPlayerState?.position?.inSeconds ?? 0).toDouble() : 0, onChanged: isThisAudioPlaying ? (position){
                          audioPlayer.seek(Duration(milliseconds: (position*1000).toInt()));
                        }:null,max: audioPlayerState?.duration?.inSeconds.toDouble() ?? 0.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Utils.formatDuration(isThisAudioPlaying ?(audioPlayerState?.position?.inSeconds ?? 0):0)),
                              Text(Utils.formatDuration(isThisAudioPlaying ? (audioPlayerState?.duration?.inSeconds ?? 0):0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(onPressed: ()async =>{}, icon: const Icon(FontAwesomeIcons.backwardStep)),
                        if((audioPlayerState?.isPlayLoading==true || audioPlayerState?.isPauseLoading==true))
                          const SpinKitCircle(color: Colors.green,size: 48.0)
                        else IconButton(onPressed: () =>onPlayPauseAudio(play:!isThisAudioPlaying || audioPlayerState?.playerState!=PlayerState.playing,url:mantraAudio.audioUrl), icon: isThisAudioPlaying && audioPlayerState?.playerState==PlayerState.playing ? const Icon(FontAwesomeIcons.pause) : const  Icon(FontAwesomeIcons.play)),
                        IconButton(onPressed: ()async =>{}, icon: const Icon(FontAwesomeIcons.forwardStep)),
                      ],
                    ),
                  ],
                )
              ],
            ):Center(child: state.isError(forr: Httpstates.MANTRA_AUDIO_BY_ID)
                ? RetryAgain(onRetry: ()=>this.loadMantraAudio(mantraAudioId: widget.mantraAudioId), error: state.getError(forr: Httpstates.MANTRA_AUDIO_BY_ID)!.message)
                : Padding(padding: const EdgeInsets.symmetric(vertical: 20),child: SpinKitChasingDots(color: Theme.of(context).primaryColor, size: 24)));
          }),
        );
  }

  void loadMantraAudio({required String mantraAudioId}) {
    token?.cancel("cancelled");
    token=CancelToken();
    BlocProvider.of<MantraBloc>(context).add(FetchMantraAudioById(id: mantraAudioId, cancelToken: token));
  }

  void initPlayerState() {
    audioPlayerState=Audioplayerstate(playerState: audioPlayer.state);
    audioPlayer.getDuration().then((duration) => audioPlayerState?.duration=duration);
    subscriptions.add(audioPlayer.onPlayerStateChanged.listen((event) {
      if (mounted) setState(() => audioPlayerState?.playerState = event);
    }));
    subscriptions.add(audioPlayer.onDurationChanged.listen((duration)=>setState(()=>audioPlayerState?.duration = duration)));
    subscriptions.add(audioPlayer.onPositionChanged.listen((duration) =>setState(() => audioPlayerState?.position = duration)));
  }

  @override
  void dispose() {
    token?.cancel("cancelled");
    subscriptions.forEach((subscription)=>subscription.cancel());
    super.dispose();
  }

  onPlayPauseAudio({required bool play,required String url})async {
    try{
      if(!play){
        setState(()=>audioPlayerState?.patchWith(isPauseLoading:true));
        await audioPlayer.pause();
        setState(()=>audioPlayerState?.patchWith(isPauseLoading:false));
      }else{
        setState(()=>audioPlayerState?.patchWith(isPlayLoading:true));
        await audioPlayer.play(UrlSource(url));
        setState(()=>audioPlayerState?.patchWith(isPlayLoading:false));
      }
    }catch(e){
      setState(()=>audioPlayerState?.patchWith(isPlayLoading:false,isPauseLoading: false));
    }
  }

}