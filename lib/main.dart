import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:login/models/user_provider.dart';
import 'package:login/util/theme_data.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'navigator/router.dart' as router;
import 'navigator/routing_constants.dart';

const clientId =
    '827641015183-dt4lnpb7h7ijm4dio24hvia51ufu93hr.apps.googleusercontent.com';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(clientId: clientId),
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // final FirebaseAnalyticsObserver observer =
  // FirebaseAnalyticsObserver(analytics: _analytics);
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        theme: buildThemeData(context),
        themeMode: ThemeMode.dark,
        title: 'Flutter Login Web',
        onGenerateRoute: router.generateRoute,
        initialRoute: rootPageRoute,
        navigatorKey: navigatorKey,
        // navigatorObservers: <NavigatorObserver>[observer],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
