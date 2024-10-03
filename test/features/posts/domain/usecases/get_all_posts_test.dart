import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts.dart';

// Create a mock PostsRepository
// Tell mockito to generate a mock class for `PostsRepository`
@GenerateMocks([PostsRepository])

import 'get_all_posts_test.mocks.dart';


void main() {
  late GetAllPostsUsecase usecase;
  late MockPostsRepository mockPostsRepository;

  setUp(() {
    mockPostsRepository = MockPostsRepository();
    usecase = GetAllPostsUsecase(mockPostsRepository);
  });

  final tPosts = [Post(id: 1, title: 'Test Title', body: 'Test Body')];

  test('should get all posts from the repository', () async {
    // arrange
    when(mockPostsRepository.getAllPosts())
        .thenAnswer((_) async => Right(tPosts));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tPosts));
    verify(mockPostsRepository.getAllPosts());
    verifyNoMoreInteractions(mockPostsRepository);
  });

  test('should return failure when there is an error in repository', () async {
    // arrange
    when(mockPostsRepository.getAllPosts())
        .thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase();

    // assert
    expect(result, Left(ServerFailure()));
  });
}
