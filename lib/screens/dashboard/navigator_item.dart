import 'package:flutter/material.dart';
import 'package:grocery_app/screens/ExploreDashBoard/explore_dashboard_screen.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/home/home_screen.dart';

class NavigatorItem {
  final String label;
  final String iconPath;
  final int index;
  final Widget screen;

  NavigatorItem(this.label, this.iconPath, this.index, this.screen);
}

List<NavigatorItem> navigatorItems = [
  NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, HomeScreen()),
  NavigatorItem(
      "Explore", "assets/icons/explore_icon.svg", 1, ExploreDashBoardScreen()),
  NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
      /*CartScreen()*/ DynamicCartScreen()),
  NavigatorItem(
      "Favourite", "assets/icons/favourite_icon.svg", 3, FavoriteItemsScreen()),
  NavigatorItem("Account", "assets/icons/account_icon.svg", 4, AccountScreen()),
];
