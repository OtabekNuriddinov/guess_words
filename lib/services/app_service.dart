import 'dart:ui';

import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/data_source.dart';


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



  static Color getColorFromInt(int colorValue) {
    return Color(0xFF000000 | colorValue);
  }

}

