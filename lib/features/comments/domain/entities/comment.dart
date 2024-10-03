import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int? id;
  final int? postId;
  final String? name;
  final String? email;
  final String? body;

  const Comment({this.id, this.postId, this.body, this.email, this.name});

  @override
  List<Object?> get props => [id, postId, email, body, name];
}
