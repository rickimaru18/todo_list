import 'package:flutter/material.dart';

/// Show confirmation dialog with [title].
Future<bool> showConfirmationDialog(
  BuildContext context,
  String title, {
  String? description,
}) async {
  final bool? res = await showDialog<bool?>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: description != null ? Text(description) : null,
      actions: <Widget>[
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  return res ?? false;
}
