import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:posts_app/features/comments/domain/repositories/comments_repository.dart';
import 'package:posts_app/features/comments/domain/use_cases/get_comments.dart';
import 'package:posts_app/features/comments/presentation/manager/comments_bloc.dart';
import 'package:posts_app/features/users/data/data_sources/users_local_data_source.dart';
import 'package:posts_app/features/users/data/data_sources/users_remote_data_source.dart';
import 'package:posts_app/features/users/data/repositories/users_repository_impl.dart';
import 'package:posts_app/features/users/domain/repositories/users_repository.dart';
import 'package:posts_app/features/users/domain/use_cases/get_user_usecase.dart';
import 'package:posts_app/features/users/presentation/manager/user_profile_bloc.dart';

import 'core/network/network_info.dart';
import 'features/comments/data/data_sources/comments_local_data_source.dart';
import 'features/comments/data/data_sources/comments_remote_data_source.dart';
import 'features/comments/data/repositories/comments_repository_impl.dart';
import 'features/posts/data/datasources/post_local_data_source.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/posts_repository.dart';
import 'features/posts/domain/usecases/get_all_posts.dart';
import 'features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Feature - posts

// Bloc

  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
// Usecases
  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
// Repository
  sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
// Datasources
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: sl()));

//! Feature - users

// Bloc
  sl.registerFactory(() => UserProfileBloc(getUserUsecase: sl()));
// Usecases
  sl.registerLazySingleton(() => GetUserUsecase(sl()));
// Repository
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
// Datasources

  sl.registerLazySingleton<UserRemoteDataSource>(
          () => UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UsersLocalDataSource>(
          () => UsersLocalDataSourceImpl(sharedPreferences: sl()));

//! Feature - comments

// Bloc
  sl.registerFactory(() => CommentsBloc(getCommentsUsecase: sl()));
// Usecases
  sl.registerLazySingleton(() => GetCommentsUsecase(sl()));
// Repository
  sl.registerLazySingleton<CommentsRepository>(() => CommentsRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
// Datasources
  sl.registerLazySingleton<CommentsRemoteDataSource>(
          () => CommentsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<CommentsLocalDataSource>(
          () => CommentsLocalDataSourceImpl(sharedPreferences: sl()));
//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External


  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnection());
}
