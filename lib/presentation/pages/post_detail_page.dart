import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:posts_app/core/gen/assets.gen.dart';
import 'package:posts_app/core/utils/toast_service.dart';
import 'package:posts_app/data/models/comment_model.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/presentation/providers/comments_provider.dart';
import 'package:posts_app/presentation/providers/post_provider.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';
import 'package:posts_app/presentation/widgets/comment_list_item.dart';
import 'package:posts_app/presentation/widgets/comment_list_item_shimmer.dart';
import 'package:posts_app/presentation/widgets/delete_post_dialog.dart';
import 'package:posts_app/presentation/widgets/post_form_dialog.dart';
import 'package:posts_app/presentation/widgets/try_again_widget.dart';

@RoutePage()
class PostDetailPage extends HookConsumerWidget {
  /// Detail page showing post content and comments
  const PostDetailPage({
    super.key,
    @PathParam('id') required this.postId,
  });

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this is a newly created post (id > 100)
    final bool isNewPost = postId > 100;

    // For new posts, get from the local state instead
    final AsyncValue<Post> postAsync = isNewPost
        ? _getNewPostFromState(ref)
        : ref.watch(postNotifierProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          if (!isNewPost)
            postAsync.maybeWhen(
              data: (Post post) => PopupMenuButton<String>(
                onSelected: (String value) {
                  _handleMenuAction(context, ref, value, post);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            ),
        ],
      ),
      body: postAsync.when(
        data: (Post post) => Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildPostDetails(post, isNewPost),
                const Divider(
                  height: 32,
                ),
                _buildCommentsSection(isNewPost),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, _) {
          return Container(
            margin: const EdgeInsets.all(16),
            child: TryAgainWidget(
              message: 'Sorry, something went wrong while loading the post.\nPlease try again',
              onTryAgain: () {
                ref.invalidate(postNotifierProvider(postId));
              },
            ),
          );
        },
      ),
    );
  }

  // Helper method to get new post from local state
  AsyncValue<Post> _getNewPostFromState(WidgetRef ref) {
    return ref
        .watch(postsNotifierProvider)
        .when(
          data: (List<Post> posts) {
            final Post post = posts.firstWhere(
              (Post p) => p.id == postId,
              orElse: () => throw Exception('New post not found in local state'),
            );
            return AsyncValue<Post>.data(post);
          },
          loading: () => const AsyncValue<Post>.loading(),
          error: (Object error, StackTrace stack) => AsyncValue<Post>.error(error, stack),
        );
  }

  Widget _buildPostDetails(Post post, bool isNewPost) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        final bool isEditedPost = ref.watch(postNotifierProvider(post.id).notifier).isEdited;
        return Card(
          elevation: 2,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (isNewPost)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NEWLY CREATED',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),

                  if (isEditedPost)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'EDITED',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),

                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User ID: ${post.userId}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    post.body,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection(bool isNewPost) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        // Don't fetch comments for new posts
        final AsyncValue<List<Comment>> commentsAsync = isNewPost
            ? const AsyncValue<List<Comment>>.data(<Comment>[])
            : ref.watch(commentsProvider(postId));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isNewPost)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '(Not available for new posts)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (isNewPost)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Assets.warning.image(width: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Comments are not available for newly created posts.\n'
                        'This post only exists locally.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              commentsAsync.when(
                data: (List<Comment> comments) => comments.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No comments yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : Column(
                        children: comments
                            .map(
                              (Comment comment) => CommentListItem(comment: comment),
                            )
                            .toList(),
                      ),
                loading: () => Column(
                  children: List<Widget>.generate(10, (int i) => const CommentListItemShimmer()),
                ),
                error: (Object error, _) {
                  return TryAgainWidget(
                    message:
                        'Sorry, something went wrong while loading the comments.\nPlease try again',
                    onTryAgain: () {
                      ref.invalidate(commentsProvider(postId));
                    },
                  );
                },
              ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String value,
    Post post,
  ) async {
    switch (value) {
      case 'edit':
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => PostFormDialog(
            post: post,
            onSubmit: (String title, String body) async {
              await ref
                  .read(postNotifierProvider(post.id).notifier)
                  .updatePost(
                    post.copyWith(
                      title: title,
                      body: body,
                    ),
                  );
            },
          ),
        ).then((bool? result) {
          if (context.mounted && result == true) {
            context.toast.showSuccess(
              title: 'Post Updated',
              message: 'Your post has been updated successfully.',
            );
          }
        });
      case 'delete':
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => DeletePostDialog(postId: postId),
        ).then((bool? result) {
          if (result == true && context.mounted) context.router.pop('DELETE');
        });
        break;
    }
  }
}
