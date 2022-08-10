import 'dart:io' show Platform, exit;

import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_group_list_request.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_from_brandID_groupID_request.dart';
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
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/push_notification_model.dart';
import 'package:grocery_app/screens/tabview_dashboard/Smart_Customer_Screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/only_product_details.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_product_card_view.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

class ShopDashBoard extends BaseStatefulWidget {
  static const routeName = '/ShopDashBoard';
  static int counter = 0;

  @override
  _ShopDashBoardState createState() => _ShopDashBoardState();
}

class _ShopDashBoardState extends BaseState<ShopDashBoard>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<String> Groupdata = [];
  List<ALL_NAME_ID> Groupdata1 = [];
  List<Tab> _Grouptabs = [];

  List<String> data = [];
  List<String> Subdata = [];
  List<ALL_NAME_ID> Subdata1 = [];

  List<ALL_NAME_ID> data1 = [];

  int initPosition = 0;
  int initPositionGroup = 0;

  CategoryScreenBloc _categoryScreenBloc;
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  List<GroceryItem> BestSellingProducts = [];
  PushNotificationService pushNotificationService = PushNotificationService();
  String token123 = "";
  int cartCount = 0;
  String notifyText = "";

  FirebaseMessaging _messaging;

  List<NavigatorItem> navigatorItems123 = [];

  final TextEditingController edt_CustomerName = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

      if (intialMessage.data['title'] == "Inquiry") {
        //navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
        print("MessagePush" + "Inquiry7up");
      } else if (intialMessage.data['title'] == "Followup") {
        print("MessagePush" + "Followup7up");
      }
    }
  }

  String TokenFinal = "";
  ProfileListResponseDetails _searchInquiryListResponse;
  var provider;

  GroceryItem groceryItem = GroceryItem();

  List<GroceryItem> AllProducts = [];

  final Color borderColor = Color(0xffE2E2E2);
  bool isAdd = false;

  bool isopendilaog = false;
  PersistentBottomSheetController _bottomsheetcontroller; // instance variable
  BuildContext bootomsheetContext;
  int amount = 1;
  TextEditingController _amount = TextEditingController();
  FToast fToast;
  bool isProductinCart = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fToast = FToast();
    fToast.init(context);
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

    getproductlistfromdbMethod();
    print("djjdkjf" + " Counter : " + ShopDashBoard.counter.toString());

    getNavigationList(_offlineLogindetails.details[0].customerType);

    getGrocery();
  }

  @override
  void dispose() {
    super.dispose();
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
          if (state is TabProductGroupListResponseState) {
            OnTabGROUPResponse(state, context);
          }
          if (state is TabProductListResponseState) {
            OnTabProductResponse(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoginResponseState ||
              currentState is ProductFavoriteResponseState ||
              currentState is ProductCartResponseState ||
              currentState is TabProductGroupListResponseState ||
              currentState is TabProductListResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Scaffold(
        /* appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.all(10),
            child: Badge(
              badgeContent: Text(cartCount.toString()),
              child: SvgPicture.asset(
                "assets/icons/cart_icon.svg",
                color: AppColors.primaryColor,
                width: 42,
                height: 42,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),*/
        body: Container(
            child: StatefulBuilder(builder: (ctx, StateSetter setState) {
          return SafeArea(
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
                    tabBuilder: (context, index) =>
                        Tab(text: data1[index].Name),
                    pageBuilder: (context, index) {
                      /// Group Tab Screen
                      _categoryScreenBloc.add(TabProductGroupListCallEvent(
                          TabProductGroupListRequest(
                              SearchKey: "",
                              ActiveFlag: "1",
                              CompanyId: CompanyID,
                              BrandID: data1[index].id)));
                      return Groupdata1.isNotEmpty
                          ? Scaffold(
                              backgroundColor: Colors.white,
                              body: SafeArea(
                                  child: Groupdata1.isNotEmpty
                                      ? CustomTabGroupView(
                                          initPosition: initPositionGroup,
                                          itemCount: Groupdata1.length,
                                          tabBuilder: (context, index1) => Tab(
                                              text: Groupdata1[index1].Name),
                                          pageBuilder: (context, index1) {
                                            _categoryScreenBloc.add(
                                                TabProductListBrandIDGroupIDRequestEvent(
                                                    TabProductListBrandIDGroupIDRequest(
                                                        BrandID:
                                                            Groupdata1[index1]
                                                                .id,
                                                        GroupID:
                                                            data1[index].id,
                                                        ActiveFlag: "1",
                                                        CompanyId: CompanyID
                                                            .toString())));

                                            return AllProducts.isNotEmpty
                                                ? Scaffold(
                                                    backgroundColor:
                                                        Colors.white,
                                                    body: AllProducts.isNotEmpty
                                                        ? StaggeredGridView
                                                            .count(
                                                            crossAxisCount: 6,
                                                            // I only need two card horizontally
                                                            children: AllProducts
                                                                    .asMap()
                                                                .entries
                                                                .map<Widget>(
                                                                    (e) {
                                                              GroceryItem
                                                                  groceryItem =
                                                                  e.value;
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  //onItemClicked(context, groceryItem);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  /*child: TabProductItemCardWidget(
                                                                      itemm:
                                                                          groceryItem,
                                                                      ProductGroupID:
                                                                          Groupdata1[index1]
                                                                              .id),*/
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Center(
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              if (SharedPrefHelper.instance.getBool("opendialog") == false) {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => ProductDetailsScreen(groceryItem)),
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              height: 100,
                                                                              width: 100,
                                                                              padding: EdgeInsets.all(2),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(
                                                                                  color: borderColor,
                                                                                ),
                                                                              ),
                                                                              child: Image.network(
                                                                                groceryItem.ProductImage,
                                                                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                                  return child;
                                                                                },
                                                                                loadingBuilder: (context, child, loadingProgress) {
                                                                                  if (loadingProgress == null) {
                                                                                    return child;
                                                                                  } else {
                                                                                    return CircularProgressIndicator();
                                                                                  }
                                                                                },
                                                                                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                                                                  return Image.asset(NO_IMAGE_FOUND);
                                                                                },
                                                                              ),
                                                                            )), //imageWidget()),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      AppText(
                                                                        text: groceryItem.ProductName
                                                                            .toUpperCase(),
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      AppText(
                                                                        text:
                                                                            "Price \£${groceryItem.UnitPrice.toStringAsFixed(2)}",
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                isAdd = true;
                                                                                isopendilaog = true;
                                                                                SharedPrefHelper.instance.putBool("opendialog", true);

                                                                                _bottomsheetcontroller = showBottomSheet(
                                                                                    context: context,
                                                                                    builder: (BuildContext bc) {
                                                                                      bootomsheetContext = bc;
                                                                                      return SafeArea(
                                                                                        child: Container(
                                                                                          decoration: new BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          height: 300,
                                                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                                                          child: SingleChildScrollView(
                                                                                            child: Container(
                                                                                              decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20.0), gradient: LinearGradient(colors: [cardgredient1, cardgredient2])),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  //getImageHeaderWidget(),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(left: 15, right: 15),
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        ListTile(
                                                                                                          contentPadding: EdgeInsets.zero,
                                                                                                          title: AppText(
                                                                                                            text: groceryItem.ProductName,
                                                                                                            fontSize: 15,
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            color: Getirblue,
                                                                                                          ),
                                                                                                          trailing: InkWell(
                                                                                                              onTap: () {
                                                                                                                SharedPrefHelper.instance.putBool("opendialog", false);
                                                                                                                Navigator.pop(context);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                height: 40,
                                                                                                                width: 100,
                                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primaryColor),
                                                                                                                child: Center(
                                                                                                                  child: Text(
                                                                                                                    "Close",
                                                                                                                    style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )),
                                                                                                          subtitle: AppText(
                                                                                                            text: groceryItem.ProductSpecification,
                                                                                                            fontSize: 10,
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            color: Getirblue,
                                                                                                          ),
                                                                                                        ),
                                                                                                        // Spacer(),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            ItemCounterWidgetForCart(
                                                                                                              onAmountChanged: (newAmount) async {
                                                                                                                setState(() {
                                                                                                                  amount = newAmount;
                                                                                                                  print("asjksdh" + " Amount : " + amount.toString());
                                                                                                                  getTotalPrice(groceryItem).toStringAsFixed(2);
                                                                                                                });
                                                                                                              },
                                                                                                              amount: amount,
                                                                                                            ),
                                                                                                            // Spacer(),
                                                                                                            SizedBox(
                                                                                                              width: 20,
                                                                                                            ),

                                                                                                            Expanded(
                                                                                                              child: TextField(
                                                                                                                enabled: false,
                                                                                                                controller: _amount,
                                                                                                                textInputAction: TextInputAction.next,
                                                                                                                keyboardType: TextInputType.text,
                                                                                                                decoration: InputDecoration(
                                                                                                                  labelStyle: TextStyle(
                                                                                                                    color: Getirblue,
                                                                                                                  ),
                                                                                                                  border: InputBorder.none,
                                                                                                                ),
                                                                                                                style: TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  color: Getirblue,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        //Spacer(),
                                                                                                        Divider(thickness: 1),
                                                                                                        getProductDataRowWidget("Product Details", groceryItem),
                                                                                                        Divider(thickness: 1),
                                                                                                        getProductDataRowWidget("Unit", groceryItem, customWidget: nutritionWidget(groceryItem)),

                                                                                                        Divider(thickness: 1),
                                                                                                        SizedBox(
                                                                                                          height: 5,
                                                                                                        ),

                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                                                                                          children: [
                                                                                                            GestureDetector(
                                                                                                              onTap: () {
                                                                                                                SharedPrefHelper.instance.putBool("opendialog", false);
                                                                                                                _OnTaptoAddProductinCart(groceryItem);
                                                                                                              },
                                                                                                              child: Center(
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: 100,
                                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primaryColor),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      "Add to Cart",
                                                                                                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              width: 20,
                                                                                                            ),
                                                                                                            GestureDetector(
                                                                                                              onTap: () {
                                                                                                                _OnTaptoAddProductinCartFavorit(groceryItem);
                                                                                                              },
                                                                                                              child: Center(
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: 100,
                                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primaryColor),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      "Add to Favorite",
                                                                                                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),

                                                                                                        SizedBox(
                                                                                                          height: 20,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 32,
                                                                              width: 100,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primaryColor),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  //isProductinCart == true ? "View" : "Add",
                                                                                  "Add",
                                                                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            staggeredTiles: AllProducts.map<
                                                                    StaggeredTile>(
                                                                (_) => StaggeredTile
                                                                    .fit(
                                                                        2)).toList(),
                                                            mainAxisSpacing:
                                                                3.0,
                                                            crossAxisSpacing:
                                                                0.0, // add some space
                                                          )
                                                        : Center(
                                                            child: Image.asset(
                                                              NO_DASHBOARD,
                                                              width: 250,
                                                            ),
                                                          ))
                                                : Center(
                                                    child: Image.asset(
                                                    NO_DASHBOARD,
                                                    height: 200,
                                                    width: 200,
                                                  ));
                                          },
                                          /* TabProductItemsScreen(
                                      AddTabProductItemsScreenArguments(
                                          Groupdata1[index].id.toString(), _ProductGroupID)),*/
                                          onPositionChange: (index) {
                                            print(
                                                'current position: Brand ID : ' +
                                                    Groupdata1[index].id);

                                            initPositionGroup = index;
                                          },
                                          onScroll: (position) =>
                                              print('$position'),
                                        )
                                      : Center(
                                          child: Image.asset(
                                            NO_DASHBOARD,
                                            width: 250,
                                          ),
                                        )),
                            )
                          : Center(
                              child: Image.asset(
                                NO_DASHBOARD,
                                width: 250,
                              ),
                            );
                    },
                    onPositionChange: (index) {
                      print('current position: Brand ID : ' + data1[index].id);
                      initPosition = index;
                    },
                    onScroll: (position) => print('$position'),
                  )));
        })),
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
                  navigateTo(context, ShopDashBoard.routeName,
                      clearAllStack: true);
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
                //  provider.counter = cartCount;

                return getNavigationBarItem(
                    label: e.label,
                    index: e.index,
                    iconPath: e.iconPath,
                    count: cartCount,
                    provif: provider);
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
                : Container(
                    child: Visibility(
                      visible: false,
                      child: TabProductItemCardWidget(
                        itemm: groceryItem,
                        ProductGroupID: "1",
                        voidCallback: () {
                          setState(() {
                            return cartCount++;
                          });
                        },
                      ),
                    ),
                  ),
      ),
    );
  }

  BottomNavigationBarItem getNavigationBarItem(
      {String label, String iconPath, int index, int count, var provif}) {
    Color iconColor =
        index == _selectedIndex ? AppColors.primaryColor : Colors.black;
    provif = count;
    return BottomNavigationBarItem(
      label: label,
      icon: label == "Cart"
          ? Badge(
              badgeContent: Text(count.toString()),
              child: SvgPicture.asset(
                iconPath,
                color: Colors.green,
              ),
            )
          : SvgPicture.asset(
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

      _categoryScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(
          ProductCartDetailsRequest(
              CompanyId: _offlineCompanydetails.details[0].pkId.toString(),
              CustomerID:
                  state.loginResponse.details[0].customerID.toString())));
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
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, ShopDashBoard()),
        NavigatorItem("Explore", "assets/icons/explore_icon.svg", 1,
            ExploreDashBoardScreen()),
        NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
            /*CartScreen()*/ DynamicCartScreen(),
            count: 2),
        NavigatorItem("Favourite", "assets/icons/favourite_icon.svg", 3,
            FavoriteItemsScreen()),
        NavigatorItem("Order", "assets/icons/account_icons/orders_icon.svg", 4,
            OrderCustomerList()),
        NavigatorItem(
            "Account", "assets/icons/account_icon.svg", 5, AccountScreen()),
      ];
    } else {
      navigatorItems12 = [
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, ShopDashBoard()),
        NavigatorItem("Explore", "assets/icons/explore_icon.svg", 1,
            ExploreDashBoardScreen()),
        NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
            /*CartScreen()*/ DynamicCartScreen(),
            count: cartCount),
        NavigatorItem("Favourite", "assets/icons/favourite_icon.svg", 3,
            FavoriteItemsScreen()),
        NavigatorItem(
            "Account", "assets/icons/account_icon.svg", 4, AccountScreen()),
      ];
    }

    navigatorItems123.addAll(navigatorItems12);
  }

  Future<bool> _onBackpress() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    return Future.value(false);
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();
  }

  Future<void> getproductductdetails() async {
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    cartCount = Tempgetproductlistfromdb.length;
  }

  void getGrocery() {
    groceryItem.ProductName = "dummy";
    groceryItem.ProductID = 1;
    groceryItem.ProductAlias = "test";
    groceryItem.CustomerID = 1;
    groceryItem.Unit = "KG";
    groceryItem.UnitPrice = 1.00;
    groceryItem.Quantity = 0.00;
    groceryItem.DiscountPer = 1.0;
    groceryItem.LoginUserID = LoginUserID;
    groceryItem.ComapanyID = CompanyID;
    groceryItem.ProductSpecification = "djkfjd";
    groceryItem.ProductImage = "";
    groceryItem.Vat = 0.00;
  }

  void OnTabGROUPResponse(
      TabProductGroupListResponseState state, BuildContext context) {
    Groupdata.clear();
    Groupdata1.clear();
    _Grouptabs.clear();
    //BestSellingProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      Groupdata.add(state.response.details[i].productGroupName);

      _Grouptabs.add(
          Tab(child: Text(state.response.details[i].productGroupName)));

      ALL_NAME_ID all_name_id = ALL_NAME_ID();
      all_name_id.Name = state.response.details[i].productGroupName;
      all_name_id.id = state.response.details[i].productGroupID.toString();
      Groupdata1.add(all_name_id);
    }
  }

  void OnTabProductResponse(
      TabProductListResponseState state, BuildContext context) {
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      print("CategoryProduct" + state.response.details[i].productName);
      /*GroceryItem groceryItem = GroceryItem();
      groceryItem.name = state.response.details[i].productName;
      groceryItem.price = state.response.details[i].unitPrice;
      groceryItem.description = "";
      groceryItem.Nutritions = state.response.details[i].unit;
      groceryItem.imagePath = state.response.details[i].productImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productImage;
     */

      GroceryItem groceryItem = GroceryItem();
      groceryItem.ProductName = state.response.details[i].productName;
      groceryItem.ProductID = state.response.details[i].pkID;
      groceryItem.ProductAlias = state.response.details[i].productName;
      groceryItem.CustomerID = 1;
      groceryItem.Unit = state.response.details[i].unit;
      groceryItem.UnitPrice = state.response.details[i].unitPrice.toDouble();
      groceryItem.Quantity = 0.00;
      groceryItem.DiscountPer = state.response.details[i].discountPercent;
      groceryItem.LoginUserID = LoginUserID;
      groceryItem.ComapanyID = CompanyID;
      groceryItem.ProductSpecification =
          state.response.details[i].productSpecification;
      groceryItem.ProductImage = state.response.details[i].productImage == ""
          ? ""
          : _offlineCompanydetails.details[0].siteURL +
              "/productimages/" +
              state.response.details[i].productImage;
      groceryItem.Vat = state.response.details[i].vat;

      AllProducts.add(groceryItem);
    }
  }

  double getTotalPrice(GroceryItem groceryItem) {
    var tot = amount * groceryItem.UnitPrice;
    print("sfjklfj" + tot.toString() + "Amount : " + amount.toString());
    _amount.text = "\£" + tot.toString();
    return amount * groceryItem.UnitPrice;
  }

  Widget getProductDataRowWidget(String label, GroceryItem groceryItem,
      {Widget customWidget}) {
    return InkWell(
      onTap: () {
        if (label == "Product Details") {
          groceryItem.Quantity = amount.toDouble();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen2(groceryItem)),
          );
        } else {
          showCommonDialogWithSingleOption(
              context,
              "Product : " +
                  groceryItem.ProductName +
                  "\n" +
                  "Product Specification : " +
                  groceryItem.ProductSpecification +
                  "\n" +
                  "Price : " +
                  groceryItem.UnitPrice.toString() +
                  " Unit : " +
                  groceryItem.Unit,
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Row(
          children: [
            AppText(
              text: label,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: Getirblue,
            ),
            Spacer(),
            if (customWidget != null) ...[
              customWidget,
              SizedBox(
                width: 20,
              )
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Getirblue,
            )
          ],
        ),
      ),
    );
  }

  Widget nutritionWidget(GroceryItem groceryItem) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 25,
      height: 20,
      decoration: BoxDecoration(
        color: Getirblue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: AppText(
          text: groceryItem.Unit,
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: colorWhite,
        ),
      ),
    );
  }

  _OnTaptoAddProductinCartFavorit(GroceryItem groceryItem) async {
    String name = groceryItem.ProductName;
    String Alias = groceryItem.ProductName;
    int ProductID = groceryItem.ProductID;
    int CustomerID = groceryItem.CustomerID;

    String Unit = groceryItem.Unit;
    String description = groceryItem.ProductSpecification;
    String ImagePath = groceryItem.ProductImage;
    int Qty = amount;
    double Amount = groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem.DiscountPer;
    String LoginUserID = groceryItem.LoginUserID;
    String CompanyID = groceryItem.ComapanyID;
    String ProductSpecification = groceryItem.ProductSpecification;
    String ProductImage = groceryItem.ProductImage;
    double Vat = groceryItem.Vat; //getTotalPrice();

    print("VatAmoutn" + " Vat : " + Vat.toString());

    ProductCartModel productCartModel = new ProductCartModel(
        name,
        Alias,
        ProductID,
        CustomerID,
        Unit,
        Amount,
        Qty,
        DiscountPer,
        LoginUserID,
        CompanyID,
        ProductSpecification,
        ProductImage,
        Vat);

    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    bool isduplicate = false;

    for (int i = 0; i < groceryItemdb.length; i++) {
      if (ProductID == groceryItemdb[i].ProductID) {
        isduplicate = true;
        break;
      }
    }
    if (isduplicate == true) {
      fToast.showToast(
        child: showCustomToast(Title: "Item Already Added To Favorite"),
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      await OfflineDbHelper.getInstance()
          .insertProductToCartFavorit(productCartModel);

      fToast.showToast(
        child: showCustomToast(Title: "Item Added To Favorite"),
        gravity: ToastGravity.BOTTOM,
      );
    }

    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
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

  _OnTaptoAddProductinCart(GroceryItem groceryItem) async {
    String name = groceryItem.ProductName;
    String Alias = groceryItem.ProductName;
    int ProductID = groceryItem.ProductID;
    int CustomerID = groceryItem.CustomerID;

    String Unit = groceryItem.Unit;
    String description = groceryItem.ProductSpecification;
    String ImagePath = groceryItem.ProductImage;
    int Qty = amount;
    double Amount = groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem.DiscountPer;
    String LoginUserID = groceryItem.LoginUserID;
    String CompanyID = groceryItem.ComapanyID;
    String ProductSpecification = groceryItem.ProductSpecification;
    String ProductImage = groceryItem.ProductImage;

    double Vat = groceryItem.Vat; //getTotalPrice();
    print("dksjflkf" + Vat.toString());

    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    bool isupdated = false;
    int updateQty = 0;
    int id123 = 0;

    for (int i = 0; i < groceryItemdb.length; i++) {
      if (ProductID == groceryItemdb[i].ProductID) {
        isupdated = true;
        updateQty = groceryItemdb[i].Quantity;
        id123 = groceryItemdb[i].id;
        break;
      }
    }

    if (isupdated == true) {
      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          LoginUserID,
          CompanyID,
          ProductSpecification,
          ProductImage,
          Vat,
          id: id123);
      await OfflineDbHelper.getInstance().updateContact(productCartModel);
    } else {
      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          LoginUserID,
          CompanyID,
          ProductSpecification,
          ProductImage,
          Vat);
      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);
    }

    List<ProductCartModel> groceryItemdb123 =
        await OfflineDbHelper.getInstance().getProductCartList();
    int counttt = groceryItemdb123.length;
    setState(() {
      SharedPrefHelper.instance.putInt("CounterValue", counttt);
    });
    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;
    Navigator.of(context).pop(counttt);
  }
}

/// DashBoard Tab Implementation

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

class CustomTabGroupView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabGroupView({
    this.itemCount,
    this.tabBuilder,
    this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabGroupViewState createState() => _CustomTabGroupViewState();
}

class _CustomTabGroupViewState extends State<CustomTabGroupView>
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
  void didUpdateWidget(CustomTabGroupView oldWidget) {
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
            decoration: BoxDecoration(
              color: Getirbluelight,
              /*borderRadius: BorderRadius.circular(5),*/
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                TabBar(
                  indicator: BoxDecoration(
                      color: GetirYellow,
                      borderRadius: BorderRadius.circular(10.0)),
                  labelColor: Getirblue,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: colorWhite,

                  isScrollable: true,
                  controller: controller,
                  // labelColor: Theme.of(context).primaryColor,
                  // unselectedLabelColor: Theme.of(context).hintColor,
                  /*indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),*/
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
