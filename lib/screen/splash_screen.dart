import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app_firebase/api/apis.dart';
import 'package:chat_app_firebase/screen/Auth/login_Screen.dart';
import 'package:chat_app_firebase/screen/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      //exit Full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      if(Apis.auth.currentUser !=null) {
        log('\nwajih: ${Apis.auth.currentUser}');
        
        //navigate to hpme screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
      }
      else {
        // navigate to login screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
      }

      //Change Color of Status Bar
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      curve: Curves.easeInCirc,
      splashIconSize: 200,
      duration: 3000,
      nextScreen: LoginScreen(),
      splash: 'images/chat.png',
      splashTransition: SplashTransition.sizeTransition,
      // pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}
