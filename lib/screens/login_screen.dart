import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:login/widgets/responsive.dart';
import 'package:provider/provider.dart';

import '../models/user_provider.dart';

class LoginInScreen extends StatelessWidget {
  const LoginInScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: Responsive(
        desktop: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 8),
          children: [
            // Menu(),
            MediaQuery.of(context).size.width >= 500
                ? Menu()
                : SizedBox(), // Responsive
            Body(),
          ],
        ),
        mobile: _formLogin(context),
        tablet: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 8),
          children: [
            // Menu(),
            MediaQuery.of(context).size.width >= 500
                ? Menu()
                : SizedBox(), // Responsive
            Body(),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _menuItem(title: 'Home'),
              _menuItem(title: 'About us'),
              // _menuItem(title: 'Contact us'),
              // _menuItem(title: 'Help'),
            ],
          ),
          Row(
            children: [
              _menuItem(title: 'Sign In', isActive: true),
              _registerButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.deepPurple : Colors.grey,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 10,
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In to \nMy Application',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "If you don't have an account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "You can",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        log('Register');
                        FirebaseFirestore.instance.collection('users').add({
                          'name': 'John Doe',
                          'email': 'sfsdf',
                        });
                      },
                      child: Text(
                        "Register here!",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'images/illustration-2.png',
                  width: 300,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Image.asset(
            'images/illustration-1.png',
            width: 300,
          ),
        ),
        // MediaQuery.of(context).size.width >= 1200 //Responsive
        //     ? Image.asset(
        //         'images/illustration-1.png',
        //         width: 300,
        //       )
        //     : SizedBox(),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 6),
            child: Container(
              width: 320,
              height: MediaQuery.of(context).size.height / 2,
              child: _formLogin(context),
            ),
          ),
        )
      ],
    );
  }

  Widget _loginWithButton({required String image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]!),
            ),
      child: Center(
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      spreadRadius: 2,
                      blurRadius: 15,
                    )
                  ],
                )
              : BoxDecoration(),
          child: Image.asset(
            '$image',
            width: 35,
          ),
        ),
      ),
    );
  }
}

Widget _formLogin(BuildContext context) {
  return SignInScreen(
    subtitleBuilder: (context, action) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          action == AuthAction.signIn
              ? 'Welcome to FlutterFire UI! Please sign in to continue.'
              : 'Welcome to FlutterFire UI! Please create an account to continue',
        ),
      );
    },
    footerBuilder: (context, _) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          'By signing in, you agree to our terms and conditions.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    },
    actions: [
      AuthStateChangeAction<SignedIn>((context, state) async {
        var r = await FirebaseFirestore.instance
            .collection('users')
            .doc(state.user?.uid)
            .set({
          'name': state.user?.displayName,
          'email': state.user?.email,
          'photoUrl': state.user?.photoURL,
          'id': state.user?.uid,
        });
        final _firestore = FirebaseFirestore.instance;
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(state.user?.uid).get();
        Provider.of<UserProvider>(context, listen: false)
            .setData(doc: documentSnapshot);
      }),
    ],
  );
  // Column(
  //   children: [
  //     TextField(
  //       controller: emailCtrl,
  //       decoration: InputDecoration(
  //         hintText: 'Enter email or Phone number',
  //         filled: true,
  //         fillColor: Colors.blueGrey[50],
  //         labelStyle: TextStyle(fontSize: 12),
  //         contentPadding: EdgeInsets.only(left: 30),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blueGrey[50]!),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blueGrey[50]!),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //       ),
  //     ),
  //     SizedBox(height: 30),
  //     TextField(
  //       controller: passwordCtrl,
  //       decoration: InputDecoration(
  //         hintText: 'Password',
  //         counterText: 'Forgot password?',
  //         suffixIcon: Icon(
  //           Icons.visibility_off_outlined,
  //           color: Colors.grey,
  //         ),
  //         filled: true,
  //         fillColor: Colors.blueGrey[50],
  //         labelStyle: TextStyle(fontSize: 12),
  //         contentPadding: EdgeInsets.only(left: 30),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blueGrey[50]!),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.blueGrey[50]!),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //       ),
  //     ),
  //     SizedBox(height: 40),
  //     Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(30),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.deepPurple[100]!,
  //             spreadRadius: 10,
  //             blurRadius: 20,
  //           ),
  //         ],
  //       ),
  //       child: ElevatedButton(
  //         child: Container(
  //             width: double.infinity,
  //             height: 50,
  //             child: Center(child: Text("Sign In"))),
  //         onPressed: () => print("it's pressed"),
  //         style: ElevatedButton.styleFrom(
  //           primary: Colors.deepPurple,
  //           onPrimary: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //         ),
  //       ),
  //     ),
  //     SizedBox(height: 40),
  //     Row(children: [
  //       Expanded(
  //         child: Divider(
  //           color: Colors.grey[300],
  //           height: 50,
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Text("Or continue with"),
  //       ),
  //       Expanded(
  //         child: Divider(
  //           color: Colors.grey[400],
  //           height: 50,
  //         ),
  //       ),
  //     ]),
  //     SizedBox(height: 40),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Flexible(
  //           flex: 1,
  //           child: _loginWithButton(
  //             image: 'images/google.png',
  //             isActive: true,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ],
  // );
}
