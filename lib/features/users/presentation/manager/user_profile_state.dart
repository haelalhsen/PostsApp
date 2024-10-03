part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();
}

final class UserProfileInitial extends UserProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadingUserProfileState extends UserProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadedUserProfileState extends UserProfileState {
  final User user;

  const LoadedUserProfileState({required this.user});

  @override
  List<Object> get props => [user];
}

class ErrorUserProfileState extends UserProfileState {
  final String message;

  const ErrorUserProfileState({required this.message});

  @override
  List<Object> get props => [message];
}
