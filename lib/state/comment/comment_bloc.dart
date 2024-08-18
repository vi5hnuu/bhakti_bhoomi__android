import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/services/comment/CommentRepository.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:bhakti_bhoomi/state/comment/comment_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({required CommentRepository commentRepository}) : super(CommentState.initial()) {
    on<LikeUnlikeCommentEvent>((event, emit) async {
      emit(state.copyWith(loadingFor: {...state.loadingFor}..add(event), error: null));
      try {
        event.like ? await commentRepository.likeComment(id: event.id, cancelToken: event.cancelToken) : await commentRepository.unlikeComment(id: event.id, cancelToken: event.cancelToken);
        bool done = _likeUnlikeComment(comments: state.comments, id: event.id, like: event.like);
        emit(state.copyWith(error: null, loadingFor: {...state.loadingFor}..remove(event), comments: state.comments.map((c) => c.copyWith()).toList()));
      } catch (e) {
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), error: e is DioException ? Utils.handleDioException(e)?.message : 'something went wrong'));
      }
    });

    on<GetCommentEvent>((event, emit) async {
      UnimplementedError();
    });

    on<CreateCommentEvent>((event, emit) async {
      emit(state.copyWith(loadingFor: {...state.loadingFor}..add(event), error: null));
      try {
        final commentData = await commentRepository.createComment(newComment: event.newComment, cancelToken: event.cancelToken);
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), comments: _addComment(comments: state.comments, newCmnts: [commentData.data!], addToTotalChildCommentSize: true)));
      } catch (e) {
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), error: e is DioException ? Utils.handleDioException(e)?.message : 'something went wrong'));
      }
    });

    on<DeleteCommentEvent>((event, emit) async {
      emit(state.copyWith(loadingFor: {...state.loadingFor}..add(event), error: null));
      try {
        await commentRepository.deleteComment(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), comments: _deleteComment(comments: state.comments, id: event.id)));
      } catch (e) {
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), error: e is DioException ? Utils.handleDioException(e)?.message : 'something went wrong'));
      }
    });

    on<GetCommentsByUserIdEvent>((event, emit) async {
      UnimplementedError();
    });

    on<GetCommentsEvent>((event, emit) async {
      emit(state.copyWith(loadingFor: {...state.loadingFor}..add(event), error: null));
      try {
        final comments = await commentRepository.getComments(
            commentForId: event.commentForId, parentCommentId: event.parentCommentId, pageNo: event.pageNo, pageSize: event.pageSize, cancelToken: event.cancelToken);
        emit(state.copyWith(
            loadingFor: {...state.loadingFor}..remove(event),
            hasMoreComments: event.parentCommentId == null ? comments.data?.isNotEmpty : state.hasMoreComments,
            comments: _addComment(comments: state.comments, newCmnts: comments.data!).map((c) => c.copyWith()).toList()));

        // final demoComments = List.generate(5, (index) {
        //   final comment = getDemoCommet();
        //   comment.childComments.clear();
        //   comment.childComments.addAll(List.generate(Random().nextInt(comment.totalChildComments), (index) {
        //     int cm = Random().nextInt(5);
        //     return getDemoCommet(true)
        //         .copyWith(totalChildComments: 5, childComments: List.generate(cm, (index) => getDemoCommet(true).copyWith(childComments: [], totalChildComments: 0, likeCount: Random().nextInt(10))));
        //   }));
        //   return comment;
        // });
        // emit(state.copyWith(loadingFor:{...state.loadingFor}..remove(event), comments: demoComments));
      } catch (e) {
        emit(state.copyWith(loadingFor: {...state.loadingFor}..remove(event), error: e is DioException ? Utils.handleDioException(e)?.message : 'something went wrong'));
      }
    });
  }

  List<CommentModel> _deleteComment({required List<CommentModel> comments, required String id}) {
    for (CommentModel comment in comments) {
      if (comment.id == id) {
        return comments.where((comment) => comment.id != id).toList();
      }

      final curLen = comment.childComments.length;
      final newComments = _deleteComment(comments: comment.childComments, id: id);

      if (curLen != newComments.length) {
        comment.childComments.clear();
        comment.childComments.addAll(newComments);
        break;
      }
    }
    return comments;
  }

  List<CommentModel> _addComment({required List<CommentModel> comments, required List<CommentModel> newCmnts, CommentModel? parentComment, bool addToTotalChildCommentSize = false}) {
    if (newCmnts.isEmpty) return comments;

    if (newCmnts.first.parentCommentId == null) {
      return [...newCmnts, ...comments];
    }

    for (int cIdx = 0; cIdx < comments.length; cIdx++) {
      final comment = comments[cIdx];
      if (comment.id == newCmnts.first.parentCommentId) {
        comments[cIdx] = comment.copyWith(childComments: [...newCmnts, ...comment.childComments], totalChildComments: comment.totalChildComments + (addToTotalChildCommentSize ? newCmnts.length : 0));
        return comments;
      }
      final oldChilCommentsLen = comment.childComments.length;
      final addedComments = _addComment(comments: comment.childComments, newCmnts: newCmnts);
      if (addedComments.length != oldChilCommentsLen) return comments;
    }
    return comments;
  }

  bool _likeUnlikeComment({required List<CommentModel> comments, required String id, required bool like}) {
    for (int i = 0; i < comments.length; i++) {
      final comment = comments[i];
      if (comment.id == id) {
        comments[i] = comment.copyWith(likedByMe: like, likeCount: comment.likeCount + (like ? 1 : -1));
        return true;
      }
      final done = _likeUnlikeComment(comments: comment.childComments, id: id, like: like);
      if (done) return true;
    }
    return false;
  }

  CommentModel getDemoCommet([bool isChild = false]) {
    return CommentModel(
        id: "",
        commentForId: "ascsasv",
        username: 'vishnu',
        userId: "userId",
        likedByMe: false,
        parentCommentId: isChild ? "parentCommentId" : null,
        profileImageUrl: "https://res.cloudinary.com/dmzcpxynz/image/upload/v1706425748/bhaktiBhoomi/users/profile/kvishnu-845cebf7-a6dd-47b5-a10f-494891ca9e0a.jpg",
        content: "hare krishna hare krishna krishna krishna hare hare hare ram hare ram ram ram hare hare",
        likeCount: 10,
        childComments: [],
        totalChildComments: 10,
        createdAt: DateTime.now());
  }
}
