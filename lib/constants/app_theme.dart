import 'package:echo_me_mobile/constants/colors.dart';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/constants/font_family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData themeData = getTheme(isDarkMode: false);

final ThemeData themeDataDark = getTheme(isDarkMode: true);

ThemeData getTheme({bool isDarkMode = false}) {
  return ThemeData(
    fontFamily: FontFamily.productSans,
    errorColor: isDarkMode ? Colours.dark_red : Colours.red,
    primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      secondary: isDarkMode ? Colours.dark_app_main : Colours.app_main,
    ),
    indicatorColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
    scaffoldBackgroundColor: isDarkMode ? Colours.dark_bg_color : Colors.white,
    canvasColor: isDarkMode ? Colours.dark_material_bg : Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colours.app_main.withAlpha(70),
      selectionHandleColor: Colours.app_main,
      cursorColor: Colours.app_main,
    ),
    textTheme: TextTheme(
      subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
      bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
      subtitle2: isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: isDarkMode ? Colours.dark_bg_color : Colors.white,
      systemOverlayStyle:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
    dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.dark_line : Colours.line,
        space: 0.6,
        thickness: 0.6),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    ),
    visualDensity: VisualDensity.standard,
  );
}

class TextStyles {
  TextStyles._();

  static const TextStyle textSize12 = TextStyle(
    fontSize: Dimens.font_sp12,
  );
  static const TextStyle textSize16 = TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static const TextStyle textBold14 =
      TextStyle(fontSize: Dimens.font_sp14, fontWeight: FontWeight.bold);
  static const TextStyle textBold16 =
      TextStyle(fontSize: Dimens.font_sp16, fontWeight: FontWeight.bold);
  static const TextStyle textBold18 =
      TextStyle(fontSize: Dimens.font_sp18, fontWeight: FontWeight.bold);
  static const TextStyle textBold24 =
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
  static const TextStyle textBold26 =
      TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold);

  static const TextStyle textGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );
  static const TextStyle textDarkGray14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.dark_text_gray,
  );

  static const TextStyle textWhite14 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
  );

  static const TextStyle text = TextStyle(
      fontSize: Dimens.font_sp14,
      color: Colours.text,
      textBaseline: TextBaseline.alphabetic);
  static const TextStyle textDark = TextStyle(
      fontSize: Dimens.font_sp14,
      color: Colours.dark_text,
      textBaseline: TextBaseline.alphabetic);

  static const TextStyle textGray12 = TextStyle(
      fontSize: Dimens.font_sp12,
      color: Colours.text_gray,
      fontWeight: FontWeight.normal);
  static const TextStyle textDarkGray12 = TextStyle(
      fontSize: Dimens.font_sp12,
      color: Colours.dark_text_gray,
      fontWeight: FontWeight.normal);

  static const TextStyle textHint14 = TextStyle(
      fontSize: Dimens.font_sp14, color: Colours.dark_unselected_item_color);
}
