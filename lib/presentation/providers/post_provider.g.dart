// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postNotifierHash() => r'c007f0051af00a31f9da9270bc11d4bac5bb1be6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PostNotifier extends BuildlessAsyncNotifier<Post> {
  late final int id;

  FutureOr<Post> build(int id);
}

/// Provider for fetching a single post by ID
///
/// Copied from [PostNotifier].
@ProviderFor(PostNotifier)
const postNotifierProvider = PostNotifierFamily();

/// Provider for fetching a single post by ID
///
/// Copied from [PostNotifier].
class PostNotifierFamily extends Family<AsyncValue<Post>> {
  /// Provider for fetching a single post by ID
  ///
  /// Copied from [PostNotifier].
  const PostNotifierFamily();

  /// Provider for fetching a single post by ID
  ///
  /// Copied from [PostNotifier].
  PostNotifierProvider call(int id) {
    return PostNotifierProvider(id);
  }

  @override
  PostNotifierProvider getProviderOverride(
    covariant PostNotifierProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postNotifierProvider';
}

/// Provider for fetching a single post by ID
///
/// Copied from [PostNotifier].
class PostNotifierProvider
    extends AsyncNotifierProviderImpl<PostNotifier, Post> {
  /// Provider for fetching a single post by ID
  ///
  /// Copied from [PostNotifier].
  PostNotifierProvider(int id)
    : this._internal(
        () => PostNotifier()..id = id,
        from: postNotifierProvider,
        name: r'postNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postNotifierHash,
        dependencies: PostNotifierFamily._dependencies,
        allTransitiveDependencies:
            PostNotifierFamily._allTransitiveDependencies,
        id: id,
      );

  PostNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<Post> runNotifierBuild(covariant PostNotifier notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(PostNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<PostNotifier, Post> createElement() {
    return _PostNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostNotifierRef on AsyncNotifierProviderRef<Post> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PostNotifierProviderElement
    extends AsyncNotifierProviderElement<PostNotifier, Post>
    with PostNotifierRef {
  _PostNotifierProviderElement(super.provider);

  @override
  int get id => (origin as PostNotifierProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
