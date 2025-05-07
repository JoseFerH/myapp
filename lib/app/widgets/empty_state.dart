// lib/app/widgets/empty_state.dart

import 'package:flutter/cupertino.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  
  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: CupertinoColors.systemGrey,
            ),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(buttonText!),
                onPressed: onButtonPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}