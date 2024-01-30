import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Utils {
  const Utils();

  Utils.logError(String title, [Object? error, StackTrace? stackTrace]) {
    logger.e(
      'Error $title',
      time: DateTime.timestamp(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  Utils.logInfo(String title) {
    logger.i(
      title,
      time: DateTime.timestamp(),
    );
  }

  Utils.logWarning(String title) {
    logger.w(
      title,
      time: DateTime.timestamp(),
    );
  }

  Utils.snackbarNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
