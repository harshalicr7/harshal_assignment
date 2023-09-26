part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState({required this.isLoading});
}

final class LoginSuccessState extends LoginState {
  final Map<String, dynamic> data;

  LoginSuccessState({required this.data});
}

final class LoginErrorState extends LoginState {
  final Exception error;

  LoginErrorState({required this.error});
}
