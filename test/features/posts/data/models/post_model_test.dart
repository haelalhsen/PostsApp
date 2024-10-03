import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/posts/data/models/post_model.dart';

void main() {
  final postModel = PostModel(id: 1, title: 'Test Title', body: 'Test Body');

  test('should return a valid model from JSON', () {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "id": 1,
      "title": "Test Title",
      "body": "Test Body"
    };

    // act
    final result = PostModel.fromJson(jsonMap);

    // assert
    expect(result, postModel);
  });

  test('should return a valid JSON map from model', () {
    // arrange
    final Map<String, dynamic> expectedMap = {
      "id": 1,
      "title": "Test Title",
      "body": "Test Body"
    };

    // act
    final result = postModel.toJson();

    // assert
    expect(result, expectedMap);
  });
}
