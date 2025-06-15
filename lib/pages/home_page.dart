import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:myexpensesapp/bloc/account/account_bloc.dart';
import 'package:myexpensesapp/models/account.dart';
import 'package:myexpensesapp/models/account_create.dart';
import 'package:myexpensesapp/models/type_account.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/utils/functions.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';
import 'package:myexpensesapp/widgets/custom_button.dart';
import 'package:myexpensesapp/widgets/custom_dropdown.dart';
import 'package:myexpensesapp/widgets/custom_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AccountBloc accountBloc;
  bool isLoading = false;
  late User user;
  late Account account;
  late AccountCreate accountCreate;
  final _formKey = GlobalKey<FormState>();
  List<TypeAccount> typeAccounts = [];
  List<Account> accounts = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isLoading) {
      account = Account();
      accountCreate = AccountCreate();
      user = Functions.GetHiveUser();
      accountBloc = BlocProvider.of<AccountBloc>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        accountBloc.add(FetchTypeAccounts());
        accountBloc.add(FetchAccounts(user.id!));
      });
      
      isLoading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Cuentas", style: TextStyle(color: Colors.black)),
        backgroundColor: ThemeColors.BLUE_GREEN_LIGHT,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              // Handle logout action
              isLoading = false;
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
        onPressed: () {
          isLoading = false;
          _addAccount(context, user.id!);
        },
        child: const Icon(Icons.add, color: ThemeColors.BLUE_WHITE),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountTypeLoaded){
          typeAccounts = state.typeAccounts;
        } else if (state is AccountSaved) {
          // Handle successful account creation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: state.message != null ? Text(state.message!) : const Text('Account created successfully')),
          );
          Navigator.pop(context);
        } else if (state is AccountError) {
          // Handle error state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AccountError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is AccountLoaded) {
              accounts = state.accounts;
            }else if(state is AccountTypeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AccountTypeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is AccountTypeLoaded && state.typeAccounts.isNotEmpty) {
              typeAccounts = state.typeAccounts;
            } else if (state is AccountSaved){
              accounts = state.accounts ?? [];
            }
            return _accountList(accounts);
          },
        );
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
            onTap: () {
              isLoading = false;
              Navigator.pushNamed(context, 'dashboard', arguments: account.id);
            },
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
  
  void _addAccount(BuildContext context, int i) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Agregar Cuenta"),
        content: SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: "Nombre de la Cuenta",
                    onChanged: (value) => account.name = value,
                  ),
                  CustomTextField(
                    hintText: "Descripcion",
                    onChanged: (value) => account.description = value,
                  ),
                  CustomDropdown<TypeAccount>(
                    items: typeAccounts,
                    selectedItem: account.typeAccount,
                    hintText: "Tipo de Cuenta",
                    onChanged: (value) => account.typeAccount = value,
                  ),
                  CustomButton(onPressed: () => _createAccount(), text: "Guardar"),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
      );
    });
  }
  
  _createAccount() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      accountCreate.name = account.name;
      accountCreate.description = account.description;
      accountCreate.typeAccountId = account.typeAccount!.id;
      accountCreate.userId = user.id;
      accountBloc.add(AddAccount(accountCreate));
    }
  }
}
