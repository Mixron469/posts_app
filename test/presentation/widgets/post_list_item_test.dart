import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/presentation/widgets/post_list_item.dart';

void main() {
  group('PostListItem Widget Tests', () {
    const Post mockPost = Post(
      id: 1,
      userId: 1,
      title: 'Test Post Title',
      body: 'This is the body of the test post.',
    );

    testWidgets('displays post title and body correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostListItem(
              post: mockPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('This is the body of the test post.'), findsOneWidget);
    });

    testWidgets('truncates title and body if they exceed max lines', (WidgetTester tester) async {
      const Post longPost = Post(
        id: 1,
        userId: 1,
        title: 'This is a very long title that should be truncated',
        body:
            'This is a very long body text that should also be truncated to fit within the allowed lines.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostListItem(
              post: longPost,
              onTap: () {},
            ),
          ),
        ),
      );

      final Text titleText = tester.widget(find.textContaining('This is a very long title'));
      final Text bodyText = tester.widget(find.textContaining('This is a very long body text'));

      expect(titleText.maxLines, 1);
      expect(bodyText.maxLines, 2);
      expect(titleText.overflow, TextOverflow.ellipsis);
      expect(bodyText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('triggers onTap callback when tapped', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostListItem(
              post: mockPost,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PostListItem));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });
  });
}
