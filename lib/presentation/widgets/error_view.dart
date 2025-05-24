import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isNoInternet;
  final bool isNotFound;
  final bool isServerError;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.isNoInternet = false,
    this.isNotFound = false,
    this.isServerError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorTitle(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (isNoInternet) {
      return Icons.wifi_off_rounded;
    } else if (isNotFound) {
      return Icons.search_off_rounded;
    } else if (isServerError) {
      return Icons.error_outline_rounded;
    }
    return Icons.error_outline_rounded;
  }

  String _getErrorTitle() {
    if (isNoInternet) {
      return 'No Internet Connection';
    } else if (isNotFound) {
      return 'Not Found';
    } else if (isServerError) {
      return 'Server Error';
    }
    return 'Error';
  }
}