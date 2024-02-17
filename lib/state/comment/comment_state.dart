import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CommentState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<CommentModel> comments;

  const CommentState({
    this.isLoading = true,
    this.error,
    this.comments = const [],
  });

  CommentState copyWith({
    bool? isLoading,
    String? error,
    List<CommentModel>? comments,
  }) {
    return CommentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      comments: comments ?? this.comments,
    );
  }

  factory CommentState.initial() => const CommentState();

  @override
  List<Object?> get props => [isLoading, error, comments];
}
