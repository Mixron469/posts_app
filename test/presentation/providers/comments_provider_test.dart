// lib/presentation/providers/comments_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:posts_app/presentation/providers/comments_provider.dart';

import 'comments_provider_test.mocks.dart';

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

  group('comments provider', () {
    test('fetches comments successfully', () async {
      const int postId = 1;
      final List<Comment> mockComments = <Comment>[
        const Comment(
          postId: postId,
          id: 1,
          name: 'Test User',
          email: 'test@example.com',
          body: 'Test comment body',
        ),
      ];

      when(mockPostRepository.getComments(postId)).thenAnswer((_) async => mockComments);

      final List<Comment> result = await container.read(commentsProvider(postId).future);

      expect(result, mockComments);
      verify(mockPostRepository.getComments(postId)).called(1);
    });

    test('throws an error when fetching comments fails', () async {
      const int postId = 1;

      when(mockPostRepository.getComments(postId)).thenThrow(Exception('Failed to fetch comments'));

      expect(
        container.read(commentsProvider(postId).future),
        throwsA(isA<Exception>()),
      );
      verify(mockPostRepository.getComments(postId)).called(1);
    });
  });
}
