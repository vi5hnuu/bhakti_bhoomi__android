import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CommentState extends Equatable {
  final Set<CommentEvent> loadingFor;
  final String? error;
  final List<CommentModel> comments;
  final bool hasMoreComments;
  static const int defaultPageSize = 10;

  const CommentState({this.loadingFor = const {}, this.error, this.comments = const [], this.hasMoreComments = true});

  CommentState copyWith({Set<CommentEvent>? loadingFor, String? error, List<CommentModel>? comments, bool? hasMoreComments}) {
    return CommentState(loadingFor: loadingFor ?? this.loadingFor, error: error, comments: comments ?? this.comments, hasMoreComments: hasMoreComments ?? this.hasMoreComments);
  }

  factory CommentState.initial() => const CommentState();

  @override
  List<Object?> get props => [error, comments, loadingFor];
}
