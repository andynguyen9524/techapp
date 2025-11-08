abstract class LoginState {}

class LoadingLoginState extends LoginState {}

class isLoginState extends LoginState {}

class LoginOnPressState extends LoginState {
  final String email;
  final String password;

  LoginOnPressState(this.email, this.password);
}

class RegisterOnPressState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}

class LoginSuccessState extends LoginState {}
