import 'dart:math';

import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/services/comment/CommentRepository.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:bhakti_bhoomi/state/comment/comment_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

//TODO : Add comments bloc,event and state -> comments are not cached...
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({required CommentRepository commentRepository}) : super(CommentState.initial()) {
    on<ClearStateEvent>((event, emit) {
      emit(state.copyWith(comments: [], isLoading: false, error: null));
    });

    on<LikeCommentEvent>((event, emit) async {
      emit(state.copyWith(isLoading: false, error: null, comments: _likeUnlikeComment(comments: state.comments, id: event.id, like: true)));
      try {
        await commentRepository.likeComment(id: event.id, cancelToken: event.cancelToken);
      } catch (e) {
        emit(state.copyWith(error: e is DioException ? Utils.handleDioException(e) : 'something went wrong', comments: _likeUnlikeComment(comments: state.comments, id: event.id, like: false)));
      }
    });

    on<UnlikeCommentEvent>((event, emit) async {
      emit(state.copyWith(isLoading: false, error: null, comments: _likeUnlikeComment(comments: state.comments, id: event.id, like: false)));
      try {
        await commentRepository.unlikeComment(id: event.id, cancelToken: event.cancelToken);
      } catch (e) {
        emit(state.copyWith(error: e is DioException ? Utils.handleDioException(e) : 'something went wrong', comments: _likeUnlikeComment(comments: state.comments, id: event.id, like: true)));
      }
    });

    on<GetCommentEvent>((event, emit) async {
      UnimplementedError();
    });

    on<CreateCommentEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final commentData = await commentRepository.createComment(newComment: event.newComment, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, comments: _addComment(comments: state.comments, newCmnts: [commentData.data!])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });

    on<DeleteCommentEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        await commentRepository.deleteComment(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, comments: _deleteComment(comments: state.comments, id: event.id)));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });

    on<GetCommentsByUserIdEvent>((event, emit) async {
      UnimplementedError();
    });

    on<GetCommentsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        // final comments = await commentRepository.getComments(
        //     commentForId: event.commentForId, parentCommentId: event.parentCommentId, pageNo: event.pageNo, pageSize: event.pageSize, cancelToken: event.cancelToken);
        // emit(state.copyWith(isLoading: false, comments: _addComment(comments: state.comments, newCmnts: comments.data!)));
        final demoComments = List.generate(30, (index) {
          final comment = getDemoCommet();
          comment.childComments.clear();
          comment.childComments.addAll(List.generate(Random().nextInt(comment.totalChildComments), (index) {
            int cm = Random().nextInt(5);
            return getDemoCommet(true)
                .copyWith(totalChildComments: 5, childComments: List.generate(cm, (index) => getDemoCommet(true).copyWith(childComments: [], totalChildComments: 0, likeCount: Random().nextInt(10))));
          }));
          return comment;
        });
        emit(state.copyWith(isLoading: false, comments: demoComments));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
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

  List<CommentModel> _addComment({required List<CommentModel> comments, required List<CommentModel> newCmnts}) {
    if (newCmnts.isEmpty) throw Exception('newComments cannot be empty');

    if (newCmnts.first.parentCommentId == null) {
      return [...newCmnts, ...comments];
    }

    for (CommentModel comment in comments) {
      if (comment.id == newCmnts.first.parentCommentId) {
        return [...newCmnts, ...comments];
      }

      final curLen = comment.childComments.length;
      final newComments = _addComment(comments: comment.childComments, newCmnts: newCmnts);
      if (curLen != comment.childComments.length) {
        comment.childComments.clear();
        comment.childComments.addAll(newComments);
        break;
      }
    }
    return comments;
  }

  List<CommentModel> _likeUnlikeComment({required List<CommentModel> comments, required String id, required bool like}) {
    for (CommentModel comment in comments) {
      if (comment.id == id) {
        final commentIndex = comments.indexWhere((comment) => comment.id == id);
        comments[commentIndex] = comments[commentIndex].copyWith(likeCount: comments[commentIndex].likeCount + (like ? 1 : -1));
        return comments;
      }
      final oldLen = comment.childComments.length;
      final newComments = _likeUnlikeComment(comments: comment.childComments, id: id, like: like);
      if (oldLen != newComments.length) {
        comment.childComments.clear();
        comment.childComments.addAll(newComments);
        break;
      }
    }
    return comments;
  }

  CommentModel getDemoCommet([bool isChild = false]) {
    return CommentModel(
        id: "",
        commentForId: "ascsasv",
        username: 'vishnu',
        userId: "userId",
        parentCommentId: isChild ? "parentCommentId" : null,
        profileImageUrl: "https://res.cloudinary.com/dmzcpxynz/image/upload/v1706425748/bhaktiBhoomi/users/profile/kvishnu-845cebf7-a6dd-47b5-a10f-494891ca9e0a.jpg",
        content: "hare krishna hare krishna krishna krishna hare hare hare ram hare ram ram ram hare hare",
        likeCount: 10,
        childComments: [],
        totalChildComments: 10,
        createdAt: DateTime.now());
  }
}
