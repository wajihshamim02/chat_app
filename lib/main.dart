import 'package:chat_app_firebase/screen/Auth/login_Screen.dart';
import 'package:chat_app_firebase/screen/home_screen.dart';
import 'package:chat_app_firebase/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

late Size mq;


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full screen
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
// for setting orientation to Portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {

    runApp(const MyApp());
    _initializedFirebase();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        home: SplashScreen());
  }
}

_initializedFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
