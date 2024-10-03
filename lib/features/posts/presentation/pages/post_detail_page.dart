import 'package:flutter/material.dart';
import 'package:posts_app/core/app_theme.dart';

import '../../domain/entities/post.dart';
import '../widgets/post_detail_page/comments_widget.dart';
import '../widgets/post_detail_page/post_detail_widget.dart';
import '../widgets/post_detail_page/user_info_widget.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: const Text("Post Detail",),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              PostDetailWidget(post: post),
              UserInfoWidget(userId: post.id!),
              CommentsWidget(userId: post.id!),
            ],
          ),
        ),
      ),
    );
  }
}
