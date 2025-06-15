import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myexpensesapp/models/account.dart';
import 'package:myexpensesapp/models/account_create.dart';
import 'package:myexpensesapp/models/error_details.dart';
import 'package:myexpensesapp/models/type_account.dart';
import 'package:myexpensesapp/services/account_service.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountService accountService = AccountService();
  AccountBloc() : super(AccountInitial()) {
    on<FetchTypeAccounts>(_fetchTypeAccounts);
    on<AddAccount>(_addAccount);
    on<FetchAccounts>(_fetchAccounts);
  }

  FutureOr<void> _fetchTypeAccounts(
    FetchTypeAccounts event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(AccountTypeLoading());
      var response = await accountService.getTypeAccounts();
      if (response is List<TypeAccount>) {
        emit(AccountTypeLoaded(response));
      } else {
        emit(AccountTypeError(response.message));
      }
    } catch (e) {
      emit(AccountTypeError(e.toString()));
    }
  }

  FutureOr<void> _addAccount(
    AddAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(AccountLoading());
      var response = await accountService.addAccount(event.account);
      
      if (response is Account) {
        var newAccountList = await accountService.getAccounts(event.account.userId!);
        emit(AccountSaved(message: "Account created successfully",accounts: newAccountList));
      } else if (response is Errordetails) {
        emit(AccountError(response.message!));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  FutureOr<void> _fetchAccounts(
    FetchAccounts event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(AccountLoading());
      var response = await accountService.getAccounts(event.userId);
      if (response.isEmpty) {
        emit(AccountError("No accounts found"));
      } else {
        emit(AccountLoaded(response));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
