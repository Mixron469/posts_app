import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';

import 'posts_provider_test.mocks.dart';

@GenerateMocks(<Type>[PostRepository])
void main() {
  late MockPostRepository mockPostRepository;
  late ProviderContainer container;

  setUp(() {
    mockPostRepository = MockPostRepository();
    container = ProviderContainer(
      overrides: <Override>[
        postRepositoryProvider.overrideWithValue(mockPostRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PostsNotifier', () {
    const Post mockPost = Post(
      id: 1,
      userId: 1,
      title: 'Test Post',
      body: 'This is a test post body',
    );

    test('build fetches posts successfully', () async {
      final List<Post> mockPosts = <Post>[mockPost];

      when(mockPostRepository.getPosts()).thenAnswer((_) async => mockPosts);

      final List<Post> result = await container.read(postsNotifierProvider.future);

      expect(result, mockPosts);
      verify(mockPostRepository.getPosts()).called(1);
    });

    test('build handles errors when fetching posts fails', () async {
      when(mockPostRepository.getPosts()).thenThrow(Exception('Failed to fetch posts'));

      expect(
        container.read(postsNotifierProvider.future),
        throwsA(isA<Exception>()),
      );
      verify(mockPostRepository.getPosts()).called(1);
    });

    test('createPost adds a new post to the state', () async {
      const Post newPost = Post(
        id: 2,
        userId: 1,
        title: 'New Post',
        body: 'New post body',
      );

      when(mockPostRepository.getPosts()).thenAnswer((_) async => <Post>[]);
      when(
        mockPostRepository.createPost(
          title: 'New Post',
          body: 'New post body',
        ),
      ).thenAnswer((_) async => newPost);

      final PostsNotifier notifier = container.read(postsNotifierProvider.notifier);

      await notifier.createPost(title: 'New Post', body: 'New post body');

      final AsyncValue<List<Post>> state = container.read(postsNotifierProvider);

      expect(state.value, contains(newPost));
      verify(
        mockPostRepository.createPost(
          title: 'New Post',
          body: 'New post body',
        ),
      ).called(1);
    });

    test('deletePost removes a post from the state', () async {
      final List<Post> initialPosts = <Post>[mockPost];

      when(mockPostRepository.getPosts()).thenAnswer((_) async => initialPosts);
      when(
        mockPostRepository.deletePost(mockPost.id),
      ).thenAnswer((_) async => Future<dynamic>.value());

      final PostsNotifier notifier = container.read(postsNotifierProvider.notifier);

      await notifier.deletePost(mockPost.id);

      final AsyncValue<List<Post>> state = container.read(postsNotifierProvider);

      expect(state.value, isEmpty);
      verify(mockPostRepository.deletePost(mockPost.id)).called(1);
    });
  });
}
