import 'package:flutter/material.dart';
import '/screen/home_screen.dart';

sealed class AppRoutes{
  static const home = '/';

  static Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    home: (context) => Home()
  };
}