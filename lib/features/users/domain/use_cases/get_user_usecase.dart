import '../entities/user.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/users_repository.dart';

class GetUserUsecase {
  final UsersRepository repository;

  GetUserUsecase(this.repository);

  Future<Either<Failure, User>> call(int id) async {
    return await repository.getUser(id);
  }
}
