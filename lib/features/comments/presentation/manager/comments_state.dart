part of 'comments_bloc.dart';

sealed class CommentsState extends Equatable {
  const CommentsState();
}

final class CommentsInitial extends CommentsState {
  @override
  List<Object> get props => [];
}

class LoadingCommentsState extends CommentsState {
  @override
  List<Object?> get props => [];
}

class LoadedCommentsState extends CommentsState {
  final List<Comment> comments;

  const LoadedCommentsState({required this.comments});

  @override
  List<Object> get props => [comments];
}

class ErrorCommentsState extends CommentsState {
  final String message;

  const ErrorCommentsState({required this.message});

  @override
  List<Object> get props => [message];
}
