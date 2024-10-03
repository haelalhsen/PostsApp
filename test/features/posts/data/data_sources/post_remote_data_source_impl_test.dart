import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../../../../lib/features/posts/data/models/post_model.dart';
import '../../../../../lib/features/posts/data/datasources/post_remote_data_source.dart';

// This will generate mock classes for these dependencies
@GenerateMocks([http.Client])
import 'post_remote_data_source_impl_test.mocks.dart';

void main() {
  late PostRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = PostRemoteDataSourceImpl(client: mockHttpClient);
  });

  final postModel = PostModel(id: 1, title: 'Test Title', body: 'Test Body');

  test('should return list of posts when the response is 200', () async {
    // arrange
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
        json.encode([{
          "id": 1,
          "title": "Test Title",
          "body": "Test Body"
        }]),
        200,
      ),
    );

    // act
    final result = await dataSource.getAllPosts();

    // assert
    expect(result, equals([postModel]));
  });
}
