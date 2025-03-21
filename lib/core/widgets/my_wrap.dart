import 'package:flutter/material.dart';
import 'package:guess_words/core/theme/text_styles.dart';

class MyWrap extends StatelessWidget {
  const MyWrap({
    super.key,
    required this.letters,
  });

  final List<String> letters;


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: letters
          .map((letter) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Draggable(
          data: letter,
          childWhenDragging: _myContainer(""),
          feedback: Material(
            borderRadius: BorderRadius.circular(8),
              child: _myContainer(letter)),
          child: _myContainer(letter),
        ),
      ))
          .toList(),
    );
  }

  Container _myContainer(String letter) {
    return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF8296AA),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter.toUpperCase(),
              style: AppTextStyles.cube
            ),
          ),
        );
  }
}
