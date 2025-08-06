import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:posts_app/data/services/api_service.dart';

// Generate mocks using: dart run build_runner build
@GenerateMocks(<Type>[Dio, ApiService])
import 'unit_test.mocks.dart';

void main() {
  group('Post Model Tests', () {
    test('creates Post from JSON correctly', () {
      final Map<String, Object> json = <String, Object>{
        'id': 1,
        'userId': 10,
        'title': 'Test Post',
        'body': 'This is a test post body',
      };

      final Post post = Post.fromJson(json);

      expect(post.id, 1);
      expect(post.userId, 10);
      expect(post.title, 'Test Post');
      expect(post.body, 'This is a test post body');
    });

    test('converts Post to JSON correctly', () {
      const Post post = Post(
        id: 1,
        userId: 10,
        title: 'Test Post',
        body: 'This is a test post body',
      );

      final Map<String, dynamic> json = post.toJson();

      expect(json['id'], 1);
      expect(json['userId'], 10);
      expect(json['title'], 'Test Post');
      expect(json['body'], 'This is a test post body');
    });

    test('copyWith creates new instance with updated values', () {
      const Post original = Post(
        id: 1,
        userId: 10,
        title: 'Original Title',
        body: 'Original Body',
      );

      final Post updated = original.copyWith(title: 'Updated Title');

      expect(updated.id, original.id);
      expect(updated.userId, original.userId);
      expect(updated.title, 'Updated Title');
      expect(updated.body, original.body);
      expect(identical(original, updated), false);
    });
  });

  group('Comment Model Tests', () {
    test('creates Comment from JSON correctly', () {
      final Map<String, Object> json = <String, Object>{
        'postId': 1,
        'id': 1,
        'name': 'Test Name',
        'email': 'test@email.com',
        'body': 'Test comment body',
      };

      final Comment comment = Comment.fromJson(json);

      expect(comment.postId, 1);
      expect(comment.id, 1);
      expect(comment.name, 'Test Name');
      expect(comment.email, 'test@email.com');
      expect(comment.body, 'Test comment body');
    });
  });

  group('ApiService Tests', () {
    late MockDio mockDio;
    late ApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = ApiService(mockDio);
    });

    test('getPosts returns list of posts data', () async {
      final List<Map<String, Object>> mockData = <Map<String, Object>>[
        <String, Object>{'id': 1, 'title': 'Post 1', 'body': 'Body 1', 'userId': 1},
        <String, Object>{'id': 2, 'title': 'Post 2', 'body': 'Body 2', 'userId': 1},
      ];

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response<dynamic>(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final List<dynamic> result = await apiService.getPosts();

      expect(result, mockData);
      verify(mockDio.get('/posts')).called(1);
    });

    test('createPost sends correct data', () async {
      final Map<String, Object> postData = <String, Object>{
        'title': 'New Post',
        'body': 'Post body',
        'userId': 1,
      };

      final Map<String, Object> responseData = <String, Object>{
        'id': 101,
        ...postData,
      };

      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response<dynamic>(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final Map<String, dynamic> result = await apiService.createPost(postData);

      expect(result, responseData);
      verify(mockDio.post('/posts', data: postData)).called(1);
    });
  });

  group('PostRepository Tests', () {
    late MockApiService mockApiService;
    late PostRepository repository;

    setUp(() {
      mockApiService = MockApiService();
      repository = PostRepository(mockApiService);
    });

    test('getPosts returns list of Post models', () async {
      final List<Map<String, Object>> mockData = <Map<String, Object>>[
        <String, Object>{'id': 1, 'title': 'Post 1', 'body': 'Body 1', 'userId': 1},
        <String, Object>{'id': 2, 'title': 'Post 2', 'body': 'Body 2', 'userId': 1},
      ];

      when(mockApiService.getPosts()).thenAnswer((_) async => mockData);

      final List<Post> posts = await repository.getPosts();

      expect(posts.length, 2);
      expect(posts[0].title, 'Post 1');
      expect(posts[1].title, 'Post 2');
    });

    test('createPost creates and returns new Post', () async {
      final Map<String, Object> responseData = <String, Object>{
        'id': 101,
        'title': 'New Post',
        'body': 'Post body',
        'userId': 1,
      };

      when(mockApiService.createPost(any)).thenAnswer((_) async => responseData);

      final Post post = await repository.createPost(
        title: 'New Post',
        body: 'Post body',
      );

      expect(post.id, 101);
      expect(post.title, 'New Post');
      expect(post.body, 'Post body');
    });
  });
}
