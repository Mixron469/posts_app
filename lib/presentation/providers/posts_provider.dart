import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_provider.g.dart';

@Riverpod(keepAlive: true)
/// State notifier for managing posts list with CRUD operations
class PostsNotifier extends _$PostsNotifier {
  @override
  FutureOr<List<Post>> build() {
    return ref.read(postRepositoryProvider).getPosts();
  }

  /// Create a new post
  Future<void> createPost({required String title, required String body}) async {
    try {
      final Post newPost = await ref
          .read(postRepositoryProvider)
          .createPost(
            title: title,
            body: body,
          );

      state.whenData((List<Post> posts) {
        // Add new post to the beginning of the list
        state = AsyncValue<List<Post>>.data(<Post>[newPost, ...posts]);
      });
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<List<Post>>.error(e, st));
      rethrow;
    }
  }

  /// Update an existing post
  Future<void> updatePost(Post post) async {
    try {
      state.whenData((List<Post> posts) {
        final int index = posts.indexWhere((Post p) => p.id == post.id);
        if (index != -1) {
          final List<Post> newPosts = <Post>[...posts];
          newPosts[index] = post;
          state = AsyncValue<List<Post>>.data(newPosts);
        }
      });
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<List<Post>>.error(e, st));
      rethrow;
    }
  }

  /// Delete a post
  Future<void> deletePost(int id) async {
    try {
      await ref.read(postRepositoryProvider).deletePost(id);

      state.whenData((List<Post> posts) {
        state = AsyncValue<List<Post>>.data(posts.where((Post p) => p.id != id).toList());
      });
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<List<Post>>.error(e, st));
      rethrow;
    }
  }
}
