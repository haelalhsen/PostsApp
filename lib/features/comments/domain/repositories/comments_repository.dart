
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment.dart';

abstract class CommentsRepository {
  Future<Either<Failure, List<Comment>>> getAllComment(int postId);
}
