import 'package:flutter/material.dart';
import 'package:login/navigator/routing_constants.dart';
import 'package:login/screens/home_screen.dart';

import '../screens/Login/login_screen.dart';
import '../screens/Login/splash_screen.dart';
import '../screens/root_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case rootPageRoute:
      return MaterialPageRoute(builder: (context) => RootPage());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (context) => LoginInScreen());
    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case homeScreenRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    // case '/card_settings':
    //   return MaterialPageRoute(builder: (context) => CardSettingsScreen());
    // case '/scan_pay':
    //   return MaterialPageRoute(builder: (context) => ScanPayScreen());
    // case '/transaction_status':
    //   return MaterialPageRoute(builder: (context) => TransactionStatusScreen());
    default:
      return MaterialPageRoute(builder: (context) => RootPage());
  }
}
