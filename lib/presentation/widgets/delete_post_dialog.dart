import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:posts_app/core/utils/toast_service.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';

class DeletePostDialog extends HookWidget {
  const DeletePostDialog({
    super.key,
    required this.postId,
  });

  final int postId;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isLoading = useState(false);
    return AlertDialog(
      title: const Text('Delete Post'),
      titlePadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width - 64,
        child: const Text('Are you sure you want to delete this post?'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: context.router.maybePop,
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            return ElevatedButton(
              onPressed: () async {
                if (isLoading.value) return; // Prevent multiple taps
                try {
                  isLoading.value = true;
                  await ref.read(postsNotifierProvider.notifier).deletePost(postId);
                  if (context.mounted) context.router.pop(true);
                } catch (e) {
                  if (context.mounted) {
                    context.toast.showError(
                      title: 'Failed to delete post',
                      message: 'Please try again.',
                    );
                  }
                } finally {
                  if (context.mounted) {
                    isLoading.value = false;
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
                overlayColor: Colors.red.shade800,
              ),
              child: isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
            );
          },
        ),
      ],
    );
  }
}
