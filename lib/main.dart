import 'package:desafio_quarkus/constants.dart';
import 'package:desafio_quarkus/firebase_options.dart';
import 'package:desafio_quarkus/models/auth.dart';
import 'package:desafio_quarkus/models/task_list.dart';
import 'package:desafio_quarkus/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, TaskList>(
          create: (_) => TaskList(),
          update: (context, auth, previous) {
            return TaskList(
              auth.userId ?? '',
              previous?.tasks ?? [],
            );
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryTextTheme: Typography().white,
            textTheme: Typography().white,
            scaffoldBackgroundColor: Pallete.black,
            useMaterial3: true,
            iconTheme: const IconThemeData(color: Pallete.white),
            appBarTheme: const AppBarTheme(
              backgroundColor: Pallete.black,
            )),
        home: const SplashScreen(),
      ),
    );
  }
}
