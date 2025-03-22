import 'package:flutter/material.dart';

import '../../models/charade.dart';
import 'my_container.dart';

class MyImageContainer extends StatelessWidget {
  const MyImageContainer({
    super.key,
    required this.currentQuestion,
    required this.leftLetters,
    required this.rightLetters,
  });

  final GameData? currentQuestion;
  final List<String> leftLetters;
  final List<String> rightLetters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MyContainer(
              image: currentQuestion!.left.imageUrl,
              color: currentQuestion!.left.color,
              letters: leftLetters,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: MyContainer(
              image: currentQuestion!.right.imageUrl,
              color: currentQuestion!.right.color,
              letters: rightLetters,
            ),
          )
        ],
      ),
    );
  }
}