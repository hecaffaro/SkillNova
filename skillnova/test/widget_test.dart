import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillnova/main.dart';
import 'package:skillnova/providers/user_provider.dart';
import 'package:skillnova/providers/learning_provider.dart';

void main() {
  testWidgets('SkillNova app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => LearningProvider()),
        ],
        child: const SkillNovaApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
