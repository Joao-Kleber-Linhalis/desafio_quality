import 'package:desafio_quality/models/auth.dart';
import 'package:desafio_quality/screens/auth_screen.dart';
import 'package:desafio_quality/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthOrHomeScreen extends StatefulWidget {
  const AuthOrHomeScreen({super.key});

  @override
  State<AuthOrHomeScreen> createState() => _AuthOrHomeScreenState();
}

class _AuthOrHomeScreenState extends State<AuthOrHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth.authStateChanges(),
      builder: (context, snapshot) {
        // Verifica o estado da autenticação
        if (snapshot.connectionState == ConnectionState.active) {
          // Se o usuário estiver autenticado
          if (snapshot.hasData) {
            return const HomeScreen(); // Tela inicial ou navegação para o app
          } else {
            return AuthScreen();
          }
        }

        // Exibe um carregando enquanto o estado da autenticação está sendo determinado
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
