
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/color.dart';


ThemeData sunRunThemeBasic() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: "Roboto",
        fontSize: 22.0,
        color: Colors.white
      ),
      title: base.title.copyWith(
        fontFamily: "Roboto",
        color: Colors.white,
      ),
    );
  }

  final ThemeData dark = ThemeData.dark();

  return dark.copyWith(
      primaryColor: SunRunColors.djk_accent,
      textTheme: _basicTextTheme(dark.textTheme),
      buttonColor: SunRunColors.djk_accent,
      buttonTheme: ButtonThemeData(
        buttonColor: SunRunColors.djk_accent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:  MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused))
                return SunRunColors.djk_accent_dark;
              if (states.contains(MaterialState.hovered))
                return SunRunColors.djk_accent_dark;
              if (states.contains(MaterialState.pressed))
                return SunRunColors.djk_accent_dark;
              return SunRunColors.djk_accent;
            }
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SunRunColors.djk_bg_darker,
        actionTextColor: Colors.white
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
  );
  //
  // final ThemeData light = ThemeData.dark();
  // return light.copyWith(textTheme: _basicTextTheme(light.textTheme));

}

