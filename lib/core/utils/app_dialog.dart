import 'package:flutter/material.dart';

sealed class AppDialog {
  static Future<dynamic> showMyDialog(String image, void Function()nextLevel, String word, void Function()initialize, BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: AssetImage(image)
                    )
                  ),
                ),
                SizedBox(height: 10),
                Text(word, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),),
                Text("Do you want to go next level?", style: TextStyle(fontSize: 16, letterSpacing: 1),)
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  initialize();
                },
                child: Text("No"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    nextLevel();
                  },
                  child: Text("Yes"),
              ),

            ],
          );
        });
  }
}
