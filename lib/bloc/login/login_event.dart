part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignIn extends LoginEvent {
  final LoginModel user;

  SignIn(this.user);
}
