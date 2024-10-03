import 'package:dartz/dartz.dart';

import 'package:posts_app/core/error/failures.dart';

import 'package:posts_app/features/users/domain/entities/user.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

import '../../domain/repositories/users_repository.dart';
import '../data_sources/users_local_data_source.dart';
import '../data_sources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UserRemoteDataSource remoteDataSource;
  final UsersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UsersRepositoryImpl(
      {required this.remoteDataSource,
        required this.localDataSource,
        required this.networkInfo});

  @override
  Future<Either<Failure, User>> getUser(int id) async{
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUser(id);
        localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUser = await localDataSource.getCachedUser(id);
        return Right(localUser);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }
}