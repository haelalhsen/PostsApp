import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app/features/comments/data/models/comment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class CommentsLocalDataSource {
  Future<List<CommentModel>> getCachedComments(int postId);
  Future<Unit> cacheComments(List<CommentModel> commentModels, int postId);
}

const CACHED_COMMENTS = "CACHED_COMMENTS";

class CommentsLocalDataSourceImpl implements CommentsLocalDataSource {
  final SharedPreferences sharedPreferences;

  CommentsLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cacheComments(List<CommentModel> commentModels,int postId) {
    List commentModelsToJson = commentModels
        .map<Map<String, dynamic>>((commentModel) => commentModel.toJson())
        .toList();
    sharedPreferences.setString('$CACHED_COMMENTS/$postId', json.encode(commentModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<CommentModel>> getCachedComments(int postId) {
    final jsonString = sharedPreferences.getString('$CACHED_COMMENTS/$postId');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<CommentModel> jsonToPostModels = decodeJsonData
          .map<CommentModel>((jsonPostModel) => CommentModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(jsonToPostModels);
    } else {
      throw EmptyCacheException();
    }
  }
}