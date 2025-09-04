import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:study_flutter/screens/onboarding_study.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('hiveBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '플러터 공부', home: OnboardingStudy());
  }
}
