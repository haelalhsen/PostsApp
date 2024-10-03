import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posts_app/features/comments/data/models/comment_model.dart';

import '../../../../core/constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentModel>> getComments(int postId);
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final http.Client client;

  CommentsRemoteDataSourceImpl({required this.client});
  @override
  Future<List<CommentModel>> getComments(int postId) async {
    final response = await client.get(
      Uri.parse("$BASE_URL/comments?postId=$postId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body) as List;
      final List<CommentModel> commentModels = decodedJson
          .map<CommentModel>((jsonCommentModel) => CommentModel.fromJson(jsonCommentModel))
          .toList();

      return commentModels;
    } else {
      throw ServerException();
    }
  }
}