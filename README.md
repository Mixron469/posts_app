# Posts App - Clean Architecture with Flutter

A modern Flutter application demonstrating clean architecture, reactive forms, Riverpod state management, and hooks.

---

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles, ensuring separation of concerns and scalability. It uses the **Service Layer Pattern** for simplicity and maintainability.

### Key Features:
- **Riverpod** for state management
- **Reactive Forms** for form handling
- **Auto Route** for navigation
- **Dio** for API calls
- **Flutter Hooks** for reducing boilerplate
- **Code Generation** with `build_runner`

---

## 🚀 Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/posts_app.git
   cd posts_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```
lib/
├── core/               # Core utilities and configurations
│   ├── constants/      # Application constants (e.g., API endpoints)
│   ├── errors/         # Error handling classes (e.g., Failure classes)
│   ├── gen/            # Generated assets (e.g., images, fonts)
│   ├── network/        # Network configuration (e.g., Dio client)
│   ├── theme/          # Theme data for consistent styling
│   ├── utils/          # Utility classes (e.g., ToastService)
├── data/               # Data layer (API, models, repositories)
│   ├── models/         # Data models (e.g., Post, Comment)
│   ├── repositories/   # Repository interfaces and implementations
│   ├── services/       # API service classes for network calls
├── presentation/       # UI layer (pages, widgets, providers)
│   ├── pages/          # Screens (e.g., PostListPage, PostDetailPage)
│   ├── providers/      # Riverpod providers for state management
│   ├── widgets/        # Reusable UI components (e.g., PostListItem, CommentListItem)
├── routing/            # Navigation setup using Auto Route
└── main.dart           # App entry point
```

### Key Highlights:
- **Core**: Contains constants, error handling, network configuration, theme data, and utility classes.
- **Data**: Manages API calls, data models, and repository implementations.
- **Presentation**: Handles UI components, pages, and state management using Riverpod.
- **Routing**: Defines and manages app navigation using Auto Route.
- **Generated Assets**: Managed by `flutter_gen` for easy access to assets like images and fonts.

This structure ensures a clean separation of concerns and scalability for medium to large applications.

---

## 🚦 Routing

This app uses **Auto Route** for declarative navigation. Routes are defined in `lib/routing/app_router.dart` and generated using `build_runner`.

### Example Route Definition:
```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: PostsListRoute.page, initial: true),
    AutoRoute(page: PostDetailRoute.page),
  ];
}
```

### Generating Routes:
Run the following command to generate route code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🌟 State Management with Riverpod

This app uses **Riverpod** for reactive state management. Providers are defined in `lib/presentation/providers/`.

### Example Provider:
```dart
import 'package:posts_app/data/models/post_model.dart';
import 'package:posts_app/data/repositories/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_provider.g.dart';

@Riverpod(keepAlive: true)
/// State notifier for managing posts list with CRUD operations
class PostsNotifier extends _$PostsNotifier {
  @override
  FutureOr<List<Post>> build() {
    return ref.read(postRepositoryProvider).getPosts();
  }

  /// Create a new post
  Future<void> createPost({required String title, required String body}) async {
    try {
      final Post newPost = await ref
          .read(postRepositoryProvider)
          .createPost(title: title, body: body);

      state.whenData((List<Post> posts) {
        state = AsyncValue<List<Post>>.data(<Post>[newPost, ...posts]);
      });
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<List<Post>>.error(e, st));
      rethrow;
    }
  }

  /// Update an existing post
  Future<void> updatePost(Post post) async {
    try {
      state.whenData((List<Post> posts) {
        final int index = posts.indexWhere((Post p) => p.id == post.id);
        if (index != -1) {
          final List<Post> newPosts = <Post>[...posts];
          newPosts[index] = post;
          state = AsyncValue<List<Post>>.data(newPosts);
        }
      });
    } catch (e, st) {
      state = state.copyWithPrevious(AsyncValue<List<Post>>.error(e, st));
      rethrow;
    }
  }

  /// Delete a post
  Future<void> deletePost(int id) async {
    try {
      await ref.read(postRepositoryProvider).deletePost(id);

      state.whenData((List<Post> posts) {
        state = AsyncValue<List<Post>>.data(posts.where((Post p) => p.id != id).toList());
      });
    } catch (e, st) {
      state = AsyncValue<List<Post>>.error(e, st);
      rethrow;
    }
  }
}
```

### Key Benefits:
- **Scoped State**: Providers are scoped to widgets, ensuring efficient state management.
- **Auto Dispose**: Providers automatically clean up resources when no longer needed.
- **Testable**: Providers can be mocked easily for unit and widget testing.
- **Async Support**: Handles asynchronous operations like fetching, creating, updating, and deleting posts seamlessly.

### How to Use:
- **Access the Provider**:
  ```dart
  final posts = ref.watch(postsNotifierProvider);
  ```
- **Perform Actions**:
  ```dart
  final postsNotifier = ref.read(postsNotifierProvider.notifier);
  await postsNotifier.createPost(title: 'New Post', body: 'This is a new post.');
  ```

This updated section reflects your current `PostsNotifier` implementation and provides clear examples for usage.

---

## 🔧 Code Generation with `build_runner`

This project uses `build_runner` for generating code, such as:
- **Auto Route**: Navigation code
- **Riverpod Annotations**: Provider boilerplate
- **Assets**: Generated asset references

### Commands:
- Generate code:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Watch for changes:
  ```bash
  dart run build_runner watch
  ```

---

## 🎯 Design Decisions

### Why Service Pattern?
- Simpler for API-only apps
- Reduces abstraction layers
- Easier to understand and maintain

### Why Riverpod?
- **Scoped State**: Providers are tied to widget lifecycles.
- **Performance**: Only rebuilds widgets that depend on updated state.
- **Testability**: Providers can be mocked easily.

### Why Reactive Forms?
- **Type-safe** form handling
- **Real-time** validation
- **Less boilerplate** than `FormKey`
- **Better testing** support

### Why Flutter Hooks?
- **Less code**: No StatefulWidget boilerplate
- **Composable**: Custom hooks can be shared
- **Auto-dispose**: No manual cleanup needed

---

## 🛠️ Development Tools

### `.vscode/settings.json`
This file customizes the VS Code settings for the project to improve productivity and enforce consistent coding practices.

#### Key Configurations:
- **File Nesting**: Groups related files (e.g., `.g.dart`, `.freezed.dart`) under their parent files for better organization.
  ```jsonc
  "explorer.fileNesting.patterns": {
      "*.dart": "${capture}.g.dart, ${capture}.freezed.dart, ${capture}.gr.dart, ${capture}_shimmer.dart",
      "main.dart": "main_*.dart",
      "*_test.dart": "${capture}_test.mocks.dart"
  }
  ```
- **Formatting**: Automatically formats code on save and organizes imports.
  ```jsonc
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
  }
  ```
- **Line Length**: Sets the maximum line length to 100 characters for better readability.
  ```jsonc
  "dart.lineLength": 100
  ```
- **Editor Enhancements**:
  - Enables rulers at 100 characters.
  - Disables unnecessary suggestions (e.g., word-based suggestions).
  - Sets a smaller font size for better code visibility.
  ```jsonc
  "editor.rulers": [100],
  "editor.fontSize": 11
  ```

---

### `analysis_options.yaml`
This file configures the Dart analyzer to enforce coding standards and best practices.

#### Key Configurations:
- **Lint Rules**: Includes Flutter's recommended lints and adds custom rules for stricter code quality.
  ```yaml
  include: package:flutter_lints/flutter.yaml
  linter:
    rules:
      require_trailing_commas: true
      prefer_const_constructors: true
      avoid_unnecessary_containers: true
      always_specify_types: true
      always_declare_return_types: true
  ```
- **Formatter Settings**:
  - Preserves trailing commas for better diffs.
  - Sets a page width of 100 characters for consistent formatting.
  ```yaml
  formatter:
    trailing_commas: preserve
    page_width: 100
  ```

#### Benefits:
- **Consistency**: Ensures all developers follow the same coding style.
- **Readability**: Improves code readability and maintainability.
- **Error Prevention**: Catches potential issues early during development.

---

### `build.yaml`
This file configures the `build_runner` tool for code generation.

#### Key Configurations:
- **Generated Code Output**: Specifies the output directory for generated files.
  ```yaml
  targets:
    $default:
      builders:
        flutter_gen_runner:
          options:
            output: lib/core/gen/
  ```
- **Purpose**:
  - Ensures all generated files (e.g., assets, routes, providers) are stored in a consistent location.
  - Keeps the project structure clean by separating generated code from manually written code.

#### Usage:
- Run the following command to generate code:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Use the `watch` command during development for automatic code generation:
  ```bash
  dart run build_runner watch
  ```

---

These configurations ensure a streamlined development experience, enforce consistent coding practices, and simplify code generation.

---

## 🧪 Testing

This app includes unit and widget tests for providers, widgets, and pages.

### Running Tests:
```bash
flutter test
```

### Running Tests with Coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🎨 UI/UX Features

- Material 3 design
- Search functionality
- Pull-to-refresh
- Real-time form validation
- Character counters
- Unsaved changes warning
- Loading and error states

---

## 📈 Performance Tips

1. Use `const` constructors wherever possible.
2. Implement pagination for large lists.
3. Add image caching if posts have images.
4. Use `AutomaticKeepAliveClientMixin` for tab persistence.

---

## 🏆 Best Practices Implemented

1. **SOLID Principles**: Single responsibility everywhere.
2. **DRY**: No code duplication.
3. **KISS**: Simple solutions preferred.
4. **Type Safety**: No dynamic types.
5. **Error Handling**: Consistent error management.

---

## 📚 Learning Curve

### Easy to Learn 🟢
- Basic Flutter knowledge transfers directly.
- Riverpod is easy if you know Provider.
- Service pattern is straightforward.

### Medium Learning 🟡
- Reactive Forms syntax (but worth it!).
- Flutter Hooks concepts.
- Auto Route setup.

### Advanced 🔴
- Custom validators in Reactive Forms.
- Complex state management scenarios.
- Custom hooks creation.

---

This architecture is **production-ready** and scales well for medium to large applications!