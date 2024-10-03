import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> getUser(int id);
}