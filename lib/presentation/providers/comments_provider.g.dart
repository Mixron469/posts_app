// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentsHash() => r'2e225bf6d3b67e386384c8cbad36d0ffae6a9da9';

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

/// Provider for fetching comments by post ID
///
/// Copied from [comments].
@ProviderFor(comments)
const commentsProvider = CommentsFamily();

/// Provider for fetching comments by post ID
///
/// Copied from [comments].
class CommentsFamily extends Family<AsyncValue<List<Comment>>> {
  /// Provider for fetching comments by post ID
  ///
  /// Copied from [comments].
  const CommentsFamily();

  /// Provider for fetching comments by post ID
  ///
  /// Copied from [comments].
  CommentsProvider call(int postId) {
    return CommentsProvider(postId);
  }

  @override
  CommentsProvider getProviderOverride(covariant CommentsProvider provider) {
    return call(provider.postId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commentsProvider';
}

/// Provider for fetching comments by post ID
///
/// Copied from [comments].
class CommentsProvider extends AutoDisposeFutureProvider<List<Comment>> {
  /// Provider for fetching comments by post ID
  ///
  /// Copied from [comments].
  CommentsProvider(int postId)
    : this._internal(
        (ref) => comments(ref as CommentsRef, postId),
        from: commentsProvider,
        name: r'commentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$commentsHash,
        dependencies: CommentsFamily._dependencies,
        allTransitiveDependencies: CommentsFamily._allTransitiveDependencies,
        postId: postId,
      );

  CommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final int postId;

  @override
  Override overrideWith(
    FutureOr<List<Comment>> Function(CommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommentsProvider._internal(
        (ref) => create(ref as CommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Comment>> createElement() {
    return _CommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentsRef on AutoDisposeFutureProviderRef<List<Comment>> {
  /// The parameter `postId` of this provider.
  int get postId;
}

class _CommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Comment>>
    with CommentsRef {
  _CommentsProviderElement(super.provider);

  @override
  int get postId => (origin as CommentsProvider).postId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
