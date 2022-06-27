import 'package:flutter/widgets.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/home/grocery_featured_Item_widget.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/registration/registration_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {

  /* if(SharedPrefHelper.instance.isLogIn==true)
    {
      HomeScreen.routeName: (context) => HomeScreen(),

    }
  else{
    SignInScreen.routeName: (context) => SignInScreen(),

  }*/
  SplashScreen.routeName: (context) => SplashScreen(),


  LoginScreen.routeName: (context) => LoginScreen(),
  WelcomeScreen.routeName: (context) => WelcomeScreen(),
  RegistrationScreen.routeName: (context) => RegistrationScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  AccountScreen.routeName: (context) => AccountScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  /*CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  FoodScreen.routeName: (context) => FoodScreen(),
  BakeryScreen.routeName:(context) => BakeryScreen(),
  DrinksScreen.routeName:(context) => DrinksScreen(),
  DairyScreen.routeName:(context) => DairyScreen(),
  SnackScreen.routeName:(context) => SnackScreen(),
  VagitableScreen.routeName:(context) => VagitableScreen(),*/
};
