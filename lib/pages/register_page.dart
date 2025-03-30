import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myexpensesapp/bloc/user/user_bloc.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';
import 'package:myexpensesapp/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  User user = User();

  String password = "";
  String rpassword = "";

  late UserBloc userBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        backgroundColor: ThemeColors.BLUE_DARK,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSaved) {
          Navigator.pushNamed(context, 'address');
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        if (state is UserSaving)
          return const CircularProgressIndicator(
            color: ThemeColors.BLUE_DARK,
          );
        return SingleChildScrollView(
          child: Column(
            children: [_form()],
          ),
        );
      },
    ));
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _username(),
              _email(),
              _password(),
              _rpassword(),
              _nextButton()
            ],
          ),
        ));
  }

  Widget _username() {
    return CustomTextField(
        hintText: 'Username',
        obscureText: false,
        onChanged: (value) => user.username = value);
  }

  Widget _email() {
    return CustomTextField(
        hintText: 'Correo Electronico',
        obscureText: false,
        onChanged: (value) => user.email = value);
  }

  Widget _password() {
    return CustomTextField(
        hintText: 'Contraseña',
        obscureText: true,
        onChanged: (value) => password = value);
  }

  Widget _rpassword() {
    return CustomTextField(
        hintText: 'Repetir Contraseña',
        obscureText: true,
        onChanged: (value) => rpassword = value);
  }

  Widget _nextButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => {},
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.BLUE_DARK,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        child: const Text(
          "Registrarse",
          textAlign: TextAlign.center,
          style: TextStyle(color: ThemeColors.BLUE_WHITE, fontSize: 20),
        ),
      ),
    );
  }
}
