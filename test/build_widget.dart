import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> buildWidget(
  WidgetTester tester,
  Widget widget,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    ),
  );
}
