import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myexpensesapp/bloc/account/account_bloc.dart';
import 'package:myexpensesapp/bloc/login/login_bloc.dart';
import 'package:myexpensesapp/bloc/user/user_bloc.dart';
import 'package:myexpensesapp/pages/dashboard_page.dart';
import 'package:myexpensesapp/pages/home_page.dart';
import 'package:myexpensesapp/pages/login_page.dart';
import 'package:myexpensesapp/pages/modify_account_page.dart';
import 'package:myexpensesapp/pages/register_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('UserBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AccountBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: _getView(),
        routes: {
          'login': (context) => const LoginPage(),
          'register': (context) => const RegisterPage(),
          'home': (context) => HomePage(),
          'modify_account': (context) => const ModifyAccountPage(),
          'dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
  
  _getView() {
    final box = Hive.box('UserBox');
    if(box.get('data') != null) return 'home';
    return 'login';
  }
}
