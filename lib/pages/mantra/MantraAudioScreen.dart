import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/AudioPlayerState.dart';
import 'package:bhakti_bhoomi/singletons/AudioPlayerSingleton.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MantraAudioScreen extends StatefulWidget {
  final String title;
  final String mantraAudioId;

  const MantraAudioScreen({super.key, required this.title, required this.mantraAudioId});

  @override
  State<MantraAudioScreen> createState() => _MantraAudioScreenState();
}

class _MantraAudioScreenState extends State<MantraAudioScreen> {
  CancelToken? token;
  AudioPlayerState audioplayerState = AudioPlayerState();
  List<StreamSubscription> subscriptions = [];
  final audio = AudioPlayerSingleton();

  @override
  void initState() {
    initAudioPlayerState();
    loadMantraAudio(mantraAudioId: widget.mantraAudioId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mantra 🎧',
      subtitle: 'मंत्र · audio',
      body: BlocBuilder<MantraBloc, MantraState>(
        buildWhen: (previous, current) => previous.allMantrasAudios[widget.mantraAudioId] != current.allMantrasAudios[widget.mantraAudioId],
        builder: (_, mantraState) {
          final mantraAudio = mantraState.getMantraAudioById(mantraAudioId: widget.mantraAudioId);
          if (mantraAudio == null) {
            return mantraState.isError(forr: Httpstates.MANTRA_AUDIO_BY_ID)
                ? RetryAgain(onRetry: () => loadMantraAudio(mantraAudioId: widget.mantraAudioId), error: mantraState.getError(forr: Httpstates.MANTRA_AUDIO_BY_ID)!.message)
                : const AppLoader();
          }

          final isThis = audio.isPlaying(url: mantraAudio.audioUrl);
          final isPlaying = isThis && audioplayerState.playerState == PlayerState.playing;
          final busy = isThis && (audioplayerState.isPlayLoading || audioplayerState.isPauseLoading);

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(
                      imageUrl: mantraAudio.thumbnail,
                      width: double.infinity,
                      placeholder: (_, __) => Container(color: AppColors.surface, child: const AppLoader()),
                      errorWidget: (_, __, ___) => Container(color: AppColors.surfaceAlt, child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textFaint)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(mantraAudio.title['en'] ?? '', style: AppTypography.textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.gold,
                    inactiveTrackColor: AppColors.surfaceAlt,
                    thumbColor: AppColors.goldDeep,
                    overlayColor: AppColors.gold.withValues(alpha: 0.2),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: isThis ? (audioplayerState.position?.inSeconds ?? 0).toDouble() : 0,
                    max: audioplayerState.duration?.inSeconds.toDouble() ?? 0.0,
                    onChanged: isThis && !audioplayerState.isPlayLoading && !audioplayerState.isSeekLoading
                        ? (position) {
                            setState(() => audioplayerState = audioplayerState.copyWith(isSeekLoading: true));
                            audio.player.seek(Duration(milliseconds: (position * 1000).toInt()));
                          }
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.formatDuration(isThis ? (audioplayerState.position?.inSeconds ?? 0) : 0), style: AppTypography.textTheme.bodySmall),
                      Text(Utils.formatDuration(isThis ? (audioplayerState.duration?.inSeconds ?? 0) : 0), style: AppTypography.textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: busy
                      ? null
                      : () {
                          if (!isThis || audioplayerState.playerState != PlayerState.playing) {
                            setState(() => audioplayerState = audioplayerState.copyWith(isPlayLoading: true));
                            audio.player.play(UrlSource(mantraAudio.audioUrl));
                          } else {
                            setState(() => audioplayerState = audioplayerState.copyWith(isPauseLoading: true));
                            audio.player.pause();
                          }
                        },
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.terracotta),
                    child: busy
                        ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                        : Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: AppColors.onAccent, size: 36),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  void loadMantraAudio({required String mantraAudioId}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<MantraBloc>(context).add(FetchMantraAudioById(id: mantraAudioId, cancelToken: token));
  }

  void initAudioPlayerState() async {
    Duration? totalDuration = await audio.player.getDuration();
    if (totalDuration != null) {
      setState(() => audioplayerState = audioplayerState.copyWith(duration: totalDuration));
    }
    subscriptions.add(audio.player.onSeekComplete.listen((_) => setState(() => audioplayerState = audioplayerState.copyWith(isSeekLoading: false))));
    subscriptions.add(audio.player.onDurationChanged.listen((duration) => setState(() => audioplayerState = audioplayerState.copyWith(duration: duration))));
    subscriptions.add(audio.player.onPositionChanged.listen((duration) => setState(() => audioplayerState = audioplayerState.copyWith(position: duration))));
    subscriptions.add(audio.player.onPlayerStateChanged.listen((playerState) => setState(() => audioplayerState = audioplayerState.copyWith(playerState: playerState, isPlayLoading: playerState == PlayerState.playing ? false : null, isPauseLoading: playerState == PlayerState.paused ? false : null))));
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
