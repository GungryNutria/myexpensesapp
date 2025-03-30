import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myexpensesapp/bloc/login/login_bloc.dart';
import 'package:myexpensesapp/bloc/user/user_bloc.dart';
import 'package:myexpensesapp/pages/login_page.dart';
import 'package:myexpensesapp/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: 'login',
        routes: {
          'login': (context) => const LoginPage(),
          'register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
