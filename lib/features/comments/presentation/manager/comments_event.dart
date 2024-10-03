part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();
}
class GetCommentsEvent extends CommentsEvent {
  final int userId;

  const GetCommentsEvent({required this.userId});
  @override
  List<Object?> get props => [userId];
}