import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:grocery_app/bloc/others/firstscreen/first_screen_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/api_request/Customer/customer_registration_request.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/rounded_progress_bar.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class RegistrationScreen extends BaseStatefulWidget {
  static const routeName = '/RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends BaseState<RegistrationScreen>
    with BasicScreen, WidgetsBindingObserver {
  FToast fToast;

  double DEFAULT_SCREEN_LEFT_RIGHT_MARGIN = 30.0;

  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fetchaddresswithlocation = TextEditingController();
  TextEditingController _userContactController = TextEditingController();

  String InvalidUserMessage = "";
  bool _isObscure = true;
  String SiteUrl = "";
  ThemeData baseTheme;

  String Address = 'search';
  String Latitude;
  String Longitude;
  Position _currentPosition;
  Location location = new Location();

  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;
  bool isLoading = false;
  ProgressBarHandler _handler;
  FirstScreenBloc _categoryScreenBloc;

  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    fToast = FToast();
    fToast.init(context);
    _categoryScreenBloc = FirstScreenBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          /*if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          /*   if(currentState is InquiryProductSaveResponseState ||
              currentState is CartDeleteResponseState

          )
          {
            return true;

          }*/
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          if (state is CustomerRegistrationResponseState) {
            _onRegistrationSucess(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerRegistrationResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    //var theme =ThemeData(colorScheme: ColorScheme(secondary:Getirblue ),);

    baseTheme = /*Theme.of(context).copyWith(
        primaryColor: Colors.lightGreen,
        colorScheme: ThemeData.light().colorScheme.copyWith(
          secondary: Getirblue,
        ),
    );*/
        ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.red, // Your accent color
    ));
    // ColorScheme.fromSwatch().copyWith(primary: Getirblue,secondary: Getirblue));

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
      },
    );

    var scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            navigateTo(context, LoginScreen.routeName, clearAllStack: true);
          },
          child: Container(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.arrow_back,
                size: 35,
                color: Getirblue,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              top: 50,
              bottom: 50),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopView(),
                    SizedBox(height: 50),
                    _buildLoginForm(context)
                  ],
                ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: <Widget>[
          scaffold,
          progressBar,
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, LoginScreen.routeName, clearAllStack: true);
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Image.network("https://thumbs.dreamstime.com/b/avatar-supermarket-worker-cash-register-customer-car-full-groceries-colorful-design-vector-illustration-163995684.jpg",
          width: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.fitWidth,),*/
        SizedBox(
          height: 5,
        ),
        /* Text(
          "Login",
          style: baseTheme.textTheme.headline1,
        ),*/
        Text(
          "Registration",
          style: TextStyle(
            color: Getirblue,
            fontSize: 48,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Register a new account",
          style: TextStyle(
            color: Getirblue,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        logoutButton(context),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Username",
            hint: "enter username",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icon(Icons.person),
            controller: _userNameController),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Email",
            hint: "enter email address",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icon(Icons.email_outlined),
            controller: _userEmailController),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Contact No.",
            maxLength: 16,
            hint: "enter contact number",
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(Icons.phone_android),
            controller: _userContactController),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Password",
            hint: "enter password",
            obscureText: _isObscure,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            controller: _passwordController),
        SizedBox(
          height: 35,
        ),
        Container(
          // margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Address",
              style: TextStyle(
                  color: colorPrimary,
                  fontSize:
                      18) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
          child: TextFormField(
            controller: _fetchaddresswithlocation,
            minLines: 5,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: 'Enter Details',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: new BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Getirblue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Getirblue),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Getirblue),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1, color: Getirblue)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1, color: Getirblue)),
            ),
          ),
        ),
        /*getCommonTextFormField(context, baseTheme,
            title: "Re-Enter Password",
            hint: "enter password",
            obscureText: _isObscure,
            textInputAction: TextInputAction.done,
            suffixIcon:
            IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            controller: _re_enter_passwordController
        ),
        SizedBox(
          height: 35,
        ),*/
        SizedBox(
          height: 20,
        ),
        getButton(context),
        SizedBox(
          height: 20,
        ),
        _buildGoogleButtonView(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Register",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () {
        /* TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fetchaddresswithlocation = TextEditingController();*/
        if (_userEmailController.text != "") {
          if (_userNameController.text != "") {
            if (_passwordController.text != "") {
              if (_userContactController.text != "") {
                if (_fetchaddresswithlocation.text != "") {
                  /* SignUpDetails signupDetails = new SignUpDetails();
                  signupDetails.Email = _userEmailController.text;
                  signupDetails.UserName = _userNameController.text;

                  signupDetails.Password = _passwordController.text;
                  signupDetails.Address = _fetchaddresswithlocation.text;
                 // SharedPrefHelper.instance.setSignUpData(signupDetails);
                  SharedPrefHelper.instance.putString(SharedPrefHelper.IS_REGISTERED,"is_registered");*/

                  String CustomerName = _userNameController.text.toString();
                  String Address = _fetchaddresswithlocation.text.toString();
                  String EmailAddress = _userEmailController.text.toString();
                  String ContactNo = _userContactController.text.toString();
                  String LoginUserID =
                      _userNameController.text.toString().trim();
                  String BlockCustomer = "1";
                  String ProfileImage = "";
                  String Password = _passwordController.text.toString();
                  String CompanyId = CompanyID;

                  _categoryScreenBloc.add(CustomerRegistrationRequestCallEvent(
                      0,
                      CustomerRegistrationRequest(
                          CustomerName: CustomerName,
                          Address: Address,
                          EmailAddress: EmailAddress,
                          ContactNo: ContactNo,
                          LoginUserID: LoginUserID,
                          BlockCustomer: BlockCustomer,
                          ProfileImage: ProfileImage,
                          Password: Password,
                          CompanyId: CompanyId,
                          CustomerType: "customer")));
                } else {
                  showCommonDialogWithSingleOption(
                      context, "Address is required!",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                  });
                }
              } else {
                showCommonDialogWithSingleOption(
                    context, "Contact No. is required!",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            } else {
              showCommonDialogWithSingleOption(context, "Password is required!",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          } else {
            showCommonDialogWithSingleOption(context, "UserName is required!",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Email address is required!", positiveButtonTitle: "OK",
              onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      },
    );
  }

  Widget _buildGoogleButtonView() {
    return Visibility(
      visible: false,
      child: Container(
        width: double.maxFinite,
        height: COMMON_BUTTON_HEIGHT,
        // ignore: deprecated_member_use
        child: ElevatedButton(
          onPressed: () {
            //_onTapOfSignInWithGoogle();
          },
          /*color: colorRedLight,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(COMMON_BUTTON_RADIUS)),
          ),
          elevation: 0.0,*/
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                IC_GOOGLE,
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Sign in with Google",
                textAlign: TextAlign.center,
                style: baseTheme.textTheme.button,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _getCurrentLocation();
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          /*visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Getirblue,
          textColor: Colors.white,
          elevation: 0.0,
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),*/
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Icon(
                  Icons.my_location,
                  color: colorWhite,
                ),
                width: 10,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Current Location",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          onPressed: () {
            _getCurrentLocation();
          },
        ),
      ),
    );
  }

  _getCurrentLocation() {
    geolocator123
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
        .then((Position position) async {
      _currentPosition = position;
      Longitude = position.longitude.toString();
      Latitude = position.latitude.toString();
      Address = "";

      Address = await getAddressFromLatLng(
          Latitude, Longitude, "AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso");
      _handler.dismiss();

      _fetchaddresswithlocation.text = Address;
    }).catchError((e) {
      print(e);
    });

    /* location.onLocationChanged.listen((LocationData currentLocation) async {
      print("OnLocationChange" +
          " Location : " +
          currentLocation.latitude.toString());

      Latitude = currentLocation.latitude.toString();
      Longitude = currentLocation.longitude.toString();
      Address = await getAddressFromLatLng(Latitude,Longitude,"AIzaSyC8I7M35BI9V0wVOGXpLIaR7SlArdi3fso");

    });*/
  }

  Future<String> getAddressFromLatLng(
      String lat, String lng, String skey) async {
    _handler.show();
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$skey&latlng=$lat,$lng';
    if (lat != "" && lng != "null") {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");

        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  void _onRegistrationSucess(
      CustomerRegistrationResponseState state, BuildContext context) {
    print("Response Customer" +
        " Response : " +
        state.customerRegistrationResponse.details[0].column2.toString());

    if (state.customerRegistrationResponse.details[0].column2 ==
        "Information Added Successfully") {
      showCommonDialogWithSingleOption(
          context, state.customerRegistrationResponse.details[0].column2,
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, LoginScreen.routeName, clearAllStack: true);
      });
    } else {
      showCommonDialogWithSingleOption(
          context, state.customerRegistrationResponse.details[0].column2,
          positiveButtonTitle: "OK");
    }
    /* fToast.showToast(
       child: showCustomToast(Title: "registered successful"),
       gravity: ToastGravity.BOTTOM,
       toastDuration: Duration(seconds: 2),
     );*/
  }
}
