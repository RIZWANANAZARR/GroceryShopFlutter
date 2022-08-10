import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:grocery_app/firebase_options.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app.dart';

Directory _appDocsDir;
String TitleNotificationSharvaya = "";

String Latitude;
String Longitude;
bool is_LocationService_Permission;
final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;
Location location = new Location();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefHelper.createInstance();
  await OfflineDbHelper.createInstance();

  checkPermissionStatus();
  getToken();

  runApp(MyApp());
}

void getToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCMToken" + " Token : " + fcmToken.toString());
}

void checkPermissionStatus() async {
  bool granted = await Permission.location.isGranted;
  bool Denied = await Permission.location.isDenied;
  bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;
  bool StorageGranted = await Permission.storage.isGranted;
  bool StorageDenied = await Permission.storage.isDenied;
  bool StoragePermanentlyDenied = await Permission.storage.isPermanentlyDenied;

  print("PermissionStatus" +
      "Granted : " +
      granted.toString() +
      " Denied : " +
      Denied.toString() +
      " PermanentlyDenied : " +
      PermanentlyDenied.toString());

  if (Denied == true || StorageDenied == true) {
    // openAppSettings();
    is_LocationService_Permission = false;

    if (Platform.isAndroid) {
      /* showCommonDialogWithSingleOption(Globals.context,
            "Location & Storage permission are required , You have to click on OK button to Allow the location access !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
              await openAppSettings();
              Navigator.of(Globals.context).pop();
            });*/

    }

    await Permission.location.request();
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }

// You can can also directly ask the permission about its status.
  if (await Permission.location.isRestricted ||
      await Permission.storage.isRestricted) {
    // The OS restricts access, for example because of parental controls.
    openAppSettings();
  }
  if (PermanentlyDenied == true || StoragePermanentlyDenied == true) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    is_LocationService_Permission = false;
    openAppSettings();
  }

  if (granted == true || StorageGranted == true) {
    // The OS restricts access, for example because of parental controls.
    is_LocationService_Permission = true;
    _getCurrentLocation();

    /*if (serviceLocation == true) {
        // Use location.
        _serviceEnabled=false;

         location.requestService();


      }
      else{
        _serviceEnabled=true;
        _getCurrentLocation();



      }*/
  }
}

_getCurrentLocation() {
  geolocator123
      .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
      .then((Position position) async {
    Longitude = position.longitude.toString();
    Latitude = position.latitude.toString();
  }).catchError((e) {
    print(e);
  });

  location.onLocationChanged.listen((LocationData currentLocation) async {
    // Use current location
    print("OnLocationChange" +
        " Location : " +
        currentLocation.latitude.toString());
    //  placemarks = await placemarkFromCoordinates(currentLocation.latitude,currentLocation.longitude);
    // final coordinates = new Coordinates(currentLocation.latitude,currentLocation.longitude);
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    //  print("${first.featureName} : ${first.addressLine}");
    Latitude = currentLocation.latitude.toString();
    Longitude = currentLocation.longitude.toString();
    SharedPrefHelper.instance.setLatitude(Latitude);
    SharedPrefHelper.instance.setLongitude(Longitude);

    //  Address = "${first.featureName} : ${first.addressLine}";
  });

  // _FollowupBloc.add(LocationAddressCallEvent(LocationAddressRequest(key:"AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso",latlng:Latitude+","+Longitude)));
}
