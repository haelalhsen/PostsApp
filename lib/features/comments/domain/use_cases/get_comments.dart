import 'package:dartz/dartz.dart';
import 'package:posts_app/features/comments/domain/entities/comment.dart';

import '../../../../core/error/failures.dart';
import '../repositories/comments_repository.dart';

class GetCommentsUsecase {
  final CommentsRepository repository;

  GetCommentsUsecase(this.repository);

  Future<Either<Failure, List<Comment>>> call(int postId) async {
    return await repository.getAllComment(postId);
  }
}