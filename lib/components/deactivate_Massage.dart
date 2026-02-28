import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';

class DeactivatedAccountMessage extends StatelessWidget {
  final String? message;

  const DeactivatedAccountMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
          ),
          boxShadow: [
            BoxShadow(
              color: MyTheme.storm_grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message ??
              "Your account is deactivated. Please go to the Account screen to reactivate it.",
          textAlign: TextAlign.center,
          style: Styles.bold_white_16,
        ),
      ),
    );
  }
}
