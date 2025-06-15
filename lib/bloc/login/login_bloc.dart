import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:myexpensesapp/models/login_model.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/services/user_provider.dart';
import 'package:myexpensesapp/utils/functions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserProvider userProvider = UserProvider();
  LoginBloc() : super(LoginInitial()) {
    on<SignIn>(_signIn);
  }

  FutureOr<void> _signIn(SignIn event, Emitter<LoginState> emit) async {
    try{
      emit(SignInLoading());
      final response = await userProvider.loginUser(event.user);
      if(response is User){
        Box box = Hive.box('UserBox');
        String data = Functions.ConvertInJsonString(response.toJson());
        box.put("data", data);
        emit(SignInSuccess());
      }else{
        emit(SignInError(message: response.message));
      }
    }catch(e){
      emit(SignInError(message: e.toString()));
    }
  }


  
}
