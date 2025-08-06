// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsNotifierHash() => r'454be3f3ac6e9b1ffc0df8e14a2850ad2663d31c';

/// State notifier for managing posts list with CRUD operations
///
/// Copied from [PostsNotifier].
@ProviderFor(PostsNotifier)
final postsNotifierProvider =
    AsyncNotifierProvider<PostsNotifier, List<Post>>.internal(
      PostsNotifier.new,
      name: r'postsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PostsNotifier = AsyncNotifier<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
