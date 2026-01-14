import 'package:flutter/material.dart';
import 'screens/article_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosimetry Frontend',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ArticleScreen(),
    );
  }
}
