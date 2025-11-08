import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Login/login_state.dart';

class LoginController extends Cubit<LoginState> {
  LoginController() : super(LoadingLoginState());

  Future<void> onfetchLogin() async {
    emit(LoadingLoginState());
    await Future.delayed(const Duration(milliseconds: 200));
    emit(isLoginState());
  }

  Future<void> onLoginPress(String email, String password) async {
    // emit(LoginOnPressState(email, password));
    if (email.isEmpty || password.isEmpty) {
      emit(LoginErrorState('Email and password cannot be empty'));
    } else {
      emit(LoginSuccessState());
    }
  }
}
