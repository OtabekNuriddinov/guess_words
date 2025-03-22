import 'dart:ui';

import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/data_source.dart';
import 'package:just_audio/just_audio.dart';



class AppService{

  AppService._();
  static final AppService _singleton = AppService._();
  factory AppService()=>_singleton;

  List<GameData> _list = [];
  List<GameData> get items => _list;

  Future<void>initialize()async{
    final json = await DataSource.convertor();
    _list = json.map((item)=> GameData.fromJson(item)).toList();
  }


  static void playWin()async{
    AudioPlayer _audioPlayer = AudioPlayer();
    try{
      await _audioPlayer.setAsset("assets/sounds/you-win-sequence-2-183949.mp3");
      _audioPlayer.play();
    }
    catch(e){
      print("Error: $e");
    }
  }

  static void playWrong()async{
    AudioPlayer _audioPlayer = AudioPlayer();
    try{
      await _audioPlayer.setAsset("assets/sounds/wrong-47985.mp3");
      _audioPlayer.play();
    }
    catch(e){
      print("Error: $e");
    }
  }


  static Color getColorFromInt(int colorValue) {
    return Color(0xFF000000 | colorValue);
  }

}

