import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@Riverpod(keepAlive: true)
/// Provider for fetching a single post by ID
class PostNotifier extends _$PostNotifier {
  bool isEdited = false;
  @override
  FutureOr<Post> build(int id) {
    ref.onDispose(() {
      isEdited = false;
    });

    final PostRepository repository = ref.watch(postRepositoryProvider);
    return repository.getPost(id);
  }

  /// Update an existing post
  Future<void> updatePost(Post post) async {
    try {
      final Post updatedPost = await ref.read(postRepositoryProvider).updatePost(post);
      await ref.read(postsNotifierProvider.notifier).updatePost(updatedPost);
      isEdited = true;
      state = AsyncValue<Post>.data(updatedPost);
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<Post>.error(e, st));
      rethrow;
    }
  }
}
