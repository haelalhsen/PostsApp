import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:posts_app/features/posts/data/repositories/post_repository_impl.dart';

// This will generate mock classes for these dependencies
@GenerateMocks([NetworkInfo, PostRemoteDataSource, PostLocalDataSource])
import 'posts_repository_impl_test.mocks.dart';

void main() {
  late PostsRepositoryImpl repository;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockPostLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockLocalDataSource = MockPostLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PostsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tPostModel = PostModel(id: 1, title: 'Test Title', body: 'Test Body');
  final tPostModels = [tPostModel];

  group('getAllPosts', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Mock the remote data source behavior for getAllPosts
      when(mockRemoteDataSource.getAllPosts())
          .thenAnswer((_) async => tPostModels);
      // Stub cachePosts to ensure it's called successfully
      when(mockLocalDataSource.cachePosts(tPostModels))
          .thenAnswer((_) async => Future.value(unit));

      // act
      final result = await repository.getAllPosts();

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getAllPosts());
      expect(result, Right(tPostModels));  // Add an assertion for the result
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getAllPosts())
            .thenAnswer((_) async => tPostModels);
        // Stub cachePosts to ensure it's called successfully
        when(mockLocalDataSource.cachePosts(tPostModels))
            .thenAnswer((_) async => Future.value(unit));

        // act
        final result = await repository.getAllPosts();

        // assert
        verify(mockRemoteDataSource.getAllPosts());
        expect(result, Right(tPostModels));
      });

      test('should cache data locally when remote data is retrieved', () async {
        // arrange
        when(mockRemoteDataSource.getAllPosts())
            .thenAnswer((_) async => tPostModels);
        // Stub cachePosts to ensure it's called successfully
        when(mockLocalDataSource.cachePosts(tPostModels))
            .thenAnswer((_) async => Future.value(unit));

        // act
        await repository.getAllPosts();

        // assert
        verify(mockRemoteDataSource.getAllPosts());
        verify(mockLocalDataSource.cachePosts(tPostModels)); // Verify caching
      });

      test('should return ServerFailure when remote data source throws ServerException', () async {
        // arrange
        when(mockRemoteDataSource.getAllPosts()).thenThrow(ServerException());

        // act
        final result = await repository.getAllPosts();

        // assert
        verify(mockRemoteDataSource.getAllPosts());
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return locally cached data when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getCachedPosts())
            .thenAnswer((_) async => tPostModels);

        // act
        final result = await repository.getAllPosts();

        // assert
        verify(mockLocalDataSource.getCachedPosts());
        expect(result, Right(tPostModels));
      });

      test('should return CacheFailure when there is no cached data', () async {
        // arrange
        when(mockLocalDataSource.getCachedPosts())
            .thenThrow(EmptyCacheException());

        // act
        final result = await repository.getAllPosts();

        // assert
        verify(mockLocalDataSource.getCachedPosts());
        expect(result, Left(EmptyCacheFailure()));
      });
    });
  });
}
