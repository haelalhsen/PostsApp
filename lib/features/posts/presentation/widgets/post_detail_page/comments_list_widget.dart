import 'package:flutter/material.dart';
import 'package:posts_app/features/comments/domain/entities/comment.dart';

class CommentsListWidget extends StatelessWidget {
  final List<Comment> comments;
  const CommentsListWidget({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 30),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            comments[index].name!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            comments[index].body!,
            style: TextStyle(fontSize: 14),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 8,);
      },
    );
  }
}