import 'package:flutter/material.dart';

import '../theme/dimens.dart';
import '../theme/text_styles.dart';

class OptionsContainer extends StatelessWidget {
  final List<String>dragLetters;
  final String word;
  final Color currentLeft;
  final Color currentRight;
  final List<String?>placedLetters;
  final List<Color> originalList;
  final List<Color> leftSpaceColors;
  final List<Color> rightSpaceColors;
  final List<Color> middleSpaceColors;
  final Function(String data, int index) onAccept;

  const OptionsContainer({required this.dragLetters, required this.word, required this.currentLeft,
      required this.currentRight, required this.placedLetters, required this.originalList, required this.leftSpaceColors,required this.rightSpaceColors, required this.middleSpaceColors, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppDimens.d90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(10, 8),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: Color(0xFF5A6E82), width: 3),
        ),
        color: Color(0xFF8296AA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dragLetters.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  onAccept(details.data, index);
                },
                builder: (context, candidateData, rejectedData) {
              return Container(
                width: AppDimens.d40,
                height: AppDimens.d40,
                decoration: BoxDecoration(
                  gradient: (index >= leftSpaceColors.length &&
                      index <
                          leftSpaceColors.length + middleSpaceColors.length)
                      ? LinearGradient(
                      colors: [currentLeft, currentRight],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)
                      : null,
                  color: originalList[index],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    placedLetters[index] ?? "",
                    style: AppTextStyles.cube,
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
