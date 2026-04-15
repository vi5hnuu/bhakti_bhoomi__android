import 'package:bhakti_bhoomi/models/like/LikeStatusModel.dart';
import 'package:bhakti_bhoomi/services/like/LikeRepository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository _repository;

  LikeBloc({LikeRepository? repository})
      : _repository = repository ?? LikeRepository(),
        super(const LikeState()) {
    on<FetchLikeStatusEvent>(_onFetch);
    on<ToggleLikeEvent>(_onToggle);
  }

  Future<void> _onFetch(FetchLikeStatusEvent event, Emitter<LikeState> emit) async {
    try {
      final res = await _repository.getLikeStatus(contentId: event.contentId, cancelToken: event.cancelToken);
      if (res.success && res.data != null) {
        emit(state.withStatus(event.contentId, res.data!));
      }
    } catch (_) {}
  }

  Future<void> _onToggle(ToggleLikeEvent event, Emitter<LikeState> emit) async {
    emit(state.copyWith(pendingContentId: event.contentId));
    try {
      final res = await _repository.toggleLike(contentId: event.contentId, cancelToken: event.cancelToken);
      if (res.success && res.data != null) {
        emit(state.withStatus(event.contentId, res.data!).copyWith(clearPending: true));
      } else {
        emit(state.copyWith(clearPending: true));
      }
    } on DioException {
      emit(state.copyWith(clearPending: true));
    } catch (_) {
      emit(state.copyWith(clearPending: true));
    }
  }
}
