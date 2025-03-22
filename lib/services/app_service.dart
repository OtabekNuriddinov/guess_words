import 'dart:ui';

import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/data_source.dart';

import '../core/theme/colors.dart';


class AppService{
  // GameData? currentQuestion;
  // int level = 1;
  // int sanoq = 0;
  // bool isChecked = false;
  //
  // /// kerak bo'ladigan listlar
  // List<String?> placedLetters = [];
  // List<String> leftLetters = [];
  // List<String> rightLetters = [];
  // List<Color> leftSpaceColors = [];
  // List<Color> rightSpaceColors = [];
  // List<Color> middleSpaceColors = [];
  // List originalList = [];

  AppService._();
  static final AppService _singleton = AppService._();
  factory AppService()=>_singleton;

  List<GameData> _list = [];
  List<GameData> get items => _list;

  Future<void>initialize()async{
    final json = await DataSource.convertor();
    _list = json.map((item)=> GameData.fromJson(item)).toList();
  }

  // void initializeLetters() {
  //   if (currentQuestion == null) return;
  //   leftLetters = currentQuestion!.left.name.split("");
  //   rightLetters = currentQuestion!.right.name.split("");
  //
  //   leftSpaceColors = List.generate(currentQuestion!.leftLetter,
  //           (index) => AppService.getColorFromInt(currentQuestion!.left.color));
  //   rightSpaceColors = List.generate(currentQuestion!.rightLetter,
  //           (index) => AppService.getColorFromInt(currentQuestion!.right.color));
  //
  //   middleSpaceColors = List.generate(
  //       currentQuestion!.middleLetter, (index) => AppColors.white);
  //
  //   originalList = [
  //     ...leftSpaceColors,
  //     ...middleSpaceColors,
  //     ...rightSpaceColors
  //   ];
  //   placedLetters = List.filled(originalList.length, null);
  // }
  //
  // void nextQuestion() {
  //   if (sanoq < items.length - 1) {
  //     sanoq++;
  //     level++;
  //     currentQuestion = items[sanoq];
  //     initializeLetters();
  //     isChecked = false;
  //   }
  // }





  static Color getColorFromInt(int colorValue) {
    return Color(0xFF000000 | colorValue);
  }

}

