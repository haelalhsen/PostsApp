import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UsersLocalDataSource {
  Future<UserModel> getCachedUser(int id);

  Future<Unit> cacheUser(UserModel userModel);
}

const CACHED_USERS = "CACHED_USERS";

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  final SharedPreferences sharedPreferences;

  UsersLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheUser(UserModel userModel) {
    sharedPreferences.setString(
        '$CACHED_USERS/${userModel.id}', json.encode(userModel.toJson()));
    return Future.value(unit);
  }

  @override
  Future<UserModel> getCachedUser(int id) {
    final jsonString = sharedPreferences.getString('$CACHED_USERS/$id');
    if (jsonString != null) {
      UserModel jsonToUserModels =  UserModel.fromJson(json.decode(jsonString));
      return Future.value(jsonToUserModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
