import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/pages/image.dart';
import 'package:wallpaper/pages/liked.dart';
import 'package:wallpaper/pages/reset.dart';
import 'package:wallpaper/pages/signin.dart';
import 'package:wallpaper/pages/register.dart';
import 'package:wallpaper/pages/start.dart';
import 'pages/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      theme: ThemeData.dark(),
      home: AnimatedSplashScreen(
        duration: 1500,
        splash: SpinKitSpinningLines(color: Color(0xFFF03A56),size: 100,),
        nextScreen: StartPage(),
        splashTransition: SplashTransition.decoratedBoxTransition,
        backgroundColor: Color(0xFF262626),
      ),
      routes: {
        'search screen':(context) => const SearchPage(),
        'image screen':(context) => const ImageScreen(),
        'login screen': (context) => const LoginPage(),
        'signup screen': (context) => const RegisterPage(),
        'start screen': (context) => const StartPage(),
        'resetpwd screen': (context) => const ResetPWDPage(),
        'liked screen': (context)=> const LikedPage(),
      },
    );
  }
}

