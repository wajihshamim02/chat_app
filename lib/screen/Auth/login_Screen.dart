import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:chat_app_firebase/helper/dialogs.dart';
import 'package:chat_app_firebase/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  _handlegooglebtnclick() {
    //showing progressbar
    dialogs.showprogressbar(context);

    _signInWithGoogle().then((user) async {
      // hide progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUser Addtional Info: ${user.additionalUserInfo}');

        //if user is Exits
        if (await Apis.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          // User Created
          Apis.CreateUser();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      //if internet is off
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n signinwithgoogle: $e');
      dialogs.showsnackbar(
          context, 'Something went wrong Please check the internet connection');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Buzz Chat',
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedPositioned(
              top: size.height * 0.2,
              width: size.width * 0.5,
              right: isAnimate ? size.width * 0.25 : size.width * -0.5,
              duration: Duration(seconds: 1),
              child: Image.asset('images/chat.png')),
          Positioned(
              bottom: size.height * 0.2,
              width: size.width * 0.8,
              height: size.height * 0.1,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Color.fromARGB(255, 226, 255, 217),
                    shadowColor: Colors.green),
                onPressed: () {
                  _handlegooglebtnclick();
                },
                icon: Image(
                  image: AssetImage(
                    'images/google.png',
                  ),
                  height: size.height * 0.05,
                ),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: [
                      TextSpan(text: 'Signin with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ])),
              )),
        ],
      ),
    );
  }
}
