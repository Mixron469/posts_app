import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_provider.g.dart';

@riverpod
/// Provider for fetching comments by post ID
Future<List<Comment>> comments(Ref ref, int postId) async {
  final PostRepository repository = ref.watch(postRepositoryProvider);
  return repository.getComments(postId);
}
