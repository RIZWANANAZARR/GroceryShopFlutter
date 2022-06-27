import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/ui/res/color_resources.dart';
import 'package:grocery_app/utils/general_utils.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();

    const delay = const Duration(seconds: 3);
    Future.delayed(delay, () => onTimerFinished());
  }

  void onTimerFinished() {
    navigateTo(context, WelcomeScreen.routeName, clearAllStack: true);
  }

  @override
  Widget build(BuildContext context) {
    //428 * 926
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: colorWhite,
        body: Center(
          child: Image.asset(
            SKGIF,
          ),
        )

        /*Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 300),
                  padding: EdgeInsets.all(5),
                  height: 150,
                  child: splashScreenIcon()),
            ),
            splashScreenIcon1(),
          ],
        ),
      ),*/
        );
  }
}

Widget splashScreenIcon() {
  String iconPath = "assets/icons/sk_logo_1.svg";
  return SvgPicture.asset(
    iconPath,
  );
}

Widget splashScreenIcon1() {
  String iconPath = "assets/icons/splash_screen_icon.svg";
  String gilroyFontFamily = "Gilroy";

  return Center(
      child: Text(
    "Online Groceries",
    style: TextStyle(
        fontFamily: gilroyFontFamily, color: Colors.white, fontSize: 20),
  )); /*SvgPicture.asset(
    iconPath,
  );*/
}
