import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/users/data/data_sources/users_local_data_source.dart';
import 'package:posts_app/features/users/data/data_sources/users_remote_data_source.dart';
import 'package:posts_app/features/users/data/models/user_model.dart';
import 'package:posts_app/features/users/data/repositories/users_repository_impl.dart';

import 'users_repository_impl_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource, UsersLocalDataSource, NetworkInfo])
void main() {
  late UsersRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUsersLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUsersLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UsersRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const int testId = 1;
  const Map<String, dynamic> tUserMap=  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  };
  final UserModel testUserModel = UserModel.fromJson(tUserMap);

  group('getUser', () {
    test('should check if the device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getUser(testId))
          .thenAnswer((_) async => testUserModel);
      when(mockLocalDataSource.cacheUser(testUserModel))
          .thenAnswer((_) async => Future.value(unit));
      // Act
      final result = await repository.getUser(testId);
      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getUser(testId));
      expect(result, Right(testUserModel));  // Add an assertion for the result
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the remote call is successful', () async {
        // Arrange
        when(mockRemoteDataSource.getUser(testId))
            .thenAnswer((_) async => testUserModel);
        when(mockLocalDataSource.cacheUser(testUserModel))
            .thenAnswer((_) async => Future.value(unit));
        // Act
        final result = await repository.getUser(testId);
        // Assert
        verify(mockRemoteDataSource.getUser(testId));
        expect(result, Right(testUserModel));
      });

      test('should cache the data locally when the remote call is successful', () async {
        // Arrange
        when(mockRemoteDataSource.getUser(testId))
            .thenAnswer((_) async => testUserModel);
        when(mockLocalDataSource.cacheUser(testUserModel))
            .thenAnswer((_) async => Future.value(unit));
        // Act
        await repository.getUser(testId);
        // Assert
        verify(mockRemoteDataSource.getUser(testId));
        verify(mockLocalDataSource.cacheUser(testUserModel));
      });

      test('should return server failure when the remote call is unsuccessful', () async {
        // Arrange
        when(mockRemoteDataSource.getUser(testId)).thenThrow(ServerException());
        // Act
        final result = await repository.getUser(testId);
        // Assert
        verify(mockRemoteDataSource.getUser(testId));
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when present', () async {
        // Arrange
        when(mockLocalDataSource.getCachedUser(testId))
            .thenAnswer((_) async => testUserModel);
        // Act
        final result = await repository.getUser(testId);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedUser(testId));
        expect(result, Right(testUserModel));
      });

      test('should return cache failure when there is no cached data', () async {
        // Arrange
        when(mockLocalDataSource.getCachedUser(testId))
            .thenThrow(EmptyCacheException());
        // Act
        final result = await repository.getUser(testId);
        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedUser(testId));
        expect(result, Left(EmptyCacheFailure()));
      });
    });
  });
}
