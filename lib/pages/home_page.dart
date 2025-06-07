import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:myexpensesapp/bloc/account/account_bloc.dart';
import 'package:myexpensesapp/models/account.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/services/account_service.dart';
import 'package:myexpensesapp/utils/functions.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  late User user;
  AccountService accountService = AccountService();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Functions.GetHiveUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis Cuentas",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: ThemeColors.BLUE_GREEN_LIGHT,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              // Handle logout action
              var box = Hive.box('UserBox');
              box.put('data', null);
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.BLUE_DARK,
        onPressed:
            () => Navigator.pushNamed(context, 'modify_account', arguments: Account()),
        child: const Icon(Icons.add, color: ThemeColors.BLUE_WHITE),
      ),
      body: _body(),
    );
  }
  Widget _body(){
    return FutureBuilder(
      future: accountService.getAccounts(user.id!), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<Account> accounts = snapshot.data!;
          return _accountList(accounts);
        } else {
          return const Center(child: Text('No accounts found'));
        }
      },
      );
  }

  Widget _accountList(List<Account> accounts) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),

      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          color: ThemeColors.BLUE_GREEN_LIGHT,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, 'dashboard', arguments: account.id),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  account.name!,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  '${account.description}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  } 
}
