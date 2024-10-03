import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/comments/data/data_sources/comments_local_data_source.dart';
import 'package:posts_app/features/comments/data/data_sources/comments_remote_data_source.dart';
import 'package:posts_app/features/comments/data/models/comment_model.dart';
import 'package:posts_app/features/comments/data/repositories/comments_repository_impl.dart';

import 'comments_repository_impl_test.mocks.dart';

@GenerateMocks([CommentsRemoteDataSource, CommentsLocalDataSource, NetworkInfo])
void main() {
  late CommentsRepositoryImpl repository;
  late MockCommentsRemoteDataSource mockRemoteDataSource;
  late MockCommentsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCommentsRemoteDataSource();
    mockLocalDataSource = MockCommentsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CommentsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const postId = 1;
  final commentModel = CommentModel(
    id: 1,
    postId: postId,
    email: 'test@test.com',
    name: 'Test User',
    body: 'Test comment body',
  );
  final commentModels = [commentModel];

  group('getAllComment', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // Mock the remote data source behavior for getComments
      when(mockRemoteDataSource.getComments(postId))
          .thenAnswer((_) async => commentModels);
      // Stub cacheComments to ensure it's called successfully
      when(mockLocalDataSource.cacheComments(commentModels,postId))
          .thenAnswer((_) async => Future.value(unit));

      // act
      final result = await repository.getAllComment(postId);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getComments(postId));
      expect(result, Right(commentModels));  // Add an assertion for the result
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getComments(any))
            .thenAnswer((_) async => commentModels);
        // Stub cacheComments to ensure it's called successfully
        when(mockLocalDataSource.cacheComments(commentModels,postId))
            .thenAnswer((_) async => Future.value(unit));

        final result = await repository.getAllComment(postId);

        verify(mockRemoteDataSource.getComments(postId));
        expect(result, equals(Right(commentModels)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getComments(any))
            .thenAnswer((_) async => commentModels);
        // Stub cacheComments to ensure it's called successfully
        when(mockLocalDataSource.cacheComments(commentModels,postId))
            .thenAnswer((_) async => Future.value(unit));

        await repository.getAllComment(postId);

        verify(mockRemoteDataSource.getComments(postId));
        verify(mockLocalDataSource.cacheComments(commentModels, postId));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getComments(any)).thenThrow(ServerException());

        final result = await repository.getAllComment(postId);

        verify(mockRemoteDataSource.getComments(postId));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when the local data is present', () async {
        when(mockLocalDataSource.getCachedComments(any))
            .thenAnswer((_) async => commentModels);

        final result = await repository.getAllComment(postId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedComments(postId));
        expect(result, equals(Right(commentModels)));
      });

      test('should return EmptyCacheFailure when there is no cached data present', () async {
        when(mockLocalDataSource.getCachedComments(any))
            .thenThrow(EmptyCacheException());

        final result = await repository.getAllComment(postId);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedComments(postId));
        expect(result, equals(Left(EmptyCacheFailure())));
      });
    });
  });
}
