import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/placeholders_widget.dart';

class CommentsLoading extends StatelessWidget {
  const CommentsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 16.0),
              SubTitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SubTitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SubTitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SubTitlePlaceholder(width: 200.0),
              SizedBox(height: 16.0),
              SubTitlePlaceholder(width: 200.0),
            ],
          ),
        ));
  }
}

