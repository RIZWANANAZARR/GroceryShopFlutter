import 'package:flutter/material.dart';

class NavigatorItem {
  final String label;
  final String iconPath;
  final int index;
  final Widget screen;
  final int count;

  NavigatorItem(this.label, this.iconPath, this.index, this.screen,
      {this.count});
}

/*List<NavigatorItem> navigatorItems = [
  NavigatorItem("Shop", "assets/icons/shop_icon.svg", 0, HomeScreen()),
  NavigatorItem(
      "Explore", "assets/icons/explore_icon.svg", 1, ExploreDashBoardScreen()),
  NavigatorItem("Cart", "assets/icons/cart_icon.svg", 2,
      */ /*CartScreen()*/ /* DynamicCartScreen()),
  NavigatorItem(
      "Favourite", "assets/icons/favourite_icon.svg", 3, FavoriteItemsScreen()),
  NavigatorItem("Account", "assets/icons/account_icon.svg", 4, AccountScreen()),
];*/
