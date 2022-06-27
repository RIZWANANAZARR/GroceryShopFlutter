import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/helpers/column_with_seprator.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/AdminRegistration/admin_registration_screen.dart';
import 'package:grocery_app/screens/Update_Profile/profile_list_screen.dart';
import 'package:grocery_app/screens/account/about_us_screen.dart';
import 'package:grocery_app/screens/admin_order/order_list/order_customer_list_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/explore_screen.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/inward/inward_list/inward_list_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/manage_payment/manage_payment_list_screen.dart';
import 'package:grocery_app/screens/my_order/my_order_list_screen.dart';
import 'package:grocery_app/screens/placed_order/placed_order_list_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_list.dart';
import 'package:grocery_app/screens/product_group/product_group_pagination.dart';
import 'package:grocery_app/screens/product_master/product_pagination.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

import 'account_item.dart';

class AccountScreen extends BaseStatefulWidget {
  static const routeName = '/AccountScreen';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends BaseState<AccountScreen>
    with BasicScreen, WidgetsBindingObserver {
  static const routeName = '/AccountScreen';

  String Email =
      SharedPrefHelper.instance.getLoginUserData().details[0].emailAddress;
  String UserName =
      SharedPrefHelper.instance.getLoginUserData().details[0].customerName;

  List<AccountItem> accountItems = [];

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  String CustomerType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails = SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID =
        _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();
    CustomerType = _offlineLogindetails.details[0].customerType;

    getlist();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackpress,
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _offlineLogindetails.details[0].customerType != "customer"
                  ? navigateTo(context, AdminRegistrationScreen.routeName)
                  : Container();
            },
            child: ListTile(
              leading: SizedBox(
                  width: 42,
                  height: 42,
                  child: Container(child: getImageHeader())),
              title: AppText(
                text: UserName,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppText(
                text: Email,
                color: Color(0xff7C7C7C),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              trailing: SizedBox(
                  width: 42,
                  height: 42,
                  child: GestureDetector(
                      onTap: () {
                        navigateTo(context, TabHomePage.routeName,
                            clearAllStack: true);
                      },
                      child: Icon(
                        Icons.home,
                        color: Getirblue,
                        size: 40,
                      ))),
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: getChildrenWithSeperator(
                        widgets: accountItems.map((e) {
                          return getAccountItemWidget(e);
                        }).toList(),
                        seperator: Divider(
                          thickness: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*logoutButton(context),
                    SizedBox(
                      height: 20,
                    )*/
                  ],
                ),
              ),
            ),
          ),
          logoutButton(context),
        ],
      )),
    );
  }

  Future<void> _onTapOfLogOut(BuildContext context) async {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to log out?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () async {
        Navigator.pop(context);
        await SharedPrefHelper.instance
            .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
        navigateTo(context, LoginScreen.routeName, clearAllStack: true);
      },
    );
  }

  Widget logoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _onTapOfLogOut(context);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: RaisedButton(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Getirblue,
          textColor: Colors.white,
          elevation: 0.0,
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  "assets/icons/account_icons/logout_icon.svg",
                  color: Colors.white,
                ),
              ),
              Text(
                "Log Out",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container()
            ],
          ),
          onPressed: () {
            /* Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen();

              },
            ));*/

            showCommonDialogWithTwoOptions(
              context,
              "Are you sure you want to log out?",
              negativeButtonTitle: "No",
              positiveButtonTitle: "Yes",
              onTapOfPositiveButton: () {
                Navigator.pop(context);
                SharedPrefHelper.instance
                    .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);

                navigateTo(context, LoginScreen.routeName, clearAllStack: true);
              },
            );
          },
        ),
      ),
    );
  }

  Widget getImageHeader() {
    String imagePath = "assets/images/sharvaya_logo.png";
    return CircleAvatar(
      radius: 5.0,
      backgroundImage: AssetImage(imagePath),
      backgroundColor: AppColors.primaryColor.withOpacity(0.7),
    );
  }

  Widget getAccountItemWidget(AccountItem accountItem) {
    return InkWell(
      onTap: () {
        if (accountItem.label == "Manage Order") {
          navigateTo(context, OrderCustomerList.routeName);
        }

        if (accountItem.label == "Product") {
          navigateTo(context, ProductPagination.routeName);
          /*Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageProduct()));*/
        }
        if (accountItem.label == "Product Brand") {
          navigateTo(context, ProductBrandPagination.routeName);
        }
        if (accountItem.label == "Product Group") {
          navigateTo(context, ProductGroupPagination.routeName);
        }
        if (accountItem.label == "Employee Registration") {
          navigateTo(context, AdminRegistrationScreen.routeName);
        }
        if (accountItem.label == "Explore") {
          navigateTo(context, ExploreScreen.routeName);
        }
        if (accountItem.label == "Cart") {
          navigateTo(context, DynamicCartScreen.routeName);
        }
        if (accountItem.label == "Favorites") {
          navigateTo(context, FavoriteItemsScreen.routeName);
        }
        if (accountItem.label == "About") {
          navigateTo(context, AboutUsDialogue.routeName);
        }
        if (accountItem.label == "Placed Order") {
          navigateTo(context, PlacedOrderListScreen.routeName);
        }
        if (accountItem.label == "Order Invoice") {
          navigateTo(context, MyOrder.routeName);
        }
        if (accountItem.label == "Manage Profile") {
          navigateTo(context, ProfileListScreen.routeName);
        }
        if (accountItem.label == "Manage Payment") {
          navigateTo(context, ManagePaymentPagination.routeName);
        }
        if (accountItem.label == "Material Inward") {
          navigateTo(context, InwardListScreen.routeName);
        }

        //My Order
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                accountItem.iconPath,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {},
              child: Text(
                accountItem.label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackpress() {
    navigateTo(context, TabHomePage.routeName, clearAllStack: true);
  }

  getlist() {
    if (CustomerType == "customer") {
      accountItems = [
        /*AccountItem("Add Product", "assets/icons/account_icons/orders_icon.svg"),
          AccountItem("Add Product Brand", "assets/icons/account_icons/details_icon.svg"),
          AccountItem(
              "Add Product Group", "assets/icons/account_icons/delivery_icon.svg"),
          AccountItem("Employee Registration", "assets/icons/account_icons/payment_icon.svg"),*/

        //MyOrder

        AccountItem(
            "Manage Profile", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Order Invoice", "assets/icons/account_icons/orders_icon.svg"),

        AccountItem("Placed Order",
            "assets/icons/account_icons/orders_icon.svg"), //PlacedOrderListScreen
        /* AccountItem("Explore", "assets/icons/account_icons/promo_icon.svg"),
        AccountItem("Cart", "assets/icons/account_icons/notification_icon.svg"),
        AccountItem("Favorites", "assets/icons/account_icons/help_icon.svg"),*/

        AccountItem("About", "assets/icons/account_icons/about_icon.svg"),
      ];
    } else if (CustomerType == "employee") {
      accountItems = [
        AccountItem(
            "Manage Profile", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Order Invoice", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Manage Order", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Manage Payment", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Product Brand", "assets/icons/account_icons/details_icon.svg"),
        AccountItem(
            "Product Group", "assets/icons/account_icons/details_icon.svg"),
        AccountItem("Product", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Placed Order", "assets/icons/account_icons/orders_icon.svg"),
        //  AccountItem("Favorites", "assets/icons/favourite_icon.svg"),
        AccountItem(
            "Material Inward", "assets/icons/account_icons/orders_icon.svg"),

        AccountItem("About", "assets/icons/account_icons/about_icon.svg"),
      ];
    } else {
      accountItems = [
        AccountItem(
            "Manage Profile", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Order Invoice", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Manage Order", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Manage Payment", "assets/icons/account_icons/orders_icon.svg"),

        AccountItem(
            "Product Brand", "assets/icons/account_icons/details_icon.svg"),
        AccountItem(
            "Product Group", "assets/icons/account_icons/details_icon.svg"),
        AccountItem("Product", "assets/icons/account_icons/orders_icon.svg"),
        //AccountItem("Employee Registration", "assets/icons/account_icon.svg"),
        AccountItem(
            "Placed Order", "assets/icons/account_icons/orders_icon.svg"),
        AccountItem(
            "Material Inward", "assets/icons/account_icons/orders_icon.svg"),
        //   AccountItem("Favorites", "assets/icons/favourite_icon.svg"),
        AccountItem("About", "assets/icons/account_icons/about_icon.svg"),
      ];
    }
  }
}

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Helllo"),
    );
  }
}
