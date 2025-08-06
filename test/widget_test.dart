import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/presentation/widgets/post_list_item.dart';

void main() {
  group('PostListItem Widget Tests', () {
    testWidgets('displays post title and body correctly', (WidgetTester tester) async {
      const Post testPost = Post(
        id: 1,
        userId: 1,
        title: 'Test Title',
        body: 'Test Body Content that is long enough to test text overflow behavior',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostListItem(
              post: testPost,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.textContaining('Test Body Content'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      const Post testPost = Post(
        id: 1,
        userId: 1,
        title: 'Test Title',
        body: 'Test Body',
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostListItem(
              post: testPost,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });
  });
}
