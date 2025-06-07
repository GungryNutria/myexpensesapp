import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ModifyAccountPage extends StatefulWidget {
  const ModifyAccountPage({super.key});

  @override
  State<ModifyAccountPage> createState() => _ModifyAccountPageState();
}

class _ModifyAccountPageState extends State<ModifyAccountPage> {
  late AccountBloc accountBloc;
  late Account account;
  late User user;
  late AccountCreate accountCreate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    account = Account();
    accountCreate = AccountCreate();
    user = Functions.GetHiveUser();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    context.read<AccountBloc>().add(FetchTypeAccounts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modificar Cuenta", style: TextStyle(color: Colors.black),),
        backgroundColor: ThemeColors.BLUE_GREEN_LIGHT,),
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountSaved) {
              // Handle successful account creation
              Navigator.pushReplacementNamed(context,'home');
            } else if (state is AccountError) {
              // Handle error state
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
            }
          },
          builder: (context, state) {
            return BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountTypeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AccountTypeLoaded) {
                  return _formAccount(state.typeAccounts);
                } else if (state is AccountTypeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No type accounts found'));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _formAccount(List<TypeAccount> typeAccounts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
    );
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
