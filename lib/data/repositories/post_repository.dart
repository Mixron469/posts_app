import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

@riverpod
/// Provider for post repository
PostRepository postRepository(Ref ref) {
  return PostRepository(ref.watch(apiServiceProvider));
}

/// Repository pattern for business logic and data transformation
class PostRepository {
  final ApiService _apiService;

  PostRepository(this._apiService);

  /// Get all posts and transform to model objects
  Future<List<Post>> getPosts() async {
    final List<dynamic> data = await _apiService.getPosts();
    return data.map((dynamic json) => Post.fromJson(json)).toList();
  }

  /// Get a single post by ID
  Future<Post> getPost(int id) async {
    final Map<String, dynamic> data = await _apiService.getPost(id);
    return Post.fromJson(data);
  }

  /// Get comments for a post
  Future<List<Comment>> getComments(int postId) async {
    final List<dynamic> data = await _apiService.getComments(postId);
    return data.map((dynamic json) => Comment.fromJson(json)).toList();
  }

  /// Create a new post
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final Map<String, dynamic> data = await _apiService.createPost(<String, dynamic>{
      'title': title,
      'body': body,
      'userId': userId,
    });
    return Post.fromJson(data);
  }

  /// Update an existing post
  Future<Post> updatePost(Post post) async {
    final Map<String, dynamic> data = await _apiService.updatePost(post.id, post.toJson());
    return Post.fromJson(data);
  }

  /// Delete a post by ID
  Future<void> deletePost(int id) async {
    await _apiService.deletePost(id);
  }
}
