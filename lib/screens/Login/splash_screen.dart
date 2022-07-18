import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_provider.dart';
import '../../navigator/routing_constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLoggedIn() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      final _firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (documentSnapshot.exists) {
        Provider.of<UserProvider>(context, listen: false)
            .setData(doc: documentSnapshot);
        Navigator.pushReplacementNamed(context, rootPageRoute);
      } else {
        Navigator.pushReplacementNamed(context, loginScreenRoute);
      }
    } else {
      Navigator.pushReplacementNamed(context, loginScreenRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      // StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //     if (!snapshot.hasData) {
      //       return LoginInScreen();
      //     }
      //     return RootPage();
      //   },
      // ),
    );
  }
}
