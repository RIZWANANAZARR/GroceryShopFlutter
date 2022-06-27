import 'package:flutter/material.dart';

import 'color_resources.dart';
import 'dimen_resources.dart';
import 'font_resources.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(

      accentColor: colorPrimary,
      primaryColor: colorPrimary,
      primaryColorDark: colorPrimaryDark,
      buttonTheme: base.buttonTheme,
      scaffoldBackgroundColor: Colors.white,
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: base.primaryTextTheme,//_buildTextTheme(base.primaryTextTheme),
      accentTextTheme: base.accentTextTheme,//_buildTextTheme(base.accentTextTheme),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        labelStyle: base.textTheme.subtitle2,
        contentPadding: const EdgeInsets.only(bottom: 0),
      ));
}

///add multiple styles as per your app's requirement
TextTheme _buildTextTheme(TextTheme base) {
  //TODO add other fonts once design arrives
  return base.copyWith(
    headline1: base.headline1.copyWith(
      fontSize: HEADLINE1_TEXT_FONT_SIZE, //24 - semibold
      fontFamily: Poppins_Regular, //bigger headings
      color: colorBlack,
    ),
    headline2: base.headline2.copyWith(
      fontSize: HEADLINE2_TEXT_FONT_SIZE, //22 - regular
      fontFamily: Poppins_Regular, //smaller and regular descriptions
      color: colorBlack,
    ),
    headline3: base.headline3.copyWith(
      fontSize: HEADLINE3_TEXT_FONT_SIZE, //18 - semibold
      fontFamily: Poppins_Regular, //smaller headings
      color: colorBlack,
    ),
    headline4: base.headline4.copyWith(
      fontSize: HEADLINE4_TEXT_FONT_SIZE, //24 - bold
      fontFamily: Poppins_Regular, //screens' headings
      color: colorWhite,
    ),
    headline5: base.headline5.copyWith(
      fontSize: HEADLINE5_TEXT_FONT_SIZE, //20 - extrabold
      fontFamily: Poppins_Regular, //screens' headings
      color: colorBlack,
    ),
    subtitle1: base.subtitle1.copyWith(
      fontSize: SUBTITLE1_TEXT_FONT_SIZE, //16 - semibold
      fontFamily: Poppins_Regular, //bigger captions
      color: colorBlack,
    ),
    bodyText1: base.bodyText1.copyWith(
      fontSize: BODY1_TEXT_FONT_SIZE, //18 - semibold
      fontFamily: Poppins_Regular, //edit texts
      color: colorBlack,
    ),
    bodyText2: base.bodyText2.copyWith(
      fontSize: BODY2_TEXT_FONT_SIZE, //18 - semibold
      fontFamily: Poppins_Regular, //titles of edit texts
      color: colorTextTitleGray,
    ),
    button: base.button.copyWith(
      fontSize: BUTTON_TEXT_FONT_SIZE, //20 - semibold
      fontFamily: Poppins_Regular, //button texts
      color: colorBlack,
    ),
    caption: base.caption.copyWith(
      fontSize: CAPTION_TEXT_FONT_SIZE, //14 semibold
      fontFamily: Poppins_Regular, //bottom texts like terms of service
      color: colorBlack,
    ),
  );
}

get commonPickerTransitionBuilder => (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
          primarySwatch:
              MaterialColor(colorPrimary.value, materialColorAccentCodes),
        )),
        // isMaterialAppTheme: true,
        child: child,
      );
    };
