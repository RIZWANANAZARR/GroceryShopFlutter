import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:grocery_app/bloc/others/firstscreen/first_screen_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/api_request/Customer/customer_forgot_request.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/rounded_progress_bar.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class ForgotPasswordScreen extends BaseStatefulWidget {
  static const routeName = '/ForgotPasswordScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseState<ForgotPasswordScreen>
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
          if (state is ForgotResponseState) {
            _onRegistrationSucess(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ForgotResponseState) {
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
          "Forgot Password",
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
          "Retrieve Your Password Details ",
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
            hint: "enter contact number",
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(Icons.phone_android),
            controller: _userContactController),
        SizedBox(
          height: 25,
        ),
        getButton(context),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Get Password",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () {
        if (_userEmailController.text != "") {
          if (_userContactController.text != "") {
            String EmailAddress = _userEmailController.text.toString();
            String ContactNo = _userContactController.text.toString();
            String CompanyId = CompanyID;

            _categoryScreenBloc.add(ForgotRequestCallEvent(ForgotRequest(
                EmailAddress: EmailAddress,
                ContactNo: ContactNo,
                CompanyId: CompanyId)));
          } else {
            showCommonDialogWithSingleOption(
                context, "Contact No. is required!", positiveButtonTitle: "OK",
                onTapOfPositiveButton: () {
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

  Widget logoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _getCurrentLocation();
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          /* visualDensity: VisualDensity.compact,
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
                  color: Colors.indigo,
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

  void _onRegistrationSucess(ForgotResponseState state, BuildContext context) {
    if (state.forgotResponse.totalCount != 0) {
      showCommonDialogWithSingleOption(
          context,
          "Your Password Is : " +
              state.forgotResponse.details[0].password.toString(),
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, LoginScreen.routeName, clearAllStack: true);
      });
    } else {
      showCommonDialogWithSingleOption(context, "Enter Valid Details",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        navigateTo(context, ForgotPasswordScreen.routeName);
      });
    }
  }
}
