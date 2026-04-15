part of 'like_bloc.dart';

@immutable
sealed class LikeEvent extends Equatable {
  const LikeEvent();
}

class FetchLikeStatusEvent extends LikeEvent {
  final String contentId;
  final CancelToken? cancelToken;
  const FetchLikeStatusEvent({required this.contentId, this.cancelToken});
  @override
  List<Object?> get props => [contentId];
}

class ToggleLikeEvent extends LikeEvent {
  final String contentId;
  final CancelToken? cancelToken;
  const ToggleLikeEvent({required this.contentId, this.cancelToken});
  @override
  List<Object?> get props => [contentId];
}
