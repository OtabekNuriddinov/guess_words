import 'package:flutter/material.dart';

import '/models/charade.dart';
import '/services/data_source.dart';
import 'package:just_audio/just_audio.dart';

import '../core/theme/colors.dart';

class AppService {
  AppService._();
  static final AppService _singleton = AppService._();
  factory AppService() => _singleton;

  List<GameData> _list = [];
  List<GameData> get items => _list;

  Future<void> initialize() async {
    final json = await DataSource.convertor();
    _list = json.map((item) => GameData.fromJson(item)).toList();
  }


  static void initializeLetters(
    GameData? currentQuestion,
    List<String> leftLetters,
    List<String> rightLetters,
    List<Color> leftSpaceColors,
    List<Color> rightSpaceColors,
    List<Color> middleSpaceColors,
    List<Color> originalList,
    List<String?>placedLetters
  ) {
    if (currentQuestion == null) return;

    leftLetters.clear();
    rightLetters.clear();
    leftSpaceColors.clear();
    rightSpaceColors.clear();
    middleSpaceColors.clear();
    originalList.clear();
    placedLetters.clear();
    
    leftLetters.addAll(currentQuestion.left.name.split(""));
    rightLetters.addAll(currentQuestion.right.name.split(""));

    leftSpaceColors.addAll(List.generate(currentQuestion.leftLetter,
            (index) => AppService.getColorFromInt(currentQuestion.left.color)));
    
    rightSpaceColors.addAll(List.generate(currentQuestion.rightLetter,
            (index) => AppService.getColorFromInt(currentQuestion.right.color)));

    middleSpaceColors.addAll(List.generate(
        currentQuestion.middleLetter, (index) => AppColors.white));

    originalList.addAll([
    ...leftSpaceColors,
    ...middleSpaceColors,
    ...rightSpaceColors
    ]);
    placedLetters.addAll(List.filled(originalList.length, null));
  }

  static void playWin() async {
    AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer
          .setAsset("assets/sounds/you-win-sequence-2-183949.mp3");
      audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  static void playWrong() async {
    AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setAsset("assets/sounds/wrong-47985.mp3");
      audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  static Color getColorFromInt(int colorValue) {
    return Color(0xFF000000 | colorValue);
  }
}
