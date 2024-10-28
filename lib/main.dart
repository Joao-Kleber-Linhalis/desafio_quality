import 'package:desafio_quarkus/constants.dart';
import 'package:desafio_quarkus/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: Typography().white,
        textTheme: Typography().white,
        scaffoldBackgroundColor: Pallete.black,
        useMaterial3: true,
        iconTheme: const IconThemeData(color: Pallete.white),
        appBarTheme: const AppBarTheme(backgroundColor: Pallete.black,)
      ),
      home: const SplashScreen(),
    );
  }
}
