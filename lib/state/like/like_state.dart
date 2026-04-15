part of 'like_bloc.dart';

@immutable
class LikeState extends Equatable {
  /// contentId -> LikeStatusModel
  final Map<String, LikeStatusModel> statuses;
  final String? pendingContentId;

  const LikeState({
    this.statuses = const {},
    this.pendingContentId,
  });

  bool isLiked(String contentId) => statuses[contentId]?.likedByMe ?? false;
  int likeCount(String contentId) => statuses[contentId]?.likeCount ?? 0;
  bool isPending(String contentId) => pendingContentId == contentId;

  LikeState withStatus(String contentId, LikeStatusModel status) {
    return LikeState(
      statuses: {...statuses, contentId: status},
      pendingContentId: pendingContentId,
    );
  }

  LikeState copyWith({String? pendingContentId, bool clearPending = false}) {
    return LikeState(
      statuses: statuses,
      pendingContentId: clearPending ? null : (pendingContentId ?? this.pendingContentId),
    );
  }

  @override
  List<Object?> get props => [statuses, pendingContentId];
}
