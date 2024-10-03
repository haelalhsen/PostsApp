import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_user_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserUsecase getUserUsecase;

  UserProfileBloc({required this.getUserUsecase}) : super(UserProfileInitial()) {
    on<UserProfileEvent>((event, emit) async {
      if (event is GetUserProfileEvent) {
        emit(LoadingUserProfileState());

        final failureOrUser = await getUserUsecase(event.userId);
        emit(_mapFailureOrUserToState(failureOrUser));
      }
    });
  }
  UserProfileState _mapFailureOrUserToState(Either<Failure, User> either) {
    return either.fold(
          (failure) => ErrorUserProfileState(message: _mapFailureToMessage(failure)),
          (user) => LoadedUserProfileState(
        user: user,
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
