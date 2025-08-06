import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/presentation/pages/post_detail_page.dart';
import 'package:posts_app/presentation/pages/posts_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(
      path: '/',
      page: PostsListRoute.page,
      initial: true,
    ),
    AutoRoute(
      path: '/post/:id',
      page: PostDetailRoute.page,
    ),
  ];
}
