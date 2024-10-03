import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/users/presentation/manager/user_profile_bloc.dart';
import 'package:posts_app/features/users/presentation/pages/user_profile_page.dart';

import '../../../../../core/strings/messages.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../posts_page/circle_with_text_widget.dart';

class UserInfoWidget extends StatelessWidget {
  final int userId;

  const UserInfoWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserProfileBloc>(context)
        .add(GetUserProfileEvent(userId: userId));
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is ErrorUserProfileState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is LoadingUserProfileState) {
          return const LoadingWidget();
        } else if (state is ErrorUserProfileState) {
          return const Center(
            child: Text(USER_INFO_NOT_LOADED),
          );
        } else if (state is LoadedUserProfileState) {
          return ListTile(
            leading: CircleWithText(
              text: state.user.name![0],
              radius: 18.0, // Radius for the circle
            ),
            title: Text(
              state.user.name!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              state.user.email!,
              style: TextStyle(fontSize: 14),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfilePage(user: state.user),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
