import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:posts_app/core/utils/toast_service.dart';
import 'package:posts_app/data/models/post_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PostFormDialog extends HookWidget {
  /// Reusable dialog for creating or editing posts
  const PostFormDialog({
    super.key,
    this.post,
    required this.onSubmit,
  });

  final Post? post; // null for create, non-null for edit
  final FutureOr<dynamic> Function(String title, String body) onSubmit;

  bool get isEditMode => post != null;

  @override
  Widget build(BuildContext context) {
    // Loading state
    final ValueNotifier<bool> isLoading = useState(false);

    // Create form group with validators
    final FormGroup form = useMemoized(
      () => FormGroup(<String, AbstractControl<dynamic>>{
        'title': FormControl<String>(
          value: post?.title, // Use existing value or null
          validators: <Validator<dynamic>>[
            Validators.required,
            Validators.maxLength(100),
          ],
        ),
        'body': FormControl<String>(
          value: post?.body, // Use existing value or null
          validators: <Validator<dynamic>>[
            Validators.required,
            Validators.maxLength(500),
          ],
        ),
      }),
    );

    // Track if form has been modified (only for edit mode)
    final ValueNotifier<bool> hasChanges = useState(!isEditMode); // Always true for create mode

    useEffect(() {
      if (isEditMode) {
        final StreamSubscription<Map<String, Object?>?> subscription = form.valueChanges.listen((
          _,
        ) {
          final Map<String, Object?> values = form.value;
          hasChanges.value = values['title'] != post!.title || values['body'] != post!.body;
        });

        return () {
          subscription.cancel();
          form.dispose();
        };
      } else {
        return () => form.dispose();
      }
    }, <Object?>[]);

    return ReactiveForm(
      formGroup: form,
      canPop: (FormGroup formGroup) => !(isLoading.value || (isEditMode && formGroup.dirty)),
      child: AlertDialog(
        title: Text(isEditMode ? 'Edit Post' : 'Create New Post'),
        titlePadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width - 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ReactiveTextField<String>(
                canRequestFocus: !isLoading.value,
                formControlName: 'title',
                decoration: InputDecoration(
                  labelText: 'Title',
                  helperText: 'Max 100 characters',
                  enabled: !isLoading.value,
                ),
                showErrors: (FormControl<String> control) => control.dirty,
                validationMessages: <String, ValidationMessageFunction>{
                  ValidationMessage.required: (_) => 'Title is required',
                  ValidationMessage.maxLength: (_) => 'Title must not exceed 100 characters',
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                canRequestFocus: !isLoading.value,
                formControlName: 'body',
                showErrors: (FormControl<String> control) => control.dirty,
                decoration: InputDecoration(
                  labelText: 'Body',
                  helperText: 'Max 500 characters',
                  enabled: !isLoading.value,
                ),
                maxLines: 4,
                validationMessages: <String, ValidationMessageFunction>{
                  ValidationMessage.required: (_) => 'Body is required',
                  ValidationMessage.maxLength: (_) => 'Body must not exceed 500 characters',
                },
              ),
              const SizedBox(height: 8),
              // Real-time character count
              ReactiveFormConsumer(
                builder: (BuildContext context, FormGroup form, Widget? child) {
                  final AbstractControl<dynamic> titleControl = form.control('title');
                  final AbstractControl<dynamic> bodyControl = form.control('body');
                  final int titleLength = (titleControl.value as String?)?.length ?? 0;
                  final int bodyLength = (bodyControl.value as String?)?.length ?? 0;

                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Title: $titleLength/100',
                            style: TextStyle(
                              fontSize: 12,
                              color: titleLength > 100 ? Colors.red : Colors.grey,
                            ),
                          ),
                          Text(
                            'Body: $bodyLength/500',
                            style: TextStyle(
                              fontSize: 12,
                              color: bodyLength > 500 ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (isEditMode && hasChanges.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'You have unsaved changes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading.value
                ? null
                : () async {
                    if (isEditMode && hasChanges.value) {
                      // Show confirmation dialog if there are unsaved changes
                      await _showConfirmationDialog(context).then((bool? result) {
                        if (result == true && context.mounted) context.router.pop();
                      });
                    } else {
                      context.router.maybePop();
                    }
                  },
            child: const Text('Cancel'),
          ),

          ReactiveFormConsumer(
            builder: (BuildContext context, FormGroup form, Widget? child) {
              final bool canSubmit = form.valid && hasChanges.value && !isLoading.value;

              return ElevatedButton(
                onPressed: canSubmit
                    ? () async {
                        isLoading.value = true;
                        final Map<String, Object?> values = form.value;
                        try {
                          await onSubmit(
                            values['title'] as String,
                            values['body'] as String,
                          );

                          if (context.mounted) context.router.pop(true);
                        } catch (e) {
                          if (context.mounted) {
                            context.toast.showError(
                              title: 'Error',
                              message:
                                  'An error occurred while ${isEditMode ? 'updating' : 'creating'} the post.',
                            );
                          }
                        } finally {
                          if (context.mounted) {
                            isLoading.value = false;
                          }
                        }
                      }
                    : null,
                child: isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditMode ? 'Update' : 'Create'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Discard Changes?'),
        titlePadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width - 64,
          child: const Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: dialogContext.router.maybePop,
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              dialogContext.router.maybePop(true); // Close confirmation
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(150),
            ),
            child: const Text('Yes, Discard'),
          ),
        ],
      ),
    );
  }
}
