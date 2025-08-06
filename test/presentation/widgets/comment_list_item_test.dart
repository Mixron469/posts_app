import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/presentation/widgets/comment_list_item.dart';

void main() {
  group('CommentListItem Widget Tests', () {
    const Comment mockComment = Comment(
      postId: 1,
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      body: 'This is a test comment body.',
    );

    testWidgets('displays comment name, email, and body correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentListItem(comment: mockComment),
          ),
        ),
      );

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('This is a test comment body.'), findsOneWidget);
    });

    testWidgets('displays person icon in the row', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentListItem(comment: mockComment),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('applies correct styling to name and email', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentListItem(comment: mockComment),
          ),
        ),
      );

      final Text nameText = tester.widget(find.text('Test User'));
      final Text emailText = tester.widget(find.text('test@example.com'));

      expect(nameText.style?.fontWeight, FontWeight.w600);
      expect(emailText.style?.fontSize, 12);
      expect(emailText.style?.color, Colors.grey[600]);
    });

    testWidgets('applies correct padding and margin', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentListItem(comment: mockComment),
          ),
        ),
      );

      // Find the Card widget
      final Card card = tester.widget(find.byType(Card));
      expect(card.margin, const EdgeInsets.only(bottom: 8));

      // Find the specific Padding widget with EdgeInsets.all(12.0)
      final Finder paddingFinder = find.descendant(
        of: find.byType(CommentListItem),
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is Padding && widget.padding == const EdgeInsets.all(12.0),
        ),
      );

      // Ensure only one Padding widget is found
      expect(paddingFinder, findsOneWidget);

      // Verify the padding
      final Padding padding = tester.widget(paddingFinder);
      expect(padding.padding, const EdgeInsets.all(12.0));
    });

    testWidgets('displays body text without truncation', (WidgetTester tester) async {
      const Comment longComment = Comment(
        postId: 1,
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'This is a very long comment body that should be displayed fully without truncation.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentListItem(comment: longComment),
          ),
        ),
      );

      final Text bodyText = tester.widget(find.textContaining('This is a very long comment body'));

      expect(bodyText.maxLines, isNull); // No truncation
      expect(bodyText.overflow, isNull); // No overflow handling
    });
  });
}
