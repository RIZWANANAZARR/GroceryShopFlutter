import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Token/token_Save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Profile/profile_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/push_notification_service.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin_order/order_list/order_customer_list_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/dashboard/navigator_item.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/push_notification_model.dart';
import 'package:grocery_app/screens/tabview_dashboard/Smart_Customer_Screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_product_details_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class TabHomePage extends BaseStatefulWidget {
  static const routeName = '/TabHomePage';

  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends BaseState<TabHomePage>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<String> data = [];
  List<String> Subdata = [];
  List<ALL_NAME_ID> Subdata1 = [];

  List<ALL_NAME_ID> data1 = [];

  int initPosition = 0;
  CategoryScreenBloc _categoryScreenBloc;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  List<GroceryItem> BestSellingProducts = [];
  PushNotificationService pushNotificationService = PushNotificationService();
  String token123 = "";

  FirebaseMessaging _messaging;

  List<NavigatorItem> navigatorItems123 = [];

  final TextEditingController edt_CustomerName = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('sk_logo');

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message Id - onMessage ${message.messageId}");
      if (Globals.objectedNotifications.contains(message.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(message.messageId);

      PushNotification pushNotification = new PushNotification(
          title: message.notification.title,
          body: message.notification.body,
          dataTitle: message.data['title'],
          databody: message.data['body']);

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails('id', 'channel ',
              priority: Priority.high, importance: Importance.max);

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidDetails);

      flutterLocalNotificationsPlugin.show(
          12345,
          "A Notification From My Application",
          "This notification was sent using Flutter Local Notifcations Package",
          platformChannelSpecifics,
          payload: 'data');

      showCommonDialogWithSingleOption(
          context,
          "Body : " +
              pushNotification.body +
              "\n Title : " +
              pushNotification.title,
          positiveButtonTitle: "OK",
          onTapOfPositiveButton: () {});
      // LocalNotifications(title: 'Flutter Local Notification Sample');

      setState(() {});
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!' +
          message.notification.title);
      print("message Id - onMessageOpenedApp ${message.messageId}");
      if (Globals.objectedNotifications.contains(message.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(message.messageId);
      if (message.data['title'] == "Inquiry") {
        // navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
        print("MessagePush" + "Inquiry123");
      } else if (message.data['title'] == "Followup") {
        print("MessagePush" + "Followup123");
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Grant the Permission");
    } else {
      print("Permission Decline By User");
    }
  }

  checkIntialMessage() async {
    RemoteMessage intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (intialMessage != null) {
      print("message Id - intialMessage ${intialMessage.messageId}");
      if (Globals.objectedNotifications.contains(intialMessage.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(intialMessage.messageId);

      /* PushNotification notification = PushNotification(
        title: intialMessage.notification!.title,
        body: intialMessage.notification!.body,
        dataTitle: intialMessage.data['title'],
        databody: intialMessage.data['body']
    );*/

      if (intialMessage.data['title'] == "Inquiry") {
        //navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
        print("MessagePush" + "Inquiry7up");
      } else if (intialMessage.data['title'] == "Followup") {
        // navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);

        print("MessagePush" + "Followup7up");
      }
    }
  }

  String TokenFinal = "";
  ProfileListResponseDetails _searchInquiryListResponse;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();

    pushNotificationService.setupInteractedMessage();
    pushNotificationService.enableIOSNotifications();
    pushNotificationService.registerNotificationListeners();
    pushNotificationService.getToken();

    //normal Notification
    registerNotification();
    //When App is in Terminated
    checkIntialMessage();

    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    _categoryScreenBloc = CategoryScreenBloc(baseBloc);
    _categoryScreenBloc.add(ProductBrandCallEvent(ProductBrandListRequest(
        SearchKey: "",
        ActiveFlag: "1",
        CompanyId: CompanyID,
        LoginUserID: LoginUserID)));
    edt_CustomerName.text = "";
    /* */

    getNavigationList(_offlineLogindetails.details[0].customerType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is ProductBrandResponseState) {
            _onBrandResponse(state, context);
          }
          if (state is TokenSaveResponseState) {
            _OnTokenSaveSucess(state, context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductBrandResponseState ||
              currentState is TokenSaveResponseState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          if (state is LoginResponseState) {
            _onLoginSucessResponse(state, context);
          }

          if (state is ProductFavoriteResponseState) {
            _onFavoriteProductList(state, context);
          }
          if (state is ProductCartResponseState) {
            _onCartProductList(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoginResponseState ||
              currentState is ProductFavoriteResponseState ||
              currentState is ProductCartResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                _categoryScreenBloc.add(ProductBrandCallEvent(
                    ProductBrandListRequest(
                        SearchKey: "",
                        ActiveFlag: "1",
                        CompanyId: CompanyID,
                        LoginUserID: LoginUserID)));
              },
              child: CustomTabView(
                initPosition: initPosition,
                itemCount: data1.length,
                tabBuilder: (context, index) => Tab(text: data1[index].Name),
                pageBuilder: (context, index) => TabProductPage(
                    AddTabProductScreenArguments(data1[index].id.toString())),
                onPositionChange: (index) {
                  print('current position: Brand ID : ' + data1[index].id);
                  initPosition = index;
                },
                onScroll: (position) => print('$position'),
              ))),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black38.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 37,
                offset: Offset(0, -12)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) {
                navigateTo(context, TabHomePage.routeName, clearAllStack: true);
              } else if (index == 1) {
                navigateTo(context, ExploreDashBoardScreen.routeName,
                    clearAllStack: true);
              } else if (index == 2) {
                navigateTo(context, DynamicCartScreen.routeName,
                    clearAllStack: true);
              } else if (index == 3) {
                navigateTo(context, FavoriteItemsScreen.routeName,
                    clearAllStack: true);
              } else if (index == 4) {
                if (_offlineLogindetails.details[0].customerType !=
                    "customer") {
                  navigateTo(context, OrderCustomerList.routeName,
                      clearAllStack: true);
                } else {
                  navigateTo(context, AccountScreen.routeName,
                      clearAllStack: true);
                }
              } else if (index == 5) {
                /*navigateTo(context, OrderCustomerList.routeName,
                    clearAllStack: true);*/
                navigateTo(context, AccountScreen.routeName,
                    clearAllStack: true);
              }
              print("SelectedIndex" + _selectedIndex.toString());
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryColor,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedItemColor: Colors.black,
            items: navigatorItems123.map((e) {
              return getNavigationBarItem(
                  label: e.label, index: e.index, iconPath: e.iconPath);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton:
          _offlineLogindetails.details[0].customerType != "customer"
              ? FloatingActionButton(
                  child: InkWell(
                      onTap: () {
                        //_buildSearchView();
                        _onTapOfSearchView();
                      },
                      child: Icon(Icons.people_alt)),
                )
              : Container(),
    );
  }

  BottomNavigationBarItem getNavigationBarItem(
      {String label, String iconPath, int index}) {
    Color iconColor =
        index == _selectedIndex ? AppColors.primaryColor : Colors.black;

    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        iconPath,
        color: iconColor,
      ),
      // activeIcon: badge
    );
  }

  void _onBrandResponse(ProductBrandResponseState state, BuildContext context) {
    data.clear();
    data1.clear();
    BestSellingProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      data.add(state.response.details[i].brandName);
      ALL_NAME_ID all_name_id = ALL_NAME_ID();
      all_name_id.Name = state.response.details[i].brandName;
      all_name_id.id = state.response.details[i].pkID.toString();
      data1.add(all_name_id);
    }
    getTokenString();
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  void _OnTokenSaveSucess(TokenSaveResponseState state, BuildContext context) {
    print("TokenFromAPI" + state.response.details[0].column2.toString());
  }

  getTokenString() async {
    TokenFinal = await FirebaseMessaging.instance.getToken();

    print("getToken" + TokenFinal);

    _categoryScreenBloc.add(TokenSaveApiRequestCallEvent(TokenSaveApiRequest(
        CompanyId: CompanyID,
        LoginUserID: LoginUserID,
        CustomerID: CustomerID,
        DeviceID: "",
        TokenNo: TokenFinal,
        pkID: "0")));
  }

  void _onTapOfSearchView() {
    navigateTo(context, SearchSmartCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchInquiryListResponse = value;
        edt_CustomerName.text = _searchInquiryListResponse.customerName;
        print("CustomerDetails" +
            "CustomerName : " +
            _searchInquiryListResponse.customerName);

        showCommonDialogWithTwoOptions(
          context,
          "Are you sure you want to switch to " +
              _searchInquiryListResponse.customerName +
              " account?",
          negativeButtonTitle: "No",
          positiveButtonTitle: "Yes",
          onTapOfPositiveButton: () {
            Navigator.pop(context);
            _categoryScreenBloc.add(LoginRequestCallEvent(LoginRequest(
                EmailAddress: _searchInquiryListResponse.emailAddress,
                Password: _searchInquiryListResponse.password,
                CompanyId: CompanyID.toString())));
          },
        );
        //Accounts has been switched.

        /* _inquiryBloc.add(SearchInquiryListByNameCallEvent(
              SearchInquiryListByNameRequest(word:  edt_CustomerName.text,CompanyId:CompanyID.toString(),LoginUserID: LoginUserID,needALL: "1")));
*/
        //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));

      }
    });
  }

  void _onLoginSucessResponse(LoginResponseState state, BuildContext context) {
    print("LoginSucess" + state.loginResponse.details[0].emailAddress);
    String EmpName = state.loginResponse.details[0].customerName;
    if (EmpName != "") {
      SharedPrefHelper.instance
          .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
      SharedPrefHelper.instance.setLoginUserData(state.loginResponse);
      _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
      _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
      // print("LoginAuthenticateSucess123" + "CompanyID : " + _offlineCompanyData.details[0].pkId.toString() +"LoginUserID : "+_offlineLoggedInDetailsData.details[0].userID);

      _categoryScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(
          ProductCartDetailsRequest(
              CompanyId: _offlineCompanydetails.details[0].pkId.toString(),
              CustomerID:
                  state.loginResponse.details[0].customerID.toString())));

      // navigateTo(context, DashboardScreen.routeName, clearAllStack: true);

    }
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
      String ProductImage = _offlineCompanydetails.details[0].siteURL +
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
          _offlineLogindetails.details[0].customerName.replaceAll(' ', ""),
          _offlineCompanydetails.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage,
          Vat);

      await OfflineDbHelper.getInstance()
          .insertProductToCartFavorit(productCartModel);
    }

    _categoryScreenBloc.add(ProductCartDetailsRequestCallEvent(
        ProductCartDetailsRequest(
            CompanyId: _offlineCompanydetails.details[0].pkId.toString(),
            CustomerID:
                _offlineLogindetails.details[0].customerID.toString())));
  }

  void _onCartProductList(
      ProductCartResponseState state, BuildContext context) async {
    await OfflineDbHelper.getInstance().deleteContactTable();
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
      String ProductImage = _offlineCompanydetails.details[0].siteURL +
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
          _offlineLogindetails.details[0].customerName.replaceAll(' ', ""),
          _offlineCompanydetails.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage,
          Vat);

      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }

    commonalertbox(
        _offlineLogindetails.details[0].customerName +
            " Accounts has been switched.", onTapofPositive: () {
      // Navigator.pop(context);
      navigateTo(context, TabHomePage.routeName, clearSingleStack: true);
    });
    // navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
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

  void getNavigationList(String CustomerType) {
    navigatorItems123.clear();
    List<NavigatorItem> navigatorItems12 = [];

    if (CustomerType != "customer") {
      navigatorItems12 = [
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, HomeScreen()),
        NavigatorItem("Explore", "assets/icons/explore_icon.svg", 1,
            ExploreDashBoardScreen()),
        NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
            /*CartScreen()*/ DynamicCartScreen()),
        NavigatorItem("Favourite", "assets/icons/favourite_icon.svg", 3,
            FavoriteItemsScreen()),
        NavigatorItem("Order", "assets/icons/account_icons/orders_icon.svg", 4,
            OrderCustomerList()),
        NavigatorItem(
            "Account", "assets/icons/account_icon.svg", 5, AccountScreen()),
      ];
    } else {
      navigatorItems12 = [
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, HomeScreen()),
        NavigatorItem("Explore", "assets/icons/explore_icon.svg", 1,
            ExploreDashBoardScreen()),
        NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
            /*CartScreen()*/ DynamicCartScreen()),
        NavigatorItem("Favourite", "assets/icons/favourite_icon.svg", 3,
            FavoriteItemsScreen()),
        NavigatorItem(
            "Account", "assets/icons/account_icon.svg", 4, AccountScreen()),
      ];
    }

    navigatorItems123.addAll(navigatorItems12);
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    this.itemCount,
    this.tabBuilder,
    this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  TabController controller2;

  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            decoration: BoxDecoration(color: Getirblue),
            alignment: Alignment.center,
            child: Column(
              children: [
                TabBar(
                  /*indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),*/
                  //labelColor: Getirblue,
                  //unselectedLabelColor: Colors.white,
                  isScrollable: true,
                  controller: controller,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),

                  unselectedLabelColor: Colors.white70,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: GetirYellow,
                        width: 3,
                      ),
                    ),
                  ),
                  tabs: List.generate(
                    widget.itemCount,
                    (index) => widget.tabBuilder(context, index),
                  ),
                ),
              ],
            )),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}
