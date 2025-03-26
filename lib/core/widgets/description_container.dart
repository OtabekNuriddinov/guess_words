import 'package:flutter/material.dart';
import '/models/charade.dart';

import '../theme/dimens.dart';
import '../theme/text_styles.dart';

class DescriptionContainer extends StatelessWidget {

  final GameData? currentQuestion;
  const DescriptionContainer({required this.currentQuestion, super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: AppDimens.d40,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(10, 8),
          ),
        ],
        border: Border(bottom: BorderSide(color: Color(0xFF5A6E82), width: 3)),
        borderRadius: AppDimens.v105,
        color: Color(0xFF8296AA),
      ),
      child: Center(
        child: Text(currentQuestion!.description, style: AppTextStyles.clue),
      ),
    );;
  }
}
