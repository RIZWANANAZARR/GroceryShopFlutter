import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:image_picker/image_picker.dart';

Widget getCommonDivider({double thickness, double width: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    height: thickness,
    color: Colors.white60,
    width: width,
  );
}

Widget showCustomToast({String Title}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: Colors.white),
        SizedBox(
          width: 12.0,
        ),
        Text(
          Title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

pickImage(
  BuildContext context, {
  @required Function(File f) onImageSelection,
}) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      XFile capturedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 100);

                      if (capturedFile != null) {
                        onImageSelection(File(capturedFile.path));
                      }
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    XFile capturedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 100);
                    if (capturedFile != null) {
                      onImageSelection(File(capturedFile.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}

productbottomsheet(
  BuildContext context, {
  @required Function(File f) onImageSelection,
}) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      XFile capturedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 100);

                      if (capturedFile != null) {
                        onImageSelection(File(capturedFile.path));
                      }
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    XFile capturedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 100);
                    if (capturedFile != null) {
                      onImageSelection(File(capturedFile.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}

Widget getCommonButton(ThemeData baseTheme, Function onPressed, String text,
    {Color textColor: colorWhite,
    Color backGroundColor: colorPrimary,
    double elevation: 0.0,
    bool showOnlyBorder: false,
    Color borderColor: colorPrimary,
    double textSize: BUTTON_TEXT_FONT_SIZE,
    double width: double.maxFinite,
    double height: COMMON_BUTTON_HEIGHT,
    double radius: COMMON_BUTTON_RADIUS}) {
  if (!showOnlyBorder) {
    borderColor = backGroundColor;
  }
  return Container(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      /* color: backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: BorderSide(width: showOnlyBorder ? 2 : 0, color: borderColor)),
      elevation: elevation,*/
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: baseTheme.textTheme.button
            .copyWith(color: textColor, fontSize: textSize),
      ),
    ),
  );
}
