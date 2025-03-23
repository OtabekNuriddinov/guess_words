import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/dimens.dart';

sealed class AppDialog {
  static Future<void> alertDlg(BuildContext context, String title) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Stack(
                children: [

                ],
              )
            ),
            actions: <Widget>[
              TextButton(onPressed: () {}, child: Text("Next"))
            ],
          );
        });
  }
}
