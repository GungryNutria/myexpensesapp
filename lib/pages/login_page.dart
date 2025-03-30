import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myexpensesapp/bloc/login/login_bloc.dart';
import 'package:myexpensesapp/models/login_model.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginModel _loginModel = LoginModel();
  late LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: Center(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SignInLoaded) {
            Navigator.pushReplacementNamed(context, 'home');
          } else if (state is SignInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _logo(),
                _form(),
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget _logo() {
    return const Icon(
      Icons.account_circle_outlined,
      size: 150,
      color: ThemeColors.BLUE_DARK,
    );
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _email(),
              _password(),
              _forgetPassword(),
              _loginButton(),
              _registerButton()
            ],
          ),
        ));
  }

  Widget _email() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            filled: false,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: ThemeColors.BLUE_GREEN_LIGHT)),
            hintText: 'Correo Electronico'),
        onSaved: (value) => _loginModel.usernameOrEmail = value!,
        validator: (value) {
          if (value == null || value.isEmpty || !value.contains('@')) {
            return 'Por favor ingrese un correo electronico';
          }
          String pattern = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Por favor ingrese un correo electrónico válido';
          }
          return null;
        },
      ),
    );
  }

  _password() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            filled: false,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: ThemeColors.BLUE_GREEN_LIGHT)),
            hintText: 'Contraseña'),
        onSaved: (value) => _loginModel.password = value!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese su contraseña';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget _forgetPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
          text: const TextSpan(children: [
        TextSpan(
            text: '¿Olvidaste tu contraseña? ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            )),
        TextSpan(
          text: "Click Aqui",
          style: TextStyle(
              color: ThemeColors.BLUE_DARK,
              fontSize: 16.0,
              decoration: TextDecoration.underline),
        )
      ])),
    );
  }

  Widget _loginButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loginUser,
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.BLUE_DARK,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        child: const Text(
          "Iniciar Sesion",
          textAlign: TextAlign.center,
          style: TextStyle(color: ThemeColors.BLUE_WHITE, fontSize: 20),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "register"),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.BLUE_GREEN,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        child: const Text(
          "Crear Cuenta",
          textAlign: TextAlign.center,
          style: TextStyle(color: ThemeColors.BLUE_WHITE, fontSize: 20),
        ),
      ),
    );
  }

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _loginBloc.add(SignIn(_loginModel));
    }
  }
}
