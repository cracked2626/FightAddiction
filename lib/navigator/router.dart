import 'package:flutter/material.dart';
import 'package:login/screens/login_screen.dart';

import '../screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/homeScreen':
      return MaterialPageRoute(builder: (context) => RootPage());
    case '/loginScreen':
      return MaterialPageRoute(builder: (context) => LoginInScreen());
    // case '/nav':
    //   return MaterialPageRoute(builder: (context) => NavScreen());
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
