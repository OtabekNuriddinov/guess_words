import 'package:flutter/material.dart';
import 'package:guess_words/core/config/routes.dart';

class GuessWords extends StatelessWidget {
  const GuessWords({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
