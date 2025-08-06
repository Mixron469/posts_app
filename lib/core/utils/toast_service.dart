import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Toast service for showing success/error notifications
class ToastService {
  final BuildContext context;

  ToastService._(this.context);

  static ToastService of(BuildContext context) {
    return ToastService._(context);
  }

  /// Show success toast
  void _show({
    required String title,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 3),
    required ToastificationType type,
    ToastificationStyle style = ToastificationStyle.flat,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: style,
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: autoCloseDuration,
      dismissDirection: DismissDirection.up,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),

      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  /// Show success toast
  void showSuccess({
    required String title,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    _show(
      type: ToastificationType.success,
      title: title,
      message: message,
      autoCloseDuration: autoCloseDuration,
    );
  }

  /// Show error toast
  void showError({
    required String title,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    _show(
      type: ToastificationType.error,
      title: title,
      message: message,
      autoCloseDuration: autoCloseDuration,
    );
  }

  /// Show info toast
  void showInfo({
    required String message,
    required String title,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    _show(
      type: ToastificationType.info,
      title: title,
      message: message,
      autoCloseDuration: autoCloseDuration,
    );
  }

  /// Show warning toast
  void showWarning({
    required String message,
    required String title,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    _show(
      type: ToastificationType.warning,
      title: title,
      message: message,
      autoCloseDuration: autoCloseDuration,
    );
  }

  /// Show loading toast (doesn't auto-hide)
  ToastificationItem showLoading({
    required String message,
    String? title,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title ?? 'Loading'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: null, // Don't auto close
      icon: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      foregroundColor: Colors.grey.shade800,
      primaryColor: Colors.grey,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),

      closeOnClick: false,
      pauseOnHover: false,
      dragToClose: false,
    );
  }

  /// Dismiss a specific toast
  void dismiss(ToastificationItem toast) {
    toastification.dismiss(toast);
  }

  /// Dismiss all toasts
  void dismissAll() {
    toastification.dismissAll();
  }
}

// Alternative: Simple extension method for quick access
extension ToastExtension on BuildContext {
  ToastService get toast => ToastService.of(this);
}
