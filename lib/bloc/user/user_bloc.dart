import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/services/user_provider.dart';
import 'package:myexpensesapp/utils/functions.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserProvider userProvider = UserProvider();
  UserBloc() : super(UserInitial()) {
    on<SaveUser>(_saveUser);
  }

  FutureOr<void> _saveUser(SaveUser event, Emitter<UserState> emit) async{
    try {
      emit(UserSaving());
      var response = await userProvider.registerUser(event.user);
      if (response is User) {
        Box box = Hive.box('UserBox');
        String data = Functions.ConvertInJsonString(response.toJson());
        emit(UserSaved());
        box.put('data', data);
      } else {
        emit(ErrorState(errorMessage: response.message));
      }
    }catch(e){
      emit(ErrorState(errorMessage: e.toString()));
    }
  }
}
