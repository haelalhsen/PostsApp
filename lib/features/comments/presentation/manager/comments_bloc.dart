import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app/features/comments/domain/entities/comment.dart';
import 'package:posts_app/features/comments/domain/use_cases/get_comments.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUsecase getCommentsUsecase;
  CommentsBloc({required this.getCommentsUsecase}) : super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) async{
      if (event is GetCommentsEvent) {
        emit(LoadingCommentsState());

        final failureOrComments = await getCommentsUsecase(event.userId);
        emit(_mapFailureOrCommentsToState(failureOrComments));
      }
    });
  }

  CommentsState _mapFailureOrCommentsToState(Either<Failure, List<Comment>> either) {
    return either.fold(
          (failure) => ErrorCommentsState(message: _mapFailureToMessage(failure)),
          (comments) => LoadedCommentsState(
        comments: comments,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
