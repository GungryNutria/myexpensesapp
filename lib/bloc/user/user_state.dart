part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSaving extends UserState {}

class UserSaved extends UserState {}

class ErrorState extends UserState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}
