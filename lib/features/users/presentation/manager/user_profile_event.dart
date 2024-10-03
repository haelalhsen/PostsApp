part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class GetUserProfileEvent extends UserProfileEvent {
  final int userId;

  const GetUserProfileEvent({required this.userId});
  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}