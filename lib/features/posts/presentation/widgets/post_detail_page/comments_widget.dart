import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/comments/presentation/manager/comments_bloc.dart';

import '../../../../../core/strings/messages.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../comments/presentation/widgets/comments_loading_widget.dart';
import 'comments_list_widget.dart';

class CommentsWidget extends StatelessWidget {
  final int userId;

  const CommentsWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CommentsBloc>(context)
        .add(GetCommentsEvent(userId: userId));
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state is ErrorCommentsState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is LoadingCommentsState) {
          return const CommentsLoading();
        } else if (state is ErrorCommentsState) {
          return const Center(
            child: Text(COMMENTS_NOT_LOADED),
          );
        } else if (state is LoadedCommentsState) {
          return CommentsListWidget(comments: state.comments,);
        }
        return const SizedBox();
      },
    );
  }
}