import '../../../../../core/app_theme.dart';
import '../../pages/post_detail_page.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/post.dart';
import 'circle_with_text_widget.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostListWidget({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          color: grayColor,
          elevation: 5,
          child: ListTile(
            leading: CircleWithText(
              text: posts[index].id.toString(),
              radius: 20.0, // Radius for the circle
            ),
            title: Text(
              posts[index].title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              posts[index].body,
              style: TextStyle(fontSize: 16),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(post: posts[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

