import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/login/login_bloc.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider.value(
        value: repo,
        child: BlocProvider(
          create: (context) => LoginBloc(repo),
          child: LoginScreen(),
        ),
      ),
    );
  }
}