import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/screens/NO_Internet_Connection_Page.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';

final primary = Getirblue;
final secondary = Colors.black;
final background = Colors.white10;
const colorPrimaryLight = Getirblue;

const colorGrayDark = const Color(0xff6C777C);
const colorGray = const Color(0xffC4C4C4);
const CAPTION_SMALLER_TEXT_FONT_SIZE = 12.0;

Future navigateTo(BuildContext context, String routeName,
    {Object arguments,
    bool clearAllStack: false,
    bool clearSingleStack: false,
    bool useRootNavigator: false,
    String clearUntilRoute}) async {
  if (clearAllStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(routeName, (route) => false,
            arguments: arguments);
  } else if (clearSingleStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .popAndPushNamed(routeName, arguments: arguments);
  } else if (clearUntilRoute != null) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(
            routeName, ModalRoute.withName(clearUntilRoute),
            arguments: arguments);
  } else {
    return await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamed(routeName, arguments: arguments);
  }
}

Future showCommonDialogWithSingleOption(
  BuildContext context,
  String message, {
  String positiveButtonTitle = "OK",
  GestureTapCallback onTapOfPositiveButton,
  bool useRootNavigator = true,
  EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
}) async {
  ThemeData baseTheme = Theme.of(context);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context2) {
      return message != "Error During Communication: No Internet Connection"
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorWhite,
                ),
                width: double.maxFinite,
                margin: margin,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(minHeight: 100),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            message,
                            maxLines: 15,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: baseTheme.textTheme.button,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: getCommonDivider(),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 60,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            positiveButtonTitle,
                            textAlign: TextAlign.center,
                            style: baseTheme.textTheme.button
                                .copyWith(color: colorPrimaryLight),
                          ),
                        ),
                      ),
                      onTap: onTapOfPositiveButton ??
                          () {
                            if (message !=
                                "Error During Communication: No Internet Connection") {
                              Navigator.of(Globals.context).pop();
                            } else {
                              navigateTo(context, TabHomePage.routeName,
                                  clearAllStack: true);
                            }
                            // Navigator.of(context, rootNavigator: true).pop();
                          },
                    )
                  ],
                ),
              ),
            )
          : NoInternetConnectionPage();
    },
  );
}

Widget getCommonTextFormField(BuildContext context, ThemeData baseTheme,
    {String title: "",
    String hint: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 10),
    int maxLength: 1000,
    TextAlign textAlign: TextAlign.left,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator<String> validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatter,
    bool readOnly: false,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle1;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.subtitle2;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title.isNotEmpty
          ? Container(
              child: /*Text(
          title,
          style: titleTextStyle,
        ),*/
                  Text(
              title,
              style: TextStyle(
                color: Getirblue,
                fontSize: 18,
              ),
            ))
          : Container(),
      TextFormField(
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
        style: inputTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        cursorColor: colorPrimaryLight,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: maxLength,
        controller: controller,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: inputTextStyle.copyWith(color: colorGray),
          isDense: true,
          suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
          contentPadding: EdgeInsets.only(bottom: 10, top: 15),
          suffixIcon: IconTheme(
              data: IconThemeData(color: Getirblue), child: suffixIcon),
          counterText: "",
          errorStyle: baseTheme.textTheme.subtitle1.copyWith(
              color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorGrayDark, width: 0.4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorPrimaryLight, width: 1),
          ),
        ),
        validator: validator,
        onChanged: onTextChanged,
        onFieldSubmitted: onSubmitted,
      )
    ],
  );
}

MaterialPageRoute getMaterialPageRoute(Widget screen) {
  return MaterialPageRoute(
    builder: (context) {
      return screen;
    },
  );
}

/*Future showCommonDialogWithSingleOption(
    BuildContext context,
    String message, {
      String positiveButtonTitle = "OK",
      GestureTapCallback onTapOfPositiveButton,
      bool useRootNavigator = true,
      EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
    }) async {
  ThemeData baseTheme = Theme.of(context);

  await showDialog(
    context: context,
    builder: (context2) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorWhite,
          ),
          width: double.maxFinite,
          margin: margin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 100),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      maxLines: 15,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: baseTheme.textTheme.button,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: getCommonDivider(),
              ),
              GestureDetector(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      positiveButtonTitle,
                      textAlign: TextAlign.center,
                      style: baseTheme.textTheme.button
                          .copyWith(color: colorPrimaryLight),
                    ),
                  ),
                ),
                onTap: onTapOfPositiveButton ??
                        () {
                      Navigator.of(Globals.context).pop();
                      // Navigator.of(context, rootNavigator: true).pop();
                    },
              )
            ],
          ),
        ),
      );
    },
  );
}*/

Future showCommonDialogWithTwoOptions(BuildContext context, String message,
    {String negativeButtonTitle,
    String positiveButtonTitle,
    bool useRootNavigator = true,
    GestureTapCallback onTapOfNegativeButton,
    GestureTapCallback onTapOfPositiveButton}) async {
  ThemeData baseTheme = Theme.of(context);
  await showDialog(
    context: context,
    builder: (context2) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorWhite,
          ),
          width: double.maxFinite,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 100),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      maxLines: 15,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: baseTheme.textTheme.button,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: getCommonDivider(),
              ),
              Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style: baseTheme.textTheme.button,
                            ),
                          ),
                        ),
                        onTap: onTapOfNegativeButton ??
                            () {
                              Navigator.of(context,
                                      rootNavigator: useRootNavigator)
                                  .pop();
                            },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: getCommonVerticalDivider(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              "Yes",
                              textAlign: TextAlign.center,
                              style: baseTheme.textTheme.button
                                  .copyWith(color: colorPrimaryLight),
                            ),
                          ),
                        ),
                        onTap: onTapOfPositiveButton ??
                            () {
                              Navigator.of(context,
                                      rootNavigator: useRootNavigator)
                                  .pop();
                            },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget getCommonVerticalDivider(
    {double thickness, double height: double.maxFinite}) {
  if (thickness == null) {
    thickness = 1.00;
  }
  return Container(
    width: thickness,
    color: colorGray,
    height: height,
  );
}

bool shouldPaginate(dynamic scrollInfo,
    {AxisDirection axisDirection: AxisDirection.down}) {
  return scrollInfo is ScrollEndNotification &&
      scrollInfo.metrics.extentAfter == 0 &&
      scrollInfo.metrics.maxScrollExtent > 0 &&
      scrollInfo.metrics.axisDirection == axisDirection;
}

showcustomdialogWithOnlyName(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      15.0) //                 <--- border radius here
                  ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary), //Change color
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      values[index].Name,
                                      style: TextStyle(color: colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),


                            },
                              child: Text(values[index].Name),
                            );*/
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
          /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
        ],
      );
    },
  );
}
