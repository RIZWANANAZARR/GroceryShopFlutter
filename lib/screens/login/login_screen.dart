import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/firstscreen/first_screen_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/company_details_request.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:grocery_app/screens/login/change_password_screen.dart';
import 'package:grocery_app/screens/registration/registration_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class LoginScreen extends BaseStatefulWidget {
  static const routeName = '/LoginScreen';

  // const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen>
    with BasicScreen, WidgetsBindingObserver {
  double DEFAULT_SCREEN_LEFT_RIGHT_MARGIN = 30.0;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String InvalidUserMessage = "";
  bool _isObscure = true;
  String SiteUrl = "";
  ThemeData baseTheme;
  FirstScreenBloc _firstScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginResponse _offlineLoggedInDetailsData;
  ProfileListResponseDetails _searchInquiryListResponse;

  List<LoginResponseDetails> arrdetails = [];
  List<CartModel> arrCartAPIList = [];
  List<ProductCartModel> getproductlistfromdb = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firstScreenBloc = FirstScreenBloc(baseBloc);

    _firstScreenBloc
      ..add(CompanyDetailsCallEvent(
          CompanyDetailsApiRequest(serialKey: "BBBB-BBBB-BBBB-BBBB")));
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

    return Scaffold(
      backgroundColor: colorWhite,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              top: 50,
              bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopView(),
              SizedBox(height: 40),
              _buildLoginForm(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          if (state is ComapnyDetailsEventResponseState) {
            _onCompanyDetailsCallSucess(state.companyDetailsResponse);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ComapnyDetailsEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          if (state is LoginResponseState) {
            _onLoginSucessResponse(state, context);
          }
          if (state is DummyLoginResponseState) {
            _onDummyLoginSucessResponse(state, context);
          }
          if (state is ProductFavoriteResponseState) {
            _onFavoriteProductList(state, context);
          }
          if (state is ProductCartResponseState) {
            _onCartProductList(state, context);
          }

          if (state is InquiryProductSaveResponseState) {
            _OnSucessCartSaveResponse(state);
          }

          if (state is CartDeleteResponseState) {
            _ONCartDeleteResponse(state);
          }

          if (state is LoginProductCartResponseState) {
            _OnLoginCartPUSHTODB(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoginResponseState ||
              currentState is ProductFavoriteResponseState ||
              currentState is ProductCartResponseState ||
              currentState is DummyLoginResponseState ||
              currentState is InquiryProductSaveResponseState ||
              currentState is CartDeleteResponseState ||
              currentState is LoginProductCartResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            LogiPageLogo,
            width: 350,
            height: 200,
          ),
        ),
        /* Image.network("https://thumbs.dreamstime.com/b/avatar-supermarket-worker-cash-register-customer-car-full-groceries-colorful-design-vector-illustration-163995684.jpg",
          width: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.fitWidth,),*/
        SizedBox(
          height: 40,
        ),
        /* Text(
          "Login",
          style: baseTheme.textTheme.headline1,
        ),*/
        Text(
          "Login",
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
          "Log in to your existing account",
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
            suffixIcon: Icon(Icons.person),
            controller: _userNameController),
        SizedBox(
          height: 20,
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
          height: 20,
        ),
        Container(
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    _OnTaptoChangePassword();
                  },
                  child: Text(
                    "Reset Password ?",
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    _onTapOfForgetPassword();
                  },
                  child: Text(
                    "Forgot Password ?",
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // getButton(context),

        /* _buildGoogleButtonView(),
          SizedBox(
            height: 20,
          ),*/
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: getButton(context)),
            SizedBox(
              width: 10,
            ),
            Expanded(child: RegisterHere(context)),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        SkipLogin(context),
      ],
    );
  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Login",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 20),
      onPressed: () async {
        //onGetStartedClicked(context);
        /* final receverport = ReceivePort();

        await Isolate.spawn(sumofsomevalue, receverport.sendPort);

        receverport.listen((sum) {
          print(sum);
        });*/
        _firstScreenBloc.add(LoginRequestCallEvent(LoginRequest(
            EmailAddress: _userNameController.text.toString(),
            Password: _passwordController.text.toString(),
            CompanyId: _offlineCompanyData.details[0].pkId.toString())));

        /* if(_userNameController.text!="") {
          if(_passwordController.text!="") {
            if (SharedPrefHelper.IS_REGISTERED == "is_registered") {
              // addError(error: "Success");


              try{
                if (SharedPrefHelper.instance
                    .getSignUpData()
                    .UserName == _userNameController.text &&
                    SharedPrefHelper.instance
                        .getSignUpData()
                        .Password == _passwordController.text) {
                  SharedPrefHelper.instance.putBool(
                      SharedPrefHelper.IS_LOGGED_IN_DATA, true);
                  navigateTo(
                      context, DashboardScreen.routeName, clearAllStack: true);
                }
                else {
                  showCommonDialogWithSingleOption(
                      context, "Please Enter valid login Details",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                  });
                }

              }
              catch(E){
                showCommonDialogWithSingleOption(
                    context, "Please Enter valid login Details",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }



            }
            else {
              showCommonDialogWithSingleOption(
                  context, "Please Enter valid login Details",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }

          }
          else {
            showCommonDialogWithSingleOption(
                context, "Password is required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }


        }
        else {
          showCommonDialogWithSingleOption(
              context, "UserName is required !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }*/
      },
    );
  }

  Widget RegisterHere(BuildContext context) {
    return AppButton(
      label: "Register",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 20),
      onPressed: () {
        navigateTo(context, RegistrationScreen.routeName, clearAllStack: true);
      },
    );
  }

  Widget SkipLogin(BuildContext context) {
    return AppButton(
      label: "Skip",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 20),
      onPressed: () {
        _firstScreenBloc.add(DummyLoginRequestCallEvent(LoginRequest(
            EmailAddress: "dummy@gmail.com",
            Password: "dummy",
            CompanyId: _offlineCompanyData.details[0].pkId.toString())));

        // navigateTo(context, RegistrationScreen.routeName, clearAllStack: true);
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
          /* color: colorRedLight,
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

  void _onLoginSucessResponse(LoginResponseState state, BuildContext context) {
    arrdetails.clear();

    arrdetails.addAll(state.loginResponse.details);

    for (int i = 0; i < arrdetails.length; i++) {
      if (_userNameController.text.toString().toLowerCase() ==
          arrdetails[i].emailAddress.toString().toLowerCase()) {
        if (arrdetails[i].customerType != "supplier") {
          SharedPrefHelper.instance
              .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
          LoginResponse loginResponse = LoginResponse();
          List<LoginResponseDetails> arrdetails123 = [];

          LoginResponseDetails loginResponseDetails = LoginResponseDetails();
          loginResponseDetails.emailAddress = arrdetails[i].emailAddress;
          loginResponseDetails.customerID = arrdetails[i].customerID;
          loginResponseDetails.customerName = arrdetails[i].customerName;
          loginResponseDetails.contactNo = arrdetails[i].contactNo;
          loginResponseDetails.address = arrdetails[i].address;
          loginResponseDetails.emailAddress = arrdetails[i].emailAddress;
          loginResponseDetails.password = arrdetails[i].password;
          loginResponseDetails.customerType = arrdetails[i].customerType;
          loginResponseDetails.BlockCustomer = arrdetails[i].BlockCustomer;
          arrdetails123.add(loginResponseDetails);
          loginResponse.details = arrdetails123;
          loginResponse.totalCount = 1;
          SharedPrefHelper.instance.setLoginUserData(loginResponse);

          _offlineLoggedInDetailsData =
              SharedPrefHelper.instance.getLoginUserData();

          _firstScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(
              ProductCartDetailsRequest(
                  CompanyId: _offlineCompanyData.details[0].pkId.toString(),
                  CustomerID: arrdetails[i].customerID.toString())));
        }
        break;
      }
    }

    /*for (int i = 0; i < state.loginResponse.details.length; i++) {
      print("LoginSucess" + state.loginResponse.details[i].emailAddress);

      if (_userNameController.text.toString().toLowerCase() ==
          state.loginResponse.details[i].emailAddress
              .toString()
              .toLowerCase()) {
        print("testemails" +
            state.loginResponse.details[i].emailAddress.toString());
        if (state.loginResponse.details[i].customerType != "supplier") {
          String EmpName = state.loginResponse.details[i].customerName;

          if (EmpName != "") {
            SharedPrefHelper.instance
                .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);



            SharedPrefHelper.instance.setLoginUserData(state.loginResponse);
            _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
            _offlineLoggedInDetailsData =
                SharedPrefHelper.instance.getLoginUserData();

            _firstScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(
                ProductCartDetailsRequest(
                    CompanyId: _offlineCompanyData.details[0].pkId.toString(),
                    CustomerID:
                        state.loginResponse.details[i].customerID.toString())));
          }
        } else {
          commonalertbox("Supplier is Not Able to Use This App !",
              onTapofPositive: () async {
            Navigator.pop(context);
            navigateTo(context, LoginScreen.routeName, clearSingleStack: true);
          });
        }
        //break;
      }
    }*/
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        builder: (BuildContext ab) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            actions: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Getirblue, width: 2.00),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Alert!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Getirblue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: 10),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 1.00,
                thickness: 2.00,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTapofPositive ??
                    () {
                      Navigator.of(context, rootNavigator: useRootNavigator)
                          .pop();
                    },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  void _onCompanyDetailsCallSucess(
      CompanyDetailsResponse companyDetailsResponse) {
    if (companyDetailsResponse.details.length != 0) {
      SharedPrefHelper.instance.setCompanyData(companyDetailsResponse);
      _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
      SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, true);

      //navigateTo(context, FirstScreen.routeName, clearAllStack: true);

      print("Company Details : " +
          companyDetailsResponse.details[0].companyName.toString() +
          "");
    }
  }

  void _onTapOfForgetPassword() {
    navigateTo(context, ForgotPasswordScreen.routeName, clearAllStack: true);
  }

  void _onFavoriteProductList(
      ProductFavoriteResponseState state, BuildContext context) async {
    await OfflineDbHelper.getInstance().deleteContactTableFavorit();

    for (int i = 0; i < state.cartDeleteResponse.details.length; i++) {
      String name = state.cartDeleteResponse.details[i].productName;
      String Alias = state.cartDeleteResponse.details[i].productName;
      int ProductID = state.cartDeleteResponse.details[i].productID;
      int CustomerID = state.cartDeleteResponse.details[i].customerID;

      String Unit = state.cartDeleteResponse.details[i].unit;
      int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
      double Amount =
          state.cartDeleteResponse.details[i].unitPrice; //getTotalPrice();
      double DiscountPer = state.cartDeleteResponse.details[i].discountPercent;

      String ProductSpecification = "";
      String ProductImage = _offlineCompanyData.details[0].siteURL +
          "/productimages/" +
          state.cartDeleteResponse.details[i].productImage;

      double Vat = state.cartDeleteResponse.details[i].Vat;
      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          _offlineLoggedInDetailsData.details[0].customerName
              .replaceAll(' ', ""),
          _offlineCompanyData.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage,
          Vat);

      await OfflineDbHelper.getInstance()
          .insertProductToCartFavorit(productCartModel);
    }

    _firstScreenBloc.add(ProductCartDetailsRequestCallEvent(
        ProductCartDetailsRequest(
            CompanyId: _offlineCompanyData.details[0].pkId.toString(),
            CustomerID:
                _offlineLoggedInDetailsData.details[0].customerID.toString())));
  }

  void _onCartProductList(
      ProductCartResponseState state, BuildContext context) async {
    List<ProductCartModel> Tempgetproductlistfromdb123 =
        await OfflineDbHelper.getInstance().getProductCartList();

    if (Tempgetproductlistfromdb123.isNotEmpty) {
      //getproductlistfromdbMethod(state.cartDeleteResponse.details);

      /* getproductDetailsFromDB(
          state.cartDeleteResponse.details, Tempgetproductlistfromdb123);*/

      PushApiDatatodb(
          state.cartDeleteResponse.details, Tempgetproductlistfromdb123);

      //PushToCartDetailsToAPI(Tempgetproductlistfromdb123);
    } else {
      for (int i = 0; i < state.cartDeleteResponse.details.length; i++) {
        String name = state.cartDeleteResponse.details[i].productName;
        String Alias = state.cartDeleteResponse.details[i].productName;
        int ProductID = state.cartDeleteResponse.details[i].productID;
        int CustomerID = state.cartDeleteResponse.details[i].customerID;

        String Unit = state.cartDeleteResponse.details[i].unit;
        int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
        double Amount =
            state.cartDeleteResponse.details[i].unitPrice; //getTotalPrice();
        double DiscountPer =
            state.cartDeleteResponse.details[i].discountPercent;

        String ProductSpecification = "";
        String ProductImage = _offlineCompanyData.details[0].siteURL +
            "/productimages/" +
            state.cartDeleteResponse.details[i].productImage;
        //"http://122.169.111.101:206/productimages/no-figure.png";
        double Vat = state.cartDeleteResponse.details[i].Vat;

        ProductCartModel productCartModel = new ProductCartModel(
            name,
            Alias,
            ProductID,
            CustomerID,
            Unit,
            Amount,
            Qty,
            DiscountPer,
            _offlineLoggedInDetailsData.details[0].customerName
                .replaceAll(' ', ""),
            _offlineCompanyData.details[0].pkId.toString(),
            ProductSpecification,
            ProductImage,
            Vat);

        await OfflineDbHelper.getInstance()
            .insertProductToCart(productCartModel);
      }

      navigateTo(context, TabHomePage.routeName, clearAllStack: true);
    }
  }

  void _OnTaptoChangePassword() {
    navigateTo(context, ChangePasswordScreen.routeName, clearAllStack: true);
  }

  void _onDummyLoginSucessResponse(
      DummyLoginResponseState state, BuildContext context) {
    SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
    SharedPrefHelper.instance.setLoginUserData(state.loginResponse);
    _offlineLoggedInDetailsData = SharedPrefHelper.instance.getLoginUserData();
    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

  getproductlistfromdbMethod(
      List<ProductCartListResponseDetails> cartdetails) async {
    await getproductductdetails(cartdetails);
  }

  Future<void> getproductductdetails(
      List<ProductCartListResponseDetails> cartdetails123) async {
    // arrCartAPIList.clear();
    //List<ProductCartListResponseDetails> cartTempList = [];
    getproductlistfromdb.clear();
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    getproductlistfromdb.addAll(Tempgetproductlistfromdb);

    for (int i = 0; i < cartdetails123.length; i++) //2
    {
      for (int j = 0; j < getproductlistfromdb.length; j++) //5
      {
        if (cartdetails123[i].productID == getproductlistfromdb[j].ProductID) {
          print("Duplicaete" +
              "API Product = " +
              cartdetails123[i].productName +
              " Database Product : " +
              getproductlistfromdb[j].ProductName);

          ProductCartListResponseDetails productCartListResponseDetails =
              new ProductCartListResponseDetails();
          productCartListResponseDetails.pkID = cartdetails123[i].pkID;
          productCartListResponseDetails.customerID =
              cartdetails123[i].customerID;
          productCartListResponseDetails.productID =
              cartdetails123[i].productID;
          productCartListResponseDetails.productName =
              cartdetails123[i].productName;
          productCartListResponseDetails.unit = cartdetails123[i].unit;
          productCartListResponseDetails.quantity =
              cartdetails123[i].quantity + getproductlistfromdb[j].Quantity;
          productCartListResponseDetails.unitPrice =
              cartdetails123[i].unitPrice + getproductlistfromdb[j].UnitPrice;
          productCartListResponseDetails.discountPercent =
              cartdetails123[i].discountPercent;
          productCartListResponseDetails.productImage =
              cartdetails123[i].productImage;
          productCartListResponseDetails.productGroupName =
              cartdetails123[i].productGroupName;
          productCartListResponseDetails.productGroupImage =
              cartdetails123[i].productGroupImage;
          productCartListResponseDetails.brandName =
              cartdetails123[i].brandName;
          productCartListResponseDetails.brandImage =
              cartdetails123[i].brandImage;
          productCartListResponseDetails.Vat = cartdetails123[i].Vat;
          // cartTempList.add(productCartListResponseDetails);
          _editToDoItem(i, getproductlistfromdb[j].Quantity,
              getproductlistfromdb[j].UnitPrice, cartdetails123);
          /* await OfflineDbHelper.getInstance()
              .deleteContact(getproductlistfromdb[i].id);*/
        } /*else {
          ProductCartListResponseDetails productCartListResponseDetails =
              new ProductCartListResponseDetails();
          productCartListResponseDetails.pkID = cartdetails123[i].pkID;
          productCartListResponseDetails.customerID =
              cartdetails123[i].customerID;
          productCartListResponseDetails.productID =
              cartdetails123[i].productID;
          productCartListResponseDetails.productName =
              cartdetails123[i].productName;
          productCartListResponseDetails.unit = cartdetails123[i].unit;
          productCartListResponseDetails.quantity = cartdetails123[i].quantity;
          productCartListResponseDetails.unitPrice =
              cartdetails123[i].unitPrice;
          productCartListResponseDetails.discountPercent =
              cartdetails123[i].discountPercent;
          productCartListResponseDetails.productImage =
              cartdetails123[i].productImage;
          productCartListResponseDetails.productGroupName =
              cartdetails123[i].productGroupName;
          productCartListResponseDetails.productGroupImage =
              cartdetails123[i].productGroupImage;
          productCartListResponseDetails.brandName =
              cartdetails123[i].brandName;
          productCartListResponseDetails.brandImage =
              cartdetails123[i].brandImage;
          productCartListResponseDetails.Vat = cartdetails123[i].Vat;
          cartTempList.add(productCartListResponseDetails);
        }*/
      }
    }

    print("Testsdfi" + "Cart Product : " + cartdetails123.length.toString());
    // await OfflineDbHelper.getInstance().deleteContactTable();

    for (int i = 0; i < cartdetails123.length; i++) {
      print("FinalDetails" +
          " Product Name : " +
          cartdetails123[i].productName +
          " QTY : " +
          cartdetails123[i].quantity.toString());
      String name = cartdetails123[i].productName;
      String Alias = cartdetails123[i].productName;
      int ProductID = cartdetails123[i].productID;
      int CustomerID = cartdetails123[i].customerID;

      String Unit = cartdetails123[i].unit;
      int Qty = cartdetails123[i].quantity.toInt();
      double Amount = cartdetails123[i].unitPrice; //getTotalPrice();
      double DiscountPer = cartdetails123[i].discountPercent;

      String ProductSpecification = "";
      String ProductImage = _offlineCompanyData.details[0].siteURL +
          "/productimages/" +
          cartdetails123[i].productImage;
      //"http://122.169.111.101:206/productimages/no-figure.png";
      double Vat = cartdetails123[i].Vat;

      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          _offlineLoggedInDetailsData.details[0].customerName
              .replaceAll(' ', ""),
          _offlineCompanyData.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage,
          Vat);

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }
    getproductlistfromdb.clear();
    arrCartAPIList.clear();
    List<ProductCartModel> Tempgetproductlistfromdbg =
        await OfflineDbHelper.getInstance().getProductCartList();
    getproductlistfromdb.addAll(Tempgetproductlistfromdbg);

    //

    if (getproductlistfromdb.isNotEmpty) {
      _firstScreenBloc.add(CartDeleteRequestCallEvent(
          _offlineLoggedInDetailsData.details[0].customerID,
          CartDeleteRequest(
              CompanyID: _offlineCompanyData.details[0].pkId.toString())));

      for (int i = 0; i < getproductlistfromdb.length; i++) {
        CartModel cartModel = CartModel();
        cartModel.ProductName = getproductlistfromdb[i].ProductName;
        cartModel.ProductAlias = getproductlistfromdb[i].ProductAlias;
        cartModel.ProductID = getproductlistfromdb[i].ProductID;
        cartModel.CustomerID =
            _offlineLoggedInDetailsData.details[0].customerID;
        cartModel.Unit = getproductlistfromdb[i].Unit;
        cartModel.UnitPrice = getproductlistfromdb[i].UnitPrice;
        cartModel.Quantity = getproductlistfromdb[i].Quantity.toDouble();
        cartModel.DiscountPercent =
            getproductlistfromdb[i].DiscountPercent == null
                ? 0.00
                : getproductlistfromdb[i].DiscountPercent;
        cartModel.LoginUserID = getproductlistfromdb[i].LoginUserID;
        cartModel.CompanyId = _offlineCompanyData.details[0].pkId.toString();
        cartModel.ProductSpecification =
            getproductlistfromdb[i].ProductSpecification;
        cartModel.ProductImage = getproductlistfromdb[i].ProductImage;
        // "http://122.169.111.101:206/productimages/no-figure.png"; //getproductlistfromdb[i].ProductImage;

        arrCartAPIList.add(cartModel);
      }

      if (_offlineLoggedInDetailsData.details[0].customerName
              .trim()
              .toString() !=
          "dummy") {
        // await OfflineDbHelper.getInstance().deleteContactTable();

        for (int i = 0; i < arrCartAPIList.length; i++) {
          print("sdkhdfdf" +
              " Product Name : " +
              arrCartAPIList[i].ProductName +
              "QTY : " +
              arrCartAPIList[i].Quantity.toString());
        }
        _firstScreenBloc.add(InquiryProductSaveCallEvent(arrCartAPIList));
      }
    }

    setState(() {});
  }

  void _editToDoItem(int index, int Quantity, double UnitPrice,
      List<ProductCartListResponseDetails> cartTempList) {
    cartTempList[index].quantity = cartTempList[index].quantity + Quantity;
    cartTempList[index].unitPrice = cartTempList[index].unitPrice + UnitPrice;

    setState(() {});
  }

  void _OnSucessCartSaveResponse(InquiryProductSaveResponseState state) {
    // PushDetailstodb(arrCartAPIList, cartdetails123);
    _firstScreenBloc.add(LoginProductCartDetailsRequestCallEvent(
        ProductCartDetailsRequest(
            CompanyId: _offlineCompanyData.details[0].pkId.toString(),
            CustomerID:
                _offlineLoggedInDetailsData.details[0].customerID.toString())));
  }

  void _ONCartDeleteResponse(CartDeleteResponseState state) {
    print("Deleteerer" +
        "Delete MSG : " +
        state.cartDeleteResponse.details[0].column1);
  }

  void getproductDetailsFromDB(
      List<ProductCartListResponseDetails> cartdetails123,
      List<ProductCartModel> tempgetproductlistfromdb123) async {
    arrCartAPIList.clear();

    _firstScreenBloc.add(CartDeleteRequestCallEvent(
        _offlineLoggedInDetailsData.details[0].customerID,
        CartDeleteRequest(
            CompanyID: _offlineCompanyData.details[0].pkId.toString())));

    for (int i = 0; i < cartdetails123.length; i++) //2
    {
      for (int j = 0; j < tempgetproductlistfromdb123.length; j++) //5
      {
        if (cartdetails123[i].productID ==
            tempgetproductlistfromdb123[j].ProductID) {
          cartdetails123[i].quantity = cartdetails123[i].quantity +
              tempgetproductlistfromdb123[j].Quantity;
          cartdetails123[i].unitPrice = cartdetails123[i].unitPrice +
              tempgetproductlistfromdb123[j].UnitPrice;
          setState(() {});
        }
      }
    }

    for (int i = 0; i < cartdetails123.length; i++) {
      print("testddf" +
          "ProductName : " +
          cartdetails123[i].productName +
          "Quantity : " +
          cartdetails123[i].quantity.toString());

      CartModel cartModel = CartModel();
      cartModel.ProductName = cartdetails123[i].productName;
      cartModel.ProductAlias = "";
      cartModel.ProductID = cartdetails123[i].productID;
      cartModel.CustomerID = _offlineLoggedInDetailsData.details[0].customerID;
      cartModel.Unit = cartdetails123[i].unit;
      cartModel.UnitPrice = cartdetails123[i].unitPrice;
      cartModel.Quantity = cartdetails123[i].quantity.toDouble();
      cartModel.DiscountPercent = cartdetails123[i].discountPercent == null
          ? 0.00
          : cartdetails123[i].discountPercent;
      cartModel.LoginUserID = _offlineLoggedInDetailsData
          .details[0].customerName
          .replaceAll(' ', "");
      cartModel.CompanyId = _offlineCompanyData.details[0].pkId.toString();
      cartModel.ProductSpecification = "";
      cartModel.ProductImage = cartdetails123[i].productImage;
      // "http://122.169.111.101:206/productimages/no-figure.png"; //getproductlistfromdb[i].ProductImage;

      arrCartAPIList.add(cartModel);
    }

    if (_offlineLoggedInDetailsData.details[0].customerName.trim().toString() !=
        "dummy") {
      // await OfflineDbHelper.getInstance().deleteContactTable();

      for (int i = 0; i < arrCartAPIList.length; i++) {
        print("sdkhdfdf456" +
            " Product Name : " +
            arrCartAPIList[i].ProductName +
            "QTY : " +
            arrCartAPIList[i].Quantity.toString());
      }
      //PushDetailstodb(arrCartAPIList, cartdetails123);

      // await OfflineDbHelper.getInstance().deleteContactTable();
      _firstScreenBloc.add(InquiryProductSaveCallEvent(
        arrCartAPIList,
      ));
    }
  }

  void PushDetailstodb(List<CartModel> arrCartAPIList,
      List<ProductCartListResponseDetails> cartdetails123) async {
    for (int i = 0; i < arrCartAPIList.length; i++) {
      ProductCartModel productCartModel = new ProductCartModel(
          arrCartAPIList[i].ProductName,
          arrCartAPIList[i].ProductAlias,
          arrCartAPIList[i].ProductID,
          _offlineLoggedInDetailsData.details[0].customerID,
          arrCartAPIList[i].Unit,
          arrCartAPIList[i].UnitPrice,
          int.parse(arrCartAPIList[i].Quantity.toString()),
          arrCartAPIList[i].DiscountPercent,
          _offlineLoggedInDetailsData.details[0].customerName
              .replaceAll(' ', ""),
          _offlineCompanyData.details[0].pkId.toString(),
          "",
          arrCartAPIList[i].ProductImage,
          cartdetails123[i].Vat);

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }
  }

  void _OnLoginCartPUSHTODB(LoginProductCartResponseState state) async {
    await OfflineDbHelper.getInstance().deleteContactTable();
    for (int i = 0; i < state.cartDeleteResponse.details.length; i++) {
      print("TABDASHBOARD" +
          " Product Name : " +
          state.cartDeleteResponse.details[i].productName +
          "QTY : " +
          state.cartDeleteResponse.details[i].quantity.toString());

      String name = state.cartDeleteResponse.details[i].productName;
      String Alias = state.cartDeleteResponse.details[i].productName;
      int ProductID = state.cartDeleteResponse.details[i].productID;
      int CustomerID = state.cartDeleteResponse.details[i].customerID;

      String Unit = state.cartDeleteResponse.details[i].unit;
      int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
      double Amount =
          state.cartDeleteResponse.details[i].unitPrice; //getTotalPrice();
      double DiscountPer = state.cartDeleteResponse.details[i].discountPercent;

      String ProductSpecification = "";
      String ProductImage = _offlineCompanyData.details[0].siteURL +
          "/productimages/" +
          state.cartDeleteResponse.details[i].productImage;
      //"http://122.169.111.101:206/productimages/no-figure.png";
      double Vat = state.cartDeleteResponse.details[i].Vat;

      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          _offlineLoggedInDetailsData.details[0].customerName
              .replaceAll(' ', ""),
          _offlineCompanyData.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage,
          Vat);

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }
    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

  void PushToCartDetailsToAPI(List<ProductCartModel> cartdetails123) {
    for (int i = 0; i < cartdetails123.length; i++) {
      print("testddf" +
          "ProductName : " +
          cartdetails123[i].ProductName +
          "Quantity : " +
          cartdetails123[i].Quantity.toString());

      CartModel cartModel = CartModel();
      cartModel.ProductName = cartdetails123[i].ProductName;
      cartModel.ProductAlias = "";
      cartModel.ProductID = cartdetails123[i].ProductID;
      cartModel.CustomerID = _offlineLoggedInDetailsData.details[0].customerID;
      cartModel.Unit = cartdetails123[i].Unit;
      cartModel.UnitPrice = cartdetails123[i].UnitPrice;
      cartModel.Quantity = cartdetails123[i].Quantity.toDouble();
      cartModel.DiscountPercent = cartdetails123[i].DiscountPercent == null
          ? 0.00
          : cartdetails123[i].DiscountPercent;
      cartModel.LoginUserID = _offlineLoggedInDetailsData
          .details[0].customerName
          .replaceAll(' ', "");
      cartModel.CompanyId = _offlineCompanyData.details[0].pkId.toString();
      cartModel.ProductSpecification = "";
      cartModel.ProductImage = cartdetails123[i].ProductImage;
      // "http://122.169.111.101:206/productimages/no-figure.png"; //getproductlistfromdb[i].ProductImage;

      arrCartAPIList.add(cartModel);
      _firstScreenBloc.add(InquiryProductSaveCallEvent(arrCartAPIList));
    }
  }

  void PushApiDatatodb(List<ProductCartListResponseDetails> cartdetails123,
      List<ProductCartModel> tempgetproductlistfromdb123) async {
    for (int i = 0; i < cartdetails123.length; i++) //2
    {
      /* for (int j = 0; j < tempgetproductlistfromdb123.length; j++) //5
      {
        if (cartdetails123[i].productID ==
            tempgetproductlistfromdb123[j].ProductID) {
          double qty = cartdetails123[i].quantity +
              tempgetproductlistfromdb123[j].Quantity;

          double unitpriced = cartdetails123[i].unitPrice +
              tempgetproductlistfromdb123[j].UnitPrice;

            ProductCartModel productCartModel = new ProductCartModel(
              cartdetails123[i].productName,
              "",
              cartdetails123[i].productID,
              _offlineLoggedInDetailsData.details[0].customerID,
              cartdetails123[i].unit,
              unitpriced,
              qty.toInt(),
              cartdetails123[i].discountPercent,
              _offlineLoggedInDetailsData.details[0].customerName
                  .replaceAll(' ', ""),
              _offlineCompanyData.details[0].pkId.toString(),
              "",
              cartdetails123[i].productImage,
              cartdetails123[i].Vat,
              id: tempgetproductlistfromdb123[j].id);

          await OfflineDbHelper.getInstance().updateContact(productCartModel);


        } else {
          ProductCartModel productCartModel = new ProductCartModel(
            cartdetails123[i].productName,
            "",
            cartdetails123[i].productID,
            _offlineLoggedInDetailsData.details[0].customerID,
            cartdetails123[i].unit,
            cartdetails123[i].unitPrice,
            cartdetails123[i].quantity.toInt(),
            cartdetails123[i].discountPercent,
            _offlineLoggedInDetailsData.details[0].customerName
                .replaceAll(' ', ""),
            _offlineCompanyData.details[0].pkId.toString(),
            "",
            cartdetails123[i].productImage,
            cartdetails123[i].Vat,
          );

          await OfflineDbHelper.getInstance()
              .insertProductToCart(productCartModel);
        }
      }*/

      ProductCartModel productCartModel = new ProductCartModel(
        cartdetails123[i].productName,
        "",
        cartdetails123[i].productID,
        _offlineLoggedInDetailsData.details[0].customerID,
        cartdetails123[i].unit,
        cartdetails123[i].unitPrice,
        cartdetails123[i].quantity.toInt(),
        cartdetails123[i].discountPercent,
        _offlineLoggedInDetailsData.details[0].customerName.replaceAll(' ', ""),
        _offlineCompanyData.details[0].pkId.toString(),
        "",
        _offlineCompanyData.details[0].siteURL +
            "/productimages/" +
            cartdetails123[i].productImage,
        cartdetails123[i].Vat,
      );

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }

    List<ProductCartModel> Tempgetproductlistfromdb123 =
        await OfflineDbHelper.getInstance().updateduplicate();

    await OfflineDbHelper.getInstance().deleteContactTable();

    for (int i = 0; i < Tempgetproductlistfromdb123.length; i++) {
      var remove =
          Tempgetproductlistfromdb123[i].ProductImage.toString().split("/");

      for (int k = 0; k < remove.length; k++) {
        print("sljdf" + "Image : " + remove[k].toString());
      }

      print("dsjjdjf" +
          "ProductID  : " +
          Tempgetproductlistfromdb123[i].ProductID.toString() +
          " UnitPrice " +
          Tempgetproductlistfromdb123[i].UnitPrice.toString() +
          " QTY " +
          Tempgetproductlistfromdb123[i].Quantity.toString() +
          " ProductImage " +
          Tempgetproductlistfromdb123[i].ProductImage.toString() +
          " Customer ID " +
          Tempgetproductlistfromdb123[i].CustomerID.toString());

      ProductCartModel productCartModel = new ProductCartModel(
        Tempgetproductlistfromdb123[i].ProductName,
        "",
        Tempgetproductlistfromdb123[i].ProductID,
        _offlineLoggedInDetailsData.details[0].customerID,
        Tempgetproductlistfromdb123[i].Unit,
        Tempgetproductlistfromdb123[i].UnitPrice,
        Tempgetproductlistfromdb123[i].Quantity.toInt(),
        Tempgetproductlistfromdb123[i].DiscountPercent,
        _offlineLoggedInDetailsData.details[0].customerName.replaceAll(' ', ""),
        _offlineCompanyData.details[0].pkId.toString(),
        "",
        Tempgetproductlistfromdb123[i].ProductImage,
        Tempgetproductlistfromdb123[i].vat,
      );

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }

    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

/*sumofsomevalue(SendPort sendPort) {
  int sum = 0;

  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }

  sendPort.send(sum);
}*/
}
