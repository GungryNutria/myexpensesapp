part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class FetchAccounts extends AccountEvent {
  final int userId;

  FetchAccounts(this.userId);
}

class FetchTypeAccounts extends AccountEvent {}



class AddAccount extends AccountEvent {
  final AccountCreate account;

  AddAccount(this.account);
}