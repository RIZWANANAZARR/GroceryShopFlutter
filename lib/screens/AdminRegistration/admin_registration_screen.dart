import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:grocery_app/bloc/others/firstscreen/first_screen_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_registration_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/all_name_id.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/rounded_progress_bar.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class AdminRegistrationScreen extends BaseStatefulWidget {
  static const routeName = '/AdminRegistrationScreen';

  @override
  _AdminRegistrationScreenState createState() =>
      _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends BaseState<AdminRegistrationScreen>
    with BasicScreen, WidgetsBindingObserver {
  FToast fToast;

  double DEFAULT_SCREEN_LEFT_RIGHT_MARGIN = 30.0;

  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fetchaddresswithlocation = TextEditingController();
  TextEditingController _userContactController = TextEditingController();
  TextEditingController _customerTypeController = TextEditingController();

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

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    FetchFollowupPriorityDetails();
    fToast = FToast();
    fToast.init(context);
    _categoryScreenBloc = FirstScreenBloc(baseBloc);

    _userNameController.text = _offlineLogindetails.details[0].customerName;
    _userEmailController.text = _offlineLogindetails.details[0].emailAddress;
    _passwordController.text = _offlineLogindetails.details[0].password;
    _fetchaddresswithlocation.text = _offlineLogindetails.details[0].address;
    _userContactController.text = _offlineLogindetails.details[0].contactNo;
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
          if (state is LoginResponseState) {
            _onLoginSucessResponse(state, context);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerRegistrationResponseState ||
              currentState is LoginResponseState) {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorWhite),
          onPressed: () =>
              navigateTo(context, AccountScreen.routeName, clearAllStack: true),
        ),
        backgroundColor: Getirblue,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                    SizedBox(height: 30),
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
    navigateTo(context, AccountScreen.routeName, clearAllStack: true);
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
          "My Profile",
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
          "Update details from here",
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
            controller: _userNameController,
            titleTextStyle: TextStyle(fontSize: 10)),
        SizedBox(
          height: 15,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Email",
            hint: "enter email address",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icon(Icons.email_outlined),
            controller: _userEmailController),
        SizedBox(
          height: 15,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Contact No.",
            maxLength: 16,
            hint: "enter contact number",
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(Icons.phone_android),
            controller: _userContactController),
        SizedBox(
          height: 15,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Password",
            hint: "enter password",
            obscureText: _isObscure,
            readOnly: true,
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
          height: 15,
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

        /*  CustomDropDown1("Customer Type",
            enable1: false,
            title: "Customer Type",
            hintTextvalue: "Tap to Select Customer Type",
            icon: Icon(Icons.arrow_drop_down),
            controllerForLeft: _customerTypeController,
            Custom_values1: arr_ALL_Name_ID_For_Folowup_Priority),*/
        SizedBox(
          height: 15,
        ),
        getButton(context),
        /* SizedBox(
          height: 20,
        ),
        _buildGoogleButtonView(),
        SizedBox(
          height: 20,
        ),*/
      ],
    );
  }

  getButton(BuildContext context) {
    return AppButton(
      label: "Update Profile",
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
                  showCommonDialogWithTwoOptions(
                    context,
                    "Do you want to Update Your Profile ?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes",
                    onTapOfPositiveButton: () {
                      Navigator.pop(context);
                      _categoryScreenBloc.add(
                          CustomerRegistrationRequestCallEvent(
                              _offlineLogindetails.details[0].customerID,
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
                                  CustomerType: _offlineLogindetails
                                      .details[0].customerType)));
                    },
                  );
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
        navigateTo(context, AccountScreen.routeName, clearAllStack: true);
      });
    } else {
      showCommonDialogWithSingleOption(
          context, state.customerRegistrationResponse.details[0].column2,
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        _categoryScreenBloc.add(LoginRequestCallEvent(LoginRequest(
            EmailAddress: state.customerRequest.EmailAddress,
            Password: state.customerRequest.Password,
            CompanyId: CompanyID)));
      });
    }
    /* fToast.showToast(
       child: showCustomToast(Title: "registered successful"),
       gravity: ToastGravity.BOTTOM,
       toastDuration: Duration(seconds: 2),
     );*/
  }

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "admin";
      } else if (i == 1) {
        all_name_id.Name = "employee";
      } else if (i == 2) {
        all_name_id.Name = "customer";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onLoginSucessResponse(LoginResponseState state, BuildContext context) {
    print("LoginSucess" + state.loginResponse.details[0].emailAddress);
    String EmpName = state.loginResponse.details[0].customerName;
    if (EmpName != "") {
      SharedPrefHelper.instance
          .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
      SharedPrefHelper.instance.setLoginUserData(state.loginResponse);
      navigateTo(context, AccountScreen.routeName, clearAllStack: true);
    }
  }
}
