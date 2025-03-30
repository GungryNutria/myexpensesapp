part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class SignInLoading extends LoginState {}

final class SignInLoaded extends LoginState {}

final class SignInSuccess extends LoginState {
  final String message;
  SignInSuccess(this.message);
}

final class SignInError extends LoginState {
  final String message;
  SignInError(this.message);
}
