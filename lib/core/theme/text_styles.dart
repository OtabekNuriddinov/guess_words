import 'package:flutter/material.dart';

import 'colors.dart';

sealed class AppTextStyles{

  static TextStyle levelCount = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  static TextStyle level = TextStyle(fontSize: 12);
  static TextStyle clue = TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic);
  static TextStyle cube = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white);

}
