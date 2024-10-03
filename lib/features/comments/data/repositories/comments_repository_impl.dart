import 'package:dartz/dartz.dart';
import 'package:posts_app/features/comments/data/data_sources/comments_local_data_source.dart';
import 'package:posts_app/features/comments/data/data_sources/comments_remote_data_source.dart';
import 'package:posts_app/features/comments/domain/entities/comment.dart';
import 'package:posts_app/features/comments/domain/repositories/comments_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsRemoteDataSource remoteDataSource;
  final CommentsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CommentsRepositoryImpl(
      {required this.remoteDataSource,
        required this.localDataSource,
        required this.networkInfo});

  @override
  Future<Either<Failure, List<Comment>>> getAllComment(int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComments = await remoteDataSource.getComments(postId);
        localDataSource.cacheComments(remoteComments,postId);
        return Right(remoteComments);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localComments = await localDataSource.getCachedComments(postId);
        return Right(localComments);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }
}