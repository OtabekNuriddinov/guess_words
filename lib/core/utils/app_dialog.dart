import 'package:flutter/material.dart';

sealed class AppDialog {
  static Future<dynamic> showMyDialog(String image, void Function()nextLevel, BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Do you want to go next level?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    nextLevel();
                  },
                  child: Text("Next"))
            ],
          );
        });
  }
}
