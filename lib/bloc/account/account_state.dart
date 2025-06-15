part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<Account> accounts;

  AccountLoaded(this.accounts);
}
class AccountSaved extends AccountState {
  final String? message;
  final List<Account>? accounts;
  AccountSaved({this.message, this.accounts});
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}

class AccountTypeLoaded extends AccountState {
  final List<TypeAccount> typeAccounts;
  AccountTypeLoaded(this.typeAccounts);
}
class AccountTypeError extends AccountState {
  final String message;
  AccountTypeError(this.message);
}
class AccountTypeLoading extends AccountState {}
