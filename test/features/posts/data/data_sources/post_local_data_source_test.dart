import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This will generate mock classes for these dependencies
@GenerateMocks([SharedPreferences])
import 'post_local_data_source_test.mocks.dart';

void main() {
  late PostLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        PostLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final tPostModel = PostModel(id: 1, title: 'Test Title', body: 'Test Body');
  final tPostModels = [tPostModel];

  test('should return list of PostModels from SharedPreferences when cached',
      () async {
    // arrange
    when(mockSharedPreferences.getString(any)).thenReturn(json.encode([
      {'id': 1, 'title': 'Test Title', 'body': 'Test Body'}
    ]));

    // act
    final result = await dataSource.getCachedPosts();

    // assert
    expect(result, equals(tPostModels));
  });

  test('should throw a EmptyCacheException when no data is present', () async {
    // arrange
    when(mockSharedPreferences.getString(any)).thenReturn(null);

    // act
    final call = dataSource.getCachedPosts;

    // assert
    expect(() => call(), throwsA(isA<EmptyCacheException>()));
  });

  test('should call SharedPreferences to cache data', () async {
    // arrange
    final expectedJsonString = json.encode([
      {'id': 1, 'title': 'Test Title', 'body': 'Test Body'}
    ]);
    when(mockSharedPreferences.setString(CACHED_POSTS, expectedJsonString))
        .thenAnswer((_) async => true);
    // act
    await dataSource.cachePosts(tPostModels);

    // assert
    verify(mockSharedPreferences.setString(
      CACHED_POSTS,
      expectedJsonString,
    ));
  });
}
