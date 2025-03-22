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
                  Align(
                    alignment: const Alignment(0, -0.3),
                    child: SizedBox(
                      width: AppDimens.d310,
                      height: AppDimens.d170,
                      child: Lottie.asset("assets/animation/well_anim.json", fit: BoxFit.cover),
                    ),
                  ),
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
