import 'package:flutter/material.dart';
import 'package:movies/core/themes/app_themes.dart';

abstract class BaseView<T extends StatefulWidget> extends State<T> {
  late Size size;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
  }

  void showInfoAlertDialog(
      {required String titleText, int durationInSeconds = 2}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: AppThemes.darkPrimaryColor.withOpacity(0.5),
            title: Text(
              textAlign: TextAlign.center,
              titleText,
              style: theme.textTheme.labelMedium!.copyWith(fontSize: 30),
            ));
      },
    );
    Future.delayed(
      Duration(seconds: durationInSeconds),
      () {
        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }
}
