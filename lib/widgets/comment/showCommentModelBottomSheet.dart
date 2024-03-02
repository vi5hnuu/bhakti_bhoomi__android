import 'package:bhakti_bhoomi/services/comment/CommentRepository.dart';
import 'package:bhakti_bhoomi/state/comment/comment_bloc.dart';
import 'package:bhakti_bhoomi/widgets/comment/CommentSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void onComment({required String commentFormId, required BuildContext context}) {
  _showCommentModelBottomSheet(context: context, commentForId: commentFormId);
}

Future<dynamic> _showCommentModelBottomSheet({required BuildContext context, required String commentForId}) {
  // debugPaintSizeEnabled = true;

  return showModalBottomSheet(
      context: context,
      elevation: 5,
      isDismissible: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (modelCtx) {
        return BlocProvider(
          create: (context) => CommentBloc(commentRepository: CommentRepository()),
          child: CommentSheet(commentForId: commentForId),
        );
      }).whenComplete(() {});
}
