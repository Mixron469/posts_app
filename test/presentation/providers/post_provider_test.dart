import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:posts_app/presentation/providers/post_provider.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';

import 'post_provider_test.mocks.dart';

@GenerateMocks(<Type>[PostRepository, PostsNotifier])
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

  group('PostNotifier', () {
    const int postId = 1;
    const Post mockPost = Post(
      id: postId,
      userId: 1,
      title: 'Test Post',
      body: 'This is a test post body',
    );

    test('build fetches a post successfully', () async {
      when(mockPostRepository.getPost(postId)).thenAnswer((_) async => mockPost);

      final Post result = await container.read(postNotifierProvider(postId).future);

      expect(result, mockPost);
      verify(mockPostRepository.getPost(postId)).called(1);
    });

    test('build handles errors when fetching a post fails', () async {
      when(mockPostRepository.getPost(postId)).thenThrow(Exception('Failed to fetch post'));

      expect(
        container.read(postNotifierProvider(postId).future),
        throwsA(isA<Exception>()),
      );
      verify(mockPostRepository.getPost(postId)).called(1);
    });

    test('updatePost updates a post and sets the state correctly', () async {
      const Post updatedPost = Post(
        id: postId,
        userId: 1,
        title: 'Updated Title',
        body: 'Updated Body',
      );

      when(mockPostRepository.updatePost(any)).thenAnswer((_) async => updatedPost);

      final PostNotifier notifier = container.read(postNotifierProvider(postId).notifier);

      await notifier.updatePost(updatedPost);

      expect(notifier.isEdited, true);
      expect(notifier.state, const AsyncValue<Post>.data(updatedPost));
      verify(mockPostRepository.updatePost(updatedPost)).called(1);
    });

    test('updatePost handles errors when updating a post fails', () async {
      when(mockPostRepository.updatePost(any)).thenThrow(Exception('Failed to update post'));

      final PostNotifier notifier = container.read(postNotifierProvider(postId).notifier);

      expect(
        notifier.updatePost(mockPost),
        throwsA(isA<Exception>()),
      );
      expect(notifier.isEdited, false);
      verify(mockPostRepository.updatePost(mockPost)).called(1);
    });
  });
}
