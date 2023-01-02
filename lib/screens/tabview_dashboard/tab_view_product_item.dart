import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Tab_List/tab_product_list_from_brandID_groupID_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin_order/order_list/order_customer_list_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/dashboard/navigator_item.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';

import 'only_product_details.dart';

class AddTabProductItemsScreenArguments {
  String ProductGroupID;
  String ProductBrandID;

  AddTabProductItemsScreenArguments(this.ProductGroupID, this.ProductBrandID);
}

class TabProductItemsScreen extends BaseStatefulWidget {
  static const routeName = '/TabProductItemsScreen';
  final AddTabProductItemsScreenArguments arguments;
  final Function() funCallback;

  TabProductItemsScreen(this.arguments, {this.funCallback});

  @override
  _TabProductItemsScreenState createState() =>
      _TabProductItemsScreenState(funCallback: funCallback);
}

class _TabProductItemsScreenState extends BaseState<TabProductItemsScreen>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  final Function() funCallback;

  _TabProductItemsScreenState({this.funCallback});
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductGroupID;
  String _ProductBrandID;
  List<GroceryItem> AllProducts = [];

  String ProductGroupName = "";

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";
  final double width = 200;
  double height = 250;

  final Color borderColor = Color(0xffE2E2E2);

  PersistentBottomSheetController _bottomsheetcontroller; // instance variable

  TextEditingController _amount = TextEditingController();
  bool isAdd = false;
  bool isProductinCart = false;
  FToast fToast;
  int cartCount = 0;
  int FavCount = 0;

  var provider;

  List<NavigatorItem> navigatorItems123 = [];

  int _selectedIndex = 0;
  bool isopendilaog = false;
  BuildContext bootomsheetContext;

  List<ProductCartModel> temparays = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    fToast = FToast();
    fToast.init(context);

    _amount.text = "";

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    baseBloc.userRepository.prefs.putInt("Count", 1);

    _ProductGroupID = widget.arguments.ProductGroupID;
    _ProductBrandID = widget.arguments.ProductBrandID;

    _categoryScreenBloc.add(TabProductListBrandIDGroupIDRequestEvent(
        TabProductListBrandIDGroupIDRequest(
            BrandID: _ProductBrandID,
            GroupID: _ProductGroupID,
            ActiveFlag: "1",
            CompanyId: CompanyID.toString())));
    getproductductdetails();
    getNavigationList(_offlineLogindetails.details[0].customerType);
    //SharedPrefHelper(prefs)
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("AppState" + "Resume");

        // Handle this case
        break;
      case AppLifecycleState.inactive:
        // Handle this case
        print("AppState" + "inactive");

        break;
      case AppLifecycleState.paused:
        // Handle this case
        print("AppState" + "paused");

        break;
      case AppLifecycleState.detached:
        // Handle this case
        print("AppState" + "detached");

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    getproductductdetails();

    return BlocProvider(
      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if (state is TabProductListResponseState) {
            _onCategoryResponse(state, context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is TabProductListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    getproductductdetails();

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: //AllProducts.isNotEmpty
            Scaffold(
                backgroundColor: colorLightGray,
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
                          navigateTo(context, TabHomePage.routeName,
                              clearAllStack: true);
                        } else if (index == 1) {
                          navigateTo(context, ExploreDashBoardScreen.routeName,
                              clearAllStack: true);
                        } else if (index == 2) {
                          navigateTo(context, DynamicCartScreen.routeName,
                              clearAllStack: true);
                        } else if (index == 3) {
                          if (LoginUserID != "dummy") {
                            navigateTo(context, FavoriteItemsScreen.routeName,
                                clearAllStack: true);
                          } else {
                            navigateTo(context, LoginScreen.routeName,
                                clearAllStack: true);
                          }
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
                          navigateTo(context, AccountScreen.routeName,
                              clearAllStack: true);
                        }
                        print("SelectedIndex" + _selectedIndex.toString());
                      },
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: AppColors.primaryColor,
                      selectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.w600),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.w600),
                      unselectedItemColor: Colors.black,
                      items: navigatorItems123.map((e) {
                        //  provider.counter = cartCount;

                        return getNavigationBarItem(
                            label: e.label,
                            index: e.index,
                            iconPath: e.iconPath,
                            count: cartCount,
                            provif: provider,
                            favcount: FavCount);
                      }).toList(),
                    ),
                  ),
                ),
                body: AllProducts.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        controller:
                            new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        childAspectRatio: (1 / 1.3),

                        // I only need two card horizontally
                        children: AllProducts.asMap().entries.map<Widget>((e) {
                          GroceryItem groceryItem = e.value;
                          getproductductdetails();
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                color: colorWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.all(5),

                                  /*decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: borderColor,
                                    ),
                                  ),*/
                                  child: Visibility(
                                    visible: true,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                //Navigator.pop(bootomsheetContext);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailsScreen(
                                                              groceryItem)),
                                                );
                                              },
                                              child: Image.network(
                                                groceryItem.ProductImage,
                                                frameBuilder: (context,
                                                    child,
                                                    frame,
                                                    wasSynchronouslyLoaded) {
                                                  return child;
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return CircularProgressIndicator();
                                                  }
                                                },
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace stackTrace) {
                                                  return Image.asset(
                                                      NO_IMAGE_FOUND);
                                                },
                                              ),
                                            ), //imageWidget()),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: Text(groceryItem.ProductName,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xff6C777C),
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.center),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AppText(
                                          text:
                                              "Price \£${groceryItem.UnitPrice.toStringAsFixed(2)}",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                int amount = 1;
                                                _amount.text = "\£" +
                                                    groceryItem.UnitPrice
                                                        .toStringAsFixed(2);
                                                setState(() {
                                                  isAdd = true;
                                                  isopendilaog = true;
                                                  SharedPrefHelper.instance
                                                      .putBool(
                                                          "opendialog", true);

                                                  getproductductdetails();
                                                  //comparedbqtytoaddedqty(groceryItem);

                                                  if (temparays.length != 0) {
                                                    for (int i = 0;
                                                        i < temparays.length;
                                                        i++) {
                                                      if (temparays[i]
                                                              .ProductID ==
                                                          groceryItem
                                                              .ProductID) {
                                                        setState(() {
                                                          amount = temparays[i]
                                                              .Quantity
                                                              .toInt();
                                                          var tot = amount *
                                                              temparays[i]
                                                                  .UnitPrice;
                                                          _amount.text = "\£" +
                                                              tot.toStringAsFixed(
                                                                  2);
                                                        });
                                                        //getTotalPrice(groceryItem1234).toStringAsFixed(2);
                                                        isProductinCart = true;
                                                        break;
                                                      } else {
                                                        isProductinCart = false;
                                                      }
                                                    }
                                                  }

                                                  _bottomsheetcontroller =
                                                      showBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              bc) {
                                                            bootomsheetContext =
                                                                bc;
                                                            return SafeArea(
                                                              child: Container(
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                height: 300,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    decoration: new BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20.0),
                                                                        gradient:
                                                                            LinearGradient(colors: [
                                                                          cardgredient1,
                                                                          cardgredient2
                                                                        ])),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        //getImageHeaderWidget(),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 15),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                                        var tot = amount * groceryItem.UnitPrice;
                                                                                        _amount.text = "\£" + tot.toString();

                                                                                        //getTotalPrice(groceryItem).toStringAsFixed(2);
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
                                                                              getProductDataRowWidget("Product Details", groceryItem, amount),
                                                                              Divider(thickness: 1),
                                                                              getProductDataRowWidget("Unit", groceryItem, amount, customWidget: nutritionWidget(groceryItem)),

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
                                                                                      _OnTaptoAddProductinCart(groceryItem, context, amount);
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
                                                                                      if (LoginUserID != "dummy") {
                                                                                        _OnTaptoAddProductinCartFavorit(groceryItem, amount);
                                                                                      } else {
                                                                                        navigateTo(context, LoginScreen.routeName, clearAllStack: true);
                                                                                      }
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
                                              child: SizedBox(
                                                height: 32,
                                                child: Container(
                                                  height: 32,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: AppColors
                                                          .primaryColor),
                                                  child: Center(
                                                    child: Text(
                                                      //isProductinCart == true ? "View" : "Add",
                                                      "Add",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        /* staggeredTiles: AllProducts.map<StaggeredTile>(
                            (_) => StaggeredTile.fit(2)).toList(),*/
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 0.0, // add some space
                      )
                    : Center(
                        child: Image.asset(
                          NO_DASHBOARD,
                          width: 250,
                        ),
                      )));
  }

  BottomNavigationBarItem getNavigationBarItem(
      {String label,
      String iconPath,
      int index,
      int count,
      var provif,
      int favcount}) {
    Color iconColor =
        index == _selectedIndex ? AppColors.primaryColor : Colors.black;
    provif = count;
    return BottomNavigationBarItem(
      label: label,
      icon: label == "Cart"
          ? Badge(
              badgeContent: Text(
                count.toString(),
                style: TextStyle(
                  color: colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: iconColor,
              ),
            )
          : label == "Favourite"
              ? Badge(
                  badgeContent: Text(
                    favcount.toString(),
                    style: TextStyle(
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    color: iconColor,
                  ),
                )
              : SvgPicture.asset(
                  iconPath,
                  color: iconColor,
                ),

      // activeIcon: badge
    );
  }

  void getNavigationList(String CustomerType) {
    /*AddTabProductItemsScreenArguments addTabProductItemsScreenArguments =
        AddTabProductItemsScreenArguments("1", "2");

    TabProductItemsScreen(
      addTabProductItemsScreenArguments,
      funCallback: () {
        setState(() {
          cartCount++;
        });
      },
    );*/

    navigatorItems123.clear();
    List<NavigatorItem> navigatorItems12 = [];

    if (CustomerType != "customer") {
      navigatorItems12 = [
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, TabHomePage()),
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
        NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, TabHomePage()),
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

  /* double getTotalPrice(GroceryItem groceryItem) {
    var tot = amount * groceryItem.UnitPrice;
    print("sfjklfj" + tot.toString() + "Amount : " + amount.toString());
    _amount.text = "\£" + tot.toString();
    return amount * groceryItem.UnitPrice;
  }*/

  Widget getProductDataRowWidget(
      String label, GroceryItem groceryItem, int amount,
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

  Future<bool> _onBackPressed() {
    //navigateTo(context, TabHomePage.routeName, clearAllStack: true);
    print("Navigatorrr" + "Tab_view_Product");

    Navigator.pop(context);
  }

/*  @override
  void dispose() {
    super.dispose();
  }*/

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    );
  }

  void _onCategoryResponse(
      TabProductListResponseState state, BuildContext context) {
    AllProducts.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      if (_ProductGroupID == "") {
        ProductGroupName = "All Items";
      } else {
        ProductGroupName = state.response.details[i].productGroupName;
      }
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

  Widget imageWidget(GroceryItem _groceryItem) {
    return AspectRatio(
      aspectRatio: 3 / 3,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(_groceryItem.ProductImage),
                fit: BoxFit.scaleDown)),
        child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
            /*  gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.0),
              ])*/
          ),
          // child: Align(alignment: Alignment.topLeft, child: addWidget())

          /*isAdd == false
              ? Align(alignment: Alignment.topRight, child: addWidget())
              :  Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                        ),
                        color: colorWhite),
                    child: ItemCounterWidget(
                      onAmountChanged: (newAmount) {
                        setState(() {
                          amount = newAmount;
                        });
                      },
                    ),
                  ),
                ),*/
        ),
      ),
    );
  }

  removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
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

  Widget ratingWidget() {
    Widget starIcon() {
      return Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 20,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }

  /*_OnTaptoAddProductinCart(GroceryItem groceryItem_) async {
    String name = groceryItem_.ProductName;
    String Alias = groceryItem_.ProductName;
    int ProductID = groceryItem_.ProductID;
    int CustomerID = groceryItem_.CustomerID;

    String Unit = groceryItem_.Unit;
    String description = groceryItem_.ProductSpecification;
    String ImagePath = groceryItem_.ProductImage;
    int Qty = amount;
    double Amount = groceryItem_.UnitPrice; //getTotalPrice();
    double DiscountPer = groceryItem_.DiscountPer;
    String LoginUserID = groceryItem_.LoginUserID;
    String CompanyID = groceryItem_.ComapanyID;
    String ProductSpecification = groceryItem_.ProductSpecification;
    String ProductImage = groceryItem_.ProductImage;
    double Vat = groceryItem_.Vat;

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
    await getproductductdetails();
    List<ProductCartModel> groceryItemdb123 =
        await OfflineDbHelper.getInstance().getProductCartList();
    int counttt = groceryItemdb123.length;

    setState(() {
      cartCount = counttt;
    });
    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;

    Navigator.pop(context);
  }*/

  _OnTaptoAddProductinCart(
      GroceryItem groceryItem, BuildContext context123, int amount) async {
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

    //await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    bool isupdated = false;
    int updateQty = 0;
    int id123 = 0;

    for (int i = 0; i < groceryItemdb.length; i++) {
      if (ProductID == groceryItemdb[i].ProductID) {
        print("QTYPLUE" +
            "DBQTY : " +
            groceryItemdb[i].Quantity.toString() +
            " APIQTY : " +
            amount.toString());
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
      cartCount = counttt;

      //SharedPrefHelper.instance.putInt("CounterValue", counttt);
    });
    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    isProductinCart = true;

    Navigator.pop(context123);
  }

  _OnTaptoAddProductinCartFavorit(GroceryItem groceryItem, int amount) async {
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

      List<ProductCartModel> groceryItemdb123 =
          await OfflineDbHelper.getInstance().getProductCartFavoritList();
      int counttt = groceryItemdb123.length;
      setState(() {
        FavCount = counttt;

        //SharedPrefHelper.instance.putInt("CounterValue", counttt);
      });

      fToast.showToast(
        child: showCustomToast(Title: "Item Added To Favorite"),
        gravity: ToastGravity.BOTTOM,
      );
    }

    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
  }

  Future<void> getproductductdetails() async {
    List<ProductCartModel> Tempgetproductlistfromdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    cartCount = Tempgetproductlistfromdb.length;

    List<ProductCartModel> TempgetFavotiresfromdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    FavCount = TempgetFavotiresfromdb.length;
    temparays.clear();
    temparays.addAll(Tempgetproductlistfromdb);
  }

  comparedbqtytoaddedqty(GroceryItem groceryItem123) async {
    //await showresultofqtyupdate(groceryItem123);

    /* if (temparays.length != 0) {
      for (int i = 0; i < temparays.length; i++) {
        if (temparays[i].ProductID == groceryItem123.ProductID) {
          setState(() {
            amount = temparays[i].Quantity.toInt();
            var tot = amount * temparays[i].UnitPrice;
            _amount.text = "\£" + tot.toStringAsFixed(2);
          });
          //getTotalPrice(groceryItem1234).toStringAsFixed(2);
          isProductinCart = true;
          break;
        } else {
          isProductinCart = false;
        }
      }
    }*/
  }

  /*Future<void> showresultofqtyupdate(GroceryItem groceryItem1234) async {
    await OfflineDbHelper.getInstance().getProductCartList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == groceryItem1234.ProductID) {
        setState(() {
          amount = groceryItemdb[i].Quantity.toInt();
          var tot = amount * groceryItemdb[i].UnitPrice;
          _amount.text = "\£" + tot.toStringAsFixed(2);
        });
        //getTotalPrice(groceryItem1234).toStringAsFixed(2);
        isProductinCart = true;
        break;
      } else {
        isProductinCart = false;
      }

      print("FlagDeBIUG" +
          isProductinCart.toString() +
          " DBPRID " +
          groceryItemdb[i].ProductID.toString() +
          groceryItem1234.ProductID.toString());
    }
  }*/
}
