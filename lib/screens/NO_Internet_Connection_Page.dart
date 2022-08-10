import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';

class NoInternetConnectionPage extends StatelessWidget {
  static const routeName = '/NoInternetConnectionPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            /*    decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(WelComeImage),
              */ /*fit: BoxFit.cover,*/ /*
            ),
          ),*/
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  welcomeTextWidget(),
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(NO_INTERNET_PNG),
                  sloganText(),
                  SizedBox(
                    height: 40,
                  ),
                  getButton(context),
                  SizedBox(
                    height: 40,
                  )
                ])));
  }

  Widget welcomeTextWidget() {
    return Column(
      children: [
        AppText(
          text: "OOPS !",
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Getirblue,
        ),
        /* AppText(
          text: "to our store",
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),*/
      ],
    );
  }

  Widget sloganText() {
    return AppText(
      text: "No Internet , Check your network connection.",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.justify,
      color: Getirblue /*.withOpacity(0.7)*/,
    );
  }

  Widget getButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, TabHomePage.routeName, clearAllStack: true);
      },
      child: Card(
        elevation: 10,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              "TRY AGAIN",
              style: TextStyle(
                  color: colorWhite, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        color: Getirblue,
      ),
    );

    /*AppButton(
      label: "Get Started",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () async {
        // _checkPermission(context);
        //_checkStoragePermission(context);
        onGetStartedClicked(context);
      },
      // color: Getirblue,
      textcolor: colorWhite,
      CardColor: Colors.amber,
    );*/
  }
}
