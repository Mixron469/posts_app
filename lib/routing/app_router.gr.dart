// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [PostDetailPage]
class PostDetailRoute extends PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({
    Key? key,
    required int postId,
    List<PageRouteInfo>? children,
  }) : super(
         PostDetailRoute.name,
         args: PostDetailRouteArgs(key: key, postId: postId),
         rawPathParams: {'id': postId},
         initialChildren: children,
       );

  static const String name = 'PostDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PostDetailRouteArgs>(
        orElse: () => PostDetailRouteArgs(postId: pathParams.getInt('id')),
      );
      return PostDetailPage(key: args.key, postId: args.postId);
    },
  );
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({this.key, required this.postId});

  final Key? key;

  final int postId;

  @override
  String toString() {
    return 'PostDetailRouteArgs{key: $key, postId: $postId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PostDetailRouteArgs) return false;
    return key == other.key && postId == other.postId;
  }

  @override
  int get hashCode => key.hashCode ^ postId.hashCode;
}

/// generated route for
/// [PostsListPage]
class PostsListRoute extends PageRouteInfo<void> {
  const PostsListRoute({List<PageRouteInfo>? children})
    : super(PostsListRoute.name, initialChildren: children);

  static const String name = 'PostsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostsListPage();
    },
  );
}
