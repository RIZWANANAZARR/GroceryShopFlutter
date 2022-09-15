import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/WelcomeScreen';

  final String imagePath = "assets/images/g_one.png";

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
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                /* crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,*/
                children: [
                  /* icon(),*/
                  SizedBox(
                    height: 40,
                  ),
                  welcomeTextWidget(),
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(WelComeImage),
                  sloganText(),
                  SizedBox(
                    height: 40,
                  ),
                  getButton(context),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget icon() {
    String iconPath = "assets/icons/app_icon.svg";
    return SvgPicture.asset(
      iconPath,
      width: 48,
      height: 56,
    );
  }

  Widget welcomeTextWidget() {
    return Column(
      children: [
        AppText(
          text: "Welcome",
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
      text: "Get your Groceries as fast as in hour",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Getirblue /*.withOpacity(0.7)*/,
    );
  }

  Widget getButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onGetStartedClicked(context);
      },
      child: Card(
        elevation: 10,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              "Get Started",
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

  void onGetStartedClicked(BuildContext context) {
    /* Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        //  return DashboardScreen();
        return LoginScreen();
      },
    ));*/
    navigateTo(context, LoginScreen.routeName, clearAllStack: true);
  }

  Future<void> _checkPermission(BuildContext context) async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Turn on location services before requesting permission."),
      ));
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      _checkStoragePermission(context);
      // onGetStartedClicked(context);
    } else if (status == PermissionStatus.denied) {
      _checkPermission(context);

      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  Future<void> _checkStoragePermission(BuildContext context) async {
    final status = await Permission.storage;
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      onGetStartedClicked(context);
    } else if (status == PermissionStatus.denied) {
      _checkStoragePermission(context);
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }
}
