import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:posts_app/core/gen/assets.gen.dart';
import 'package:posts_app/core/utils/toast_service.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/presentation/providers/post_provider.dart';
import 'package:posts_app/presentation/providers/posts_provider.dart';
import 'package:posts_app/presentation/widgets/post_form_dialog.dart';
import 'package:posts_app/presentation/widgets/post_list_item.dart';
import 'package:posts_app/presentation/widgets/post_list_item_shimmer.dart';

@RoutePage()
class PostsListPage extends HookConsumerWidget {
  /// Main page showing list of posts
  /// Using HookConsumerWidget for hooks and Riverpod
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Post>> postsAsync = ref.watch(postsNotifierProvider);

    // Using hooks for local state management
    final ValueNotifier<bool> isSearching = useState(false);
    final TextEditingController searchController = useTextEditingController();
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      appBar: AppBar(
        title: isSearching.value
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search posts...',
                  border: InputBorder.none,
                ),
              )
            : const Text('Posts'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          if (!postsAsync.hasError)
            IconButton(
              icon: Icon(isSearching.value ? Icons.close : Icons.search),
              onPressed: () {
                isSearching.value = !isSearching.value;
                if (!isSearching.value) {
                  searchController.clear();
                }
              },
            ),
        ],
      ),
      body: postsAsync.when(
        skipLoadingOnRefresh: false,
        data: (List<Post> posts) {
          useListenable(searchController);

          // Filter posts based on search query
          final List<Post> filteredPosts = searchController.text.isEmpty
              ? posts
              : posts
                    .where(
                      (Post post) =>
                          post.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
                          post.body.toLowerCase().contains(searchController.text.toLowerCase()),
                    )
                    .toList();

          Future<void> createPost() async {
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => PostFormDialog(
                onSubmit: (String title, String body) async {
                  await ref
                      .read(postsNotifierProvider.notifier)
                      .createPost(
                        title: title,
                        body: body,
                      );
                },
              ),
            ).then((bool? result) {
              if (context.mounted && result == true) {
                context.toast.showSuccess(
                  title: 'Post Created',
                  message: 'Your post has been created successfully.',
                );
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          }

          final bool onSearchEmpty = useListenableSelector(
            searchController,
            () => filteredPosts.isEmpty && searchController.text.isNotEmpty,
          );

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(postsNotifierProvider);
              ref.invalidate(postNotifierProvider);
            },
            child: Scrollbar(
              controller: scrollController,
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    flexibleSpace: InkWell(onTap: createPost),
                    floating: true,
                    scrolledUnderElevation: 2,
                    pinned: onSearchEmpty,
                    title: const IgnorePointer(
                      child: Text('Create Post'),
                    ),
                    centerTitle: false,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    actions: <Widget>[
                      IgnorePointer(
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  if (onSearchEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Assets.notFound.image(width: 100),
                            const SizedBox(height: 16),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'No posts found for "${searchController.text}"',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 8,
                          ).add(
                            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 56),
                          ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Post post = filteredPosts[index];
                            return PostListItem(
                              post: post,
                              onTap: () async {
                                await context.router.pushPath<String>('/post/${post.id}').then((
                                  String? result,
                                ) {
                                  if (result == 'DELETE' && context.mounted) {
                                    context.toast.showSuccess(
                                      title: 'Post Deleted',
                                      message: 'The post has been deleted successfully.',
                                    );
                                  }
                                });
                              },
                            );
                          },
                          childCount: filteredPosts.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                title: const IgnorePointer(
                  child: Text('Create Post'),
                ),
                centerTitle: false,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                actions: <Widget>[
                  IgnorePointer(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                    ).add(
                      EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 56),
                    ),
                sliver: SliverList.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) => const PostListItemShimmer(),
                ),
              ),
            ],
          );
        },
        error: (Object error, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Assets.error.image(width: 100),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Sorry, something went wrong while loading posts. Please try again',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(postsNotifierProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size.fromWidth(120),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
