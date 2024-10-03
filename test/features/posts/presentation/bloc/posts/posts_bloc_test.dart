import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/strings/failures.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';


import 'posts_bloc_test.mocks.dart';

// This will generate mock classes for these dependencies
@GenerateMocks([GetAllPostsUsecase])
void main() {
  late PostsBloc bloc;
  late MockGetAllPostsUsecase mockGetAllPosts;

  setUp(() {
    mockGetAllPosts = MockGetAllPostsUsecase();
    bloc = PostsBloc(getAllPosts: mockGetAllPosts);
  });

  // Test the initial state
  test('initial state should be PostsInitial', () {
    expect(bloc.state, equals(PostsInitial()));
  });

  // Helper functions
  final tPost = Post(id: 1, title: 'Test Title', body: 'Test Body');
  final tPostsList = [tPost];

  group('GetAllPostsEvent', () {
    blocTest<PostsBloc, PostsState>(
      'should emit [LoadingPostsState, LoadedPostsState] when data is gotten successfully',
      build: () {
        when(mockGetAllPosts())
            .thenAnswer((_) async => Right(tPostsList));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [
        LoadingPostsState(),
        LoadedPostsState(posts: tPostsList),
      ],
      verify: (_) {
        verify(mockGetAllPosts());
      },
    );

    blocTest<PostsBloc, PostsState>(
      'should emit [LoadingPostsState, ErrorPostsState] when getting data fails due to ServerFailure',
      build: () {
        when(mockGetAllPosts())
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [
        LoadingPostsState(),
        ErrorPostsState(message: SERVER_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(mockGetAllPosts());
      },
    );

    blocTest<PostsBloc, PostsState>(
      'should emit [LoadingPostsState, ErrorPostsState] when getting data fails due to EmptyCacheFailure',
      build: () {
        when(mockGetAllPosts())
            .thenAnswer((_) async => Left(EmptyCacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetAllPostsEvent()),
      expect: () => [
        LoadingPostsState(),
        ErrorPostsState(message: EMPTY_CACHE_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(mockGetAllPosts());
      },
    );
  });

  group('RefreshPostsEvent', () {
    blocTest<PostsBloc, PostsState>(
      'should emit [LoadingPostsState, LoadedPostsState] when data is refreshed successfully',
      build: () {
        when(mockGetAllPosts())
            .thenAnswer((_) async => Right(tPostsList));
        return bloc;
      },
      act: (bloc) => bloc.add(RefreshPostsEvent()),
      expect: () => [
        LoadingPostsState(),
        LoadedPostsState(posts: tPostsList),
      ],
      verify: (_) {
        verify(mockGetAllPosts());
      },
    );

    blocTest<PostsBloc, PostsState>(
      'should emit [LoadingPostsState, ErrorPostsState] when refresh fails due to OfflineFailure',
      build: () {
        when(mockGetAllPosts())
            .thenAnswer((_) async => Left(OfflineFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(RefreshPostsEvent()),
      expect: () => [
        LoadingPostsState(),
        ErrorPostsState(message: OFFLINE_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(mockGetAllPosts());
      },
    );
  });
}
