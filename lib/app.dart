import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/screens/AdminRegistration/admin_registration_screen.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/ProductReporting/product_reporting_list_screen.dart';
import 'package:grocery_app/screens/ShopDashBoard/shopDashBoard.dart';
import 'package:grocery_app/screens/Update_Profile/profile_list_screen.dart';
import 'package:grocery_app/screens/Update_Profile/update_profile_screen.dart';
import 'package:grocery_app/screens/account/about_us_screen.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin_order/order_add_edit/order_product_add_edit_screen.dart';
import 'package:grocery_app/screens/admin_order/order_list/order_customer_list_screen.dart';
import 'package:grocery_app/screens/best_selling/best_selling_list_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/category_items_screen.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/exclusive_offer/exclusive_offer_list_screen.dart';
import 'package:grocery_app/screens/explore_screen.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/filter_screen.dart';
import 'package:grocery_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:grocery_app/screens/general_product_search/general_product_search.dart';
import 'package:grocery_app/screens/home/grocery_featured_Item_widget.dart';
import 'package:grocery_app/screens/home/home_banner_widget.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/customer_search_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/general_product_search_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_header_add_edit_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_product_add_edit_screen.dart';
import 'package:grocery_app/screens/inward/inward_add_edit/inward_product_list_screen.dart';
import 'package:grocery_app/screens/inward/inward_list/inward_list_screen.dart';
import 'package:grocery_app/screens/login/change_password_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/manage_payment/manage_payment_list_screen.dart';
import 'package:grocery_app/screens/my_order/my_order_list_screen.dart';
import 'package:grocery_app/screens/placed_order/place_order_product_list_screen.dart';
import 'package:grocery_app/screens/placed_order/placed_order_card_widget.dart';
import 'package:grocery_app/screens/placed_order/placed_order_list_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_add.dart';
import 'package:grocery_app/screens/product_brand/product_brand_list.dart';
import 'package:grocery_app/screens/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/product_group/product_group_add.dart';
import 'package:grocery_app/screens/product_group/product_group_pagination.dart';
import 'package:grocery_app/screens/product_master/manage_product.dart';
import 'package:grocery_app/screens/product_master/product_pagination.dart';
import 'package:grocery_app/screens/registration/registration_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/Smart_Customer_Screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/only_product_details.dart';
import 'package:grocery_app/screens/tabview_dashboard/product_detail_view.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_dasboard_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_product_details_screen.dart';
import 'package:grocery_app/screens/tabview_dashboard/tab_view_product_item.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/styles/theme.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class MyApp extends StatelessWidget {
  static MaterialPageRoute globalGenerateRoute(RouteSettings settings) {
    //if screen have no argument to pass data in next screen while transiting
    // final GlobalKey<ScaffoldState> key = settings.arguments;

    switch (settings.name) {
      case WelcomeScreen.routeName:
        return getMaterialPageRoute(WelcomeScreen());
      case SplashScreen.routeName:
        return getMaterialPageRoute(SplashScreen());
      case LoginScreen.routeName:
        return getMaterialPageRoute(LoginScreen());
      case RegistrationScreen.routeName:
        return getMaterialPageRoute(RegistrationScreen());
      case HomeScreen.routeName:
        return getMaterialPageRoute(HomeScreen());
      case DashboardScreen.routeName:
        return getMaterialPageRoute(DashboardScreen());
      case GroceryFeaturedCard.routeName:
        return getMaterialPageRoute(GroceryFeaturedCard(settings.arguments));
      case DynamicCartScreen.routeName:
        return getMaterialPageRoute(DynamicCartScreen());

      case HomeBanner.routeName:
        return getMaterialPageRoute(HomeBanner());
      case CategoryItemsScreen.routeName:
        return getMaterialPageRoute(CategoryItemsScreen(settings.arguments));
      case ExclusiveOfferListScreen.routeName:
        return getMaterialPageRoute(ExclusiveOfferListScreen());

      case FilterScreen.routeName:
        return getMaterialPageRoute(FilterScreen());
      case BestSellingListScreen.routeName:
        return getMaterialPageRoute(BestSellingListScreen());

      case ManageProduct.routeName:
        return getMaterialPageRoute(ManageProduct(settings.arguments));
      case ProductPagination.routeName:
        return getMaterialPageRoute(ProductPagination());

      case AccountScreen.routeName:
        return getMaterialPageRoute(AccountScreen());
      case ForgotPasswordScreen.routeName:
        return getMaterialPageRoute(ForgotPasswordScreen());

      case ProductBrandPagination.routeName:
        return getMaterialPageRoute(ProductBrandPagination());
      case ManageProductBrand.routeName:
        return getMaterialPageRoute(ManageProductBrand(settings.arguments));
      case SearchProductBrandScreen.routeName:
        return getMaterialPageRoute(SearchProductBrandScreen());
      case FavoriteItemsScreen.routeName:
        return getMaterialPageRoute(FavoriteItemsScreen());
      case ProductDetailsScreen.routeName:
        return getMaterialPageRoute(ProductDetailsScreen(settings.arguments));
      case ProductGroupPagination.routeName:
        return getMaterialPageRoute(ProductGroupPagination());
      case ManageProductGroup.routeName:
        return getMaterialPageRoute(ManageProductGroup(settings.arguments));
      case AdminRegistrationScreen.routeName:
        return getMaterialPageRoute(AdminRegistrationScreen());
      case AboutUsDialogue.routeName:
        return getMaterialPageRoute(AboutUsDialogue());
      case PlacedOrderListScreen.routeName:
        return getMaterialPageRoute(PlacedOrderListScreen());
      case PlacedOrderDetailsScreen.routeName:
        return getMaterialPageRoute(
            PlacedOrderDetailsScreen(settings.arguments));

      case TabHomePage.routeName:
        return getMaterialPageRoute(TabHomePage());
      case ShopDashBoard.routeName:
        return getMaterialPageRoute(ShopDashBoard());

      /* case TabProductPage.routeName:
        return getMaterialPageRoute(TabHomePage(settings.arguments));*/
      case TabProductPage.routeName:
        return getMaterialPageRoute(TabProductPage(settings.arguments));

      case TabProductItemsScreen.routeName:
        return getMaterialPageRoute(TabProductItemsScreen(settings.arguments));

      case ExploreScreen.routeName:
        return getMaterialPageRoute(ExploreScreen(settings.arguments));
      case OrderCustomerList.routeName:
        return getMaterialPageRoute(OrderCustomerList());
      case OrderProductAddEdit.routeName:
        return getMaterialPageRoute(OrderProductAddEdit(settings.arguments));

      case AllProductSearch.routeName:
        return getMaterialPageRoute(AllProductSearch());
      case MyOrder.routeName:
        return getMaterialPageRoute(MyOrder());

      case UpdateProfileScreen.routeName:
        return getMaterialPageRoute(UpdateProfileScreen(settings.arguments));

      case OrderProductAddEdit.routeName:
        return getMaterialPageRoute(OrderProductAddEdit(settings.arguments));

      case ProfileListScreen.routeName:
        return getMaterialPageRoute(ProfileListScreen());
      case ProductDetailsScreen1.routeName:
        return getMaterialPageRoute(ProductDetailsScreen1(settings.arguments));
      case ProductDetailsScreen2.routeName:
        return getMaterialPageRoute(ProductDetailsScreen2(settings.arguments));

      /* case TabProductItemCardWidget.routeName:
        return getMaterialPageRoute(
            TabProductItemCardWidget(settings.arguments));*/
      case PlacedItemCardWidget.routeName:
        return getMaterialPageRoute(PlacedItemCardWidget(settings.arguments));

      case ManagePaymentPagination.routeName:
        return getMaterialPageRoute(ManagePaymentPagination());

      case InwardListScreen.routeName:
        return getMaterialPageRoute(InwardListScreen());
      case AddEditInwardScreen.routeName:
        return getMaterialPageRoute(AddEditInwardScreen(settings.arguments));
      case SearchCustomerInwardScreen.routeName:
        return getMaterialPageRoute(SearchCustomerInwardScreen());

      case InquiryProductListScreen.routeName:
        return getMaterialPageRoute(
            InquiryProductListScreen(settings.arguments));
      case AddInquiryProductScreen.routeName:
        return getMaterialPageRoute(
            AddInquiryProductScreen(settings.arguments));

      case SearchInquiryProductScreen.routeName:
        return getMaterialPageRoute(SearchInquiryProductScreen());

      case ExploreDashBoardScreen.routeName:
        return getMaterialPageRoute(ExploreDashBoardScreen());

      case SearchSmartCustomerScreen.routeName:
        return getMaterialPageRoute(SearchSmartCustomerScreen());
      case ChangePasswordScreen.routeName:
        return getMaterialPageRoute(ChangePasswordScreen());
      case ProductReportingListScreen.routeName:
        return getMaterialPageRoute(ProductReportingListScreen());

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        onGenerateRoute: MyApp.globalGenerateRoute,
        theme: themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: getInitialRoute()

/*
    home: SplashScreen(),
*/

        );
  }

  getInitialRoute() {
    /*if (SharedPrefHelper.instance.isLogIn()) {
      return DashboardScreen.routeName;
    } else if (SharedPrefHelper.IS_REGISTERED == "is_registered") {
      return WelcomeScreen.routeName;
    } else {
      return SplashScreen.routeName;
    }*/
    if (SharedPrefHelper.instance.isLogIn()) {
      /// return TabHomePage.routeName;
      return TabHomePage.routeName;
    } else if (SharedPrefHelper.instance.isRegisteredIn()) {
      return LoginScreen.routeName;
    }

    return SplashScreen.routeName;
  }
}
