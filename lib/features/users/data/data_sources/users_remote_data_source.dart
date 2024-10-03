
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(int id);
}


class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});
  @override
  Future<UserModel> getUser(int id) async {
    final response = await client.get(
      Uri.parse("$BASE_URL/users/$id"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final UserModel userModel = UserModel.fromJson(json.decode(response.body));
      return userModel;
    } else {
      throw ServerException();
    }
  }
}
