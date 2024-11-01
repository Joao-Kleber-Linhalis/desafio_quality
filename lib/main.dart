import 'package:desafio_quality/constants.dart';
import 'package:desafio_quality/firebase_options.dart';
import 'package:desafio_quality/models/auth.dart';
import 'package:desafio_quality/models/task_list.dart';
import 'package:desafio_quality/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryTextTheme: Typography().white,
            textTheme: Typography().white,
            scaffoldBackgroundColor: Pallete.backgroundColor,
            useMaterial3: true,
            iconTheme: const IconThemeData(color: Pallete.white),
            appBarTheme: const AppBarTheme(
              backgroundColor: Pallete.backgroundColor,
            )),
        home: const SplashScreen(),
      ),
    );
  }
}
