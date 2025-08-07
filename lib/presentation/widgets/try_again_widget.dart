import 'package:flutter/material.dart';
import 'package:posts_app/core/gen/assets.gen.dart';

class TryAgainWidget extends StatelessWidget {
  const TryAgainWidget({
    super.key,
    required this.message,
    this.onTryAgain,
  });

  final String message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Assets.error.image(width: 100),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTryAgain,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(120),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
